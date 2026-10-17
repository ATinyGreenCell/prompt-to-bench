#!/usr/bin/env python3
"""Opus distillation: generate render-verified OpenSCAD training data.

For each bench-style part description (from gen_prompts.py) this:
  1. asks Opus for the OpenSCAD via the Claude Code CLI in print mode
     (`claude -p`), exactly as bench/run_bench.py's "claude:" backend does -
     replaced system prompt, no tools, no MCP, no project settings;
  2. extracts the ```openscad code block from the reply;
  3. render-verifies it with the benchmark's own renderer (rft_score.measure ->
     tools/scadreport.render + trimesh): keep only a valid, non-degenerate,
     watertight solid (renders, watertight, volume >= VOL_MIN, >= TRI_MIN
     triangles, >= 1 body);
  4. optionally checks dimensional fidelity: the rendered bounding box must be
     within --bbox-tol of the outer (X,Y,Z) size the generator put in the prompt
     (dropped otherwise);
  5. writes kept ones in the train.jsonl schema ({"messages":[system,user,
     assistant]}, assistant = a ```openscad block) with the EXACT system prompt
     from finetune/data/eval_prompts.json.

Sharding: with --prompts-file, this processes the stride prompts[shard::num_shards]
so several copies run in parallel over disjoint, family-balanced slices.

Budget: every `claude -p` is one paid call. --max-claude-calls is a hard per-process
cap the driver never exceeds (at most one retry per prompt, only on an infra error,
and only while under the cap). Run N shards with per-shard caps summing below the
global safety cap.

    .venv/bin/python distill.py --prompts-file prompts_scaleup.jsonl \
        --num-shards 5 --shard 0 --max-claude-calls 80 --bbox-tol 0.15 \
        --out shard0.jsonl --tag shard0
"""
from __future__ import annotations

import argparse
import datetime as dt
import json
import os
import re
import shutil
import subprocess
import sys
import tempfile
import time

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = "/home/seb/printpaper"
os.environ.setdefault("OPENSCAD", "/home/seb/.local/bin/openscad")   # scadreport reads this at import
sys.path.insert(0, HERE)
sys.path.insert(0, os.path.join(ROOT, "finetune", "scripts"))
import gen_prompts  # noqa: E402
import rft_score     # noqa: E402

EVAL_PROMPTS = os.path.join(ROOT, "finetune", "data", "eval_prompts.json")
MODEL_DEFAULT = "claude-opus-5-5"
VOL_MIN = 20.0
TRI_MIN = 12
FENCE = re.compile(r"```[ \t]*([A-Za-z0-9_+-]*)[^\n]*\n(.*?)```", re.S)


def strip_think(text: str) -> str:
    text = re.sub(r"<think>.*?(</think>|$)", "", text or "", flags=re.S)
    return text.rsplit("</think>", 1)[1] if "</think>" in text else text


def extract_code(text: str):
    text = strip_think(text or "")
    blocks = [(lang, b) for lang, b in FENCE.findall(text) if b.strip()]
    if not blocks:
        return None, "none"
    labelled = [b for lang, b in blocks if lang.lower() in ("openscad", "scad")]
    cands = labelled or [b for _, b in blocks]
    return max(cands, key=len).strip(), "fenced"


def opus_generate(model: str, system: str, user: str, cwd: str, timeout: int) -> dict:
    cmd = ["claude", "-p", "--model", model, "--system-prompt", system, "--tools", "",
           "--strict-mcp-config", "--setting-sources", "", "--output-format", "json", user]
    t0 = time.time()
    try:
        p = subprocess.run(cmd, capture_output=True, text=True, timeout=timeout, cwd=cwd)
    except subprocess.TimeoutExpired:
        return {"ok": False, "error": f"timeout after {timeout}s", "wall_s": round(time.time() - t0, 1)}
    except FileNotFoundError:
        return {"ok": False, "error": "claude CLI not found on PATH", "wall_s": 0.0}
    try:
        d = json.loads(p.stdout)
    except json.JSONDecodeError:
        return {"ok": False, "error": f"non-JSON reply: {(p.stdout or p.stderr)[:200]!r}",
                "wall_s": round(time.time() - t0, 1)}
    if not isinstance(d, dict) or d.get("is_error"):
        return {"ok": False, "error": str(d.get("result") if isinstance(d, dict) else d)[:200],
                "wall_s": round(time.time() - t0, 1)}
    u = d.get("usage", {}) or {}
    return {"ok": True, "text": d.get("result", ""), "gen_tokens": u.get("output_tokens"),
            "wall_s": round(time.time() - t0, 1)}


def bbox_check(rendered, expected, tol):
    """(ok, per-axis relative errors). ok => every axis within tol of the expected size."""
    ok, ratios = True, []
    for r, e in zip(rendered, expected):
        if not e or e <= 0:
            ratios.append(None)
            continue
        rel = abs(r - e) / e
        ratios.append(round(rel, 3))
        if rel > tol:
            ok = False
    return ok, ratios


def verify(code, timeout, expected_bbox, bbox_tol):
    """(kept, measure-dict). kept => valid non-degenerate watertight solid AND (if an
    expected bbox and tol are given) rendered bbox within tol on every axis."""
    m = rft_score.measure(code, timeout=timeout)
    if not m.get("ok"):
        m["kept"] = False
        m.setdefault("reason", "render/watertight failed")
        return False, m
    nd = m.get("volume", 0) >= VOL_MIN and m.get("triangles", 0) >= TRI_MIN and m.get("bodies", 0) >= 1
    if not nd:
        m["kept"] = False
        m["reason"] = f"degenerate: volume={m.get('volume'):.2f} tri={m.get('triangles')} bodies={m.get('bodies')}"
        return False, m
    if expected_bbox and bbox_tol and bbox_tol > 0:
        bb_ok, ratios = bbox_check(m["bbox"], expected_bbox, bbox_tol)
        m["bbox_expected"] = [round(v, 2) for v in expected_bbox]
        m["bbox_err"] = ratios
        if not bb_ok:
            m["kept"] = False
            m["reason"] = (f"bbox off >{int(bbox_tol * 100)}%: got {[round(v, 1) for v in m['bbox']]} "
                           f"vs {[round(v, 1) for v in expected_bbox]} (err {ratios})")
            return False, m
    m["kept"] = True
    return True, m


def main() -> None:
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--prompts-file", default=None, help="JSONL of {id,family,user,bbox}; else generate from --n/--seed")
    ap.add_argument("--n", type=int, default=336)
    ap.add_argument("--seed", type=int, default=20261017)
    ap.add_argument("--num-shards", type=int, default=1)
    ap.add_argument("--shard", type=int, default=0)
    ap.add_argument("--model", default=MODEL_DEFAULT)
    ap.add_argument("--max-claude-calls", type=int, default=80)
    ap.add_argument("--retries", type=int, default=1, help="extra tries on an infra error (not render fail)")
    ap.add_argument("--render-timeout", type=int, default=120)
    ap.add_argument("--call-timeout", type=int, default=900)
    ap.add_argument("--bbox-tol", type=float, default=0.15)
    ap.add_argument("--start-delay", type=float, default=0.0, help="sleep before starting (stagger parallel shards)")
    ap.add_argument("--out", default="pilot.jsonl")
    ap.add_argument("--tag", default="pilot")
    a = ap.parse_args()

    out_path = a.out if os.path.isabs(a.out) else os.path.join(HERE, a.out)
    cand_dir = os.path.join(HERE, "cand")
    os.makedirs(cand_dir, exist_ok=True)

    if a.prompts_file:
        pf = a.prompts_file if os.path.isabs(a.prompts_file) else os.path.join(HERE, a.prompts_file)
        allp = [json.loads(l) for l in open(pf, encoding="utf-8") if l.strip()]
        prompts = allp[a.shard::a.num_shards]
    else:
        prompts = gen_prompts.generate(a.n, a.seed)
    with open(os.path.join(HERE, f"prompts_{a.tag}.jsonl"), "w", encoding="utf-8") as fh:
        fh.write("\n".join(json.dumps(p, ensure_ascii=False) for p in prompts) + "\n")

    system = json.load(open(EVAL_PROMPTS))["system"]
    cwd = tempfile.mkdtemp(prefix="distill_claude_")
    calls, kept, records = 0, 0, []
    drop_reasons = {"render": 0, "degenerate": 0, "bbox": 0, "no_code": 0, "call": 0}
    if a.start_delay:
        time.sleep(a.start_delay)
    started = dt.datetime.now().isoformat(timespec="seconds")
    print(f"{started}  {a.tag}: model={a.model} prompts={len(prompts)} cap={a.max_claude_calls} "
          f"bbox_tol={a.bbox_tol}", flush=True)
    open(out_path, "w").close()

    for p in prompts:
        if calls >= a.max_claude_calls:
            print(f"  {a.tag}: budget reached ({calls}/{a.max_claude_calls}) - stopping", flush=True)
            break
        g = {"ok": False, "error": "not called"}
        used = 0
        for attempt in range(a.retries + 1):
            if calls >= a.max_claude_calls:
                break
            calls += 1
            used += 1
            g = opus_generate(a.model, system, p["user"], cwd, a.call_timeout)
            if g["ok"]:
                break
            if attempt < a.retries:
                time.sleep(8)
        rec = {"id": p["id"], "family": p["family"], "bbox_expected": p.get("bbox"),
               "calls_used": used, "call_ok": g["ok"], "wall_s": g.get("wall_s"),
               "gen_tokens": g.get("gen_tokens")}
        code, how = (None, "none")
        if g["ok"]:
            code, how = extract_code(g["text"])
            with open(os.path.join(cand_dir, f"{a.tag}_{p['id']}.reply.txt"), "w", encoding="utf-8",
                      errors="replace") as fh:
                fh.write(g["text"])
        else:
            rec["call_error"] = g.get("error")
        rec["extract"] = how
        if code:
            with open(os.path.join(cand_dir, f"{a.tag}_{p['id']}.scad"), "w", encoding="utf-8",
                      errors="replace") as fh:
                fh.write(code)
            rec["code_lines"] = code.count("\n") + 1
            ok, m = verify(code, a.render_timeout, p.get("bbox"), a.bbox_tol)
            rec["render"] = {k: m.get(k) for k in
                             ("ok", "watertight", "volume", "bodies", "triangles", "bbox", "bbox_err", "reason")}
            rec["kept"] = ok
            if ok:
                kept += 1
                example = {"messages": [
                    {"role": "system", "content": system},
                    {"role": "user", "content": p["user"]},
                    {"role": "assistant", "content": f"```openscad\n{code}\n```"}]}
                with open(out_path, "a", encoding="utf-8") as fh:
                    fh.write(json.dumps(example, ensure_ascii=False) + "\n")
            else:
                reason = m.get("reason", "")
                drop_reasons["bbox" if reason.startswith("bbox") else
                             "degenerate" if reason.startswith("degenerate") else "render"] += 1
        else:
            rec["kept"] = False
            drop_reasons["no_code" if g["ok"] else "call"] += 1
            rec.setdefault("render", {"ok": False, "reason": "no code extracted" if g["ok"] else "call failed"})
        records.append(rec)
        v = rec.get("render", {})
        detail = (f"vol={v.get('volume'):.0f} tri={v.get('triangles')} bbox_err={v.get('bbox_err')}"
                  if v.get("ok") else (v.get("reason") or rec.get("call_error") or "failed"))
        print(f"{dt.datetime.now():%H:%M:%S}  {a.tag} {p['id']:22s} c{calls:<3d} "
              f"{'KEPT' if rec['kept'] else 'drop'}  {detail}", flush=True)

    enc = re.sub(r"[^A-Za-z0-9]", "-", cwd)
    shutil.rmtree(os.path.join(os.path.expanduser("~/.claude/projects"), enc), ignore_errors=True)
    shutil.rmtree(cwd, ignore_errors=True)

    summary = {"started": started, "finished": dt.datetime.now().isoformat(timespec="seconds"),
               "tag": a.tag, "shard": a.shard, "num_shards": a.num_shards, "model": a.model,
               "prompts": len(prompts), "claude_calls": calls, "max_claude_calls": a.max_claude_calls,
               "kept": kept, "dropped": len(records) - kept, "drop_reasons": drop_reasons,
               "yield": round(kept / len(records), 3) if records else None,
               "bbox_tol": a.bbox_tol, "out": out_path, "records": records}
    with open(os.path.join(HERE, f"distill_log_{a.tag}.json"), "w") as fh:
        json.dump(summary, fh, indent=1)
    print(f"\nDONE {a.tag}  kept {kept}/{len(records)}  calls {calls}  drops {drop_reasons}  -> {out_path}", flush=True)


if __name__ == "__main__":
    main()
