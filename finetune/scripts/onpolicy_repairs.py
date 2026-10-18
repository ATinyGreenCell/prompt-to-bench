#!/usr/bin/env python3
"""On-policy repair data: the model's OWN failed attempts, the benchmark's report of them, and the correct file.

v5's synthetic repairs (one perturbed parameter) improved first attempts but not repairs: every fine-tune
rewrote its file after only 6-15% of feedback messages and won no pass by repair (README §6.4). The benchmark
shows a model a report of ITS OWN part, so the repair data should start from the model's own typical mistakes.

  prompts   build the prompt pool: held-out distilled pairs (batch A + B) + generic augment pairs from
            data/train.jsonl - every prompt gated against the 16 eval prompts - with the reference file.
  build     score each on-policy attempt (onpolicy_generate.py) against its reference with rft_score's
            tolerances (bbox, volume, bodies, triangle floor); for each failure write the eval's own
            conversation: description, the model's raw reply, the benchmark's feedback for it (measurement
            report, or OpenSCAD's errors), then the reference file. Train with MASK_EARLIER=1.

    python onpolicy_repairs.py prompts --n-augment 1620 --out ../rft/onpolicy/prompts.jsonl
    python onpolicy_repairs.py build --prompts ../rft/onpolicy/prompts.jsonl --attempts attempts.jsonl \
        --out ../data/onpolicy_repairs.jsonl
"""
from __future__ import annotations

import argparse
import glob
import json
import os
import random
import sys
import tempfile
from concurrent.futures import ProcessPoolExecutor

ROOT = "/home/seb/printpaper"
os.environ.setdefault("OPENSCAD", "/home/seb/.local/bin/openscad")
sys.path[:0] = [os.path.join(ROOT, "tools"), os.path.join(ROOT, "bench"), os.path.join(ROOT, "finetune", "scripts"),
                os.path.join(ROOT, "finetune", "rft", "distill")]
from scadreport import analyse, format_report, load_mesh, render  # noqa: E402
import rft_score  # noqa: E402


def user_of(msgs):
    return next(m["content"] for m in msgs if m["role"] == "user")


def code_of(text):
    import run_bench
    code, _how = run_bench.extract_code(text or "")
    return code


def cmd_prompts(a) -> None:
    from gen_prompts_clean import eval_token_sets, max_jaccard
    evs = eval_token_sets()
    pool = []
    for f in sorted(glob.glob(os.path.join(ROOT, "finetune/rft/distill/clean_shard*.jsonl")) +
                    glob.glob(os.path.join(ROOT, "finetune/rft/distill/clean_b_shard*.jsonl"))):
        for i, l in enumerate(open(f)):
            m = json.loads(l)["messages"]
            pool.append({"id": f"d:{os.path.basename(f)}:{i}", "messages": m[:2], "ref": code_of(m[-1]["content"])})
    aug = []
    for i, l in enumerate(open(os.path.join(ROOT, "finetune/data/train.jsonl"))):
        m = json.loads(l)["messages"]
        if len(m) == 3 and "```" not in m[1]["content"]:
            aug.append({"id": f"a:{i}", "messages": m[:2], "ref": code_of(m[-1]["content"])})
    random.Random(a.seed).shuffle(aug)
    pool += aug[: a.n_augment]
    pool = [p for p in pool if p["ref"]]
    worst = max(max_jaccard(user_of(p["messages"]), evs)[0] for p in pool)
    if worst > 0.40:
        raise SystemExit(f"ABORT: a prompt is too close to an eval prompt (Jaccard {worst:.3f})")
    os.makedirs(os.path.dirname(os.path.abspath(a.out)), exist_ok=True)
    with open(a.out, "w", encoding="utf-8") as fh:
        for p in pool:
            fh.write(json.dumps(p, ensure_ascii=False) + "\n")
    print(f"{len(pool)} prompts (distilled {sum(p['id'].startswith('d:') for p in pool)}, augment "
          f"{sum(p['id'].startswith('a:') for p in pool)}), max eval Jaccard {worst:.3f} -> {a.out}")


def _score(job):
    """(prompt, attempt, ref_measure) -> (kind, conversation-or-None)."""
    import run_bench
    p, att, ref = job
    reply = att["reply"] or ""
    code, how = run_bench.extract_code(reply)
    ref_code = p["ref"]
    target = {"role": "assistant", "content": f"```openscad\n{ref_code}\n```"}
    convo = lambda fb: [*p["messages"], {"role": "assistant", "content": reply}, {"role": "user", "content": fb}, target]  # noqa: E731
    if not code:
        return "no_code", convo(run_bench.feedback_message("report", {"ok": False, "messages": [], "log": ""}, None, "none"))
    with tempfile.TemporaryDirectory() as d:
        sp, stl = os.path.join(d, "a.scad"), os.path.join(d, "a.stl")
        open(sp, "w").write(code)
        try:
            rr = render(sp, stl, timeout=60)
        except Exception:  # noqa: BLE001
            return "error", None
        if not rr["ok"]:
            return "no_render", convo(run_bench.feedback_message("report", rr, None, how))
        try:
            mesh = load_mesh(stl)
            an = analyse(mesh)
        except Exception:  # noqa: BLE001
            return "error", None
        size = mesh.bounds[1] - mesh.bounds[0]
        ok = (an["watertight"]
              and all(abs(c - r) <= max(rft_score.BBOX_ABS, rft_score.BBOX_REL * r) for c, r in zip(size, ref["bbox"]))
              and ref["volume"] > 0 and abs(float(an["volume"]) - ref["volume"]) <= rft_score.VOL_REL * ref["volume"]
              and int(an["bodies"]) == ref["bodies"]
              and len(mesh.faces) >= rft_score.TRI_FLOOR * ref.get("triangles", 0))
        if ok:
            return "pass", None
        return "fail", convo(run_bench.feedback_message("report", rr, format_report(rr, an), how))


def _ref(p):
    return p["id"], rft_score.measure(p["ref"])


def cmd_build(a) -> None:
    prompts = {p["id"]: p for p in (json.loads(l) for l in open(a.prompts) if l.strip())}
    attempts = [json.loads(l) for l in open(a.attempts) if l.strip()]
    with ProcessPoolExecutor(a.workers) as ex:
        refs = dict(ex.map(_ref, prompts.values(), chunksize=8))
    jobs = [(prompts[t["id"]], t, refs[t["id"]]) for t in attempts if refs.get(t["id"], {}).get("ok")]
    counts, kept = {}, []
    with ProcessPoolExecutor(a.workers) as ex:
        for kind, convo in ex.map(_score, jobs, chunksize=8):
            counts[kind] = counts.get(kind, 0) + 1
            if convo:
                kept.append({"messages": convo})
    with open(a.out, "w", encoding="utf-8") as fh:
        for r in kept:
            fh.write(json.dumps(r, ensure_ascii=False) + "\n")
    stats = {"attempts": len(attempts), "scored": len(jobs), "outcomes": counts, "repairs_written": len(kept),
             "onpolicy_pass_rate": round(counts.get("pass", 0) / max(1, len(jobs)), 3)}
    json.dump(stats, open(a.out.replace(".jsonl", ".stats.json"), "w"), indent=1)
    print(json.dumps(stats, indent=1))


def main() -> None:
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    sub = ap.add_subparsers(dest="cmd", required=True)
    p1 = sub.add_parser("prompts")
    p1.add_argument("--n-augment", type=int, default=1620)
    p1.add_argument("--seed", type=int, default=20261018)
    p1.add_argument("--out", required=True)
    p2 = sub.add_parser("build")
    p2.add_argument("--prompts", required=True)
    p2.add_argument("--attempts", required=True)
    p2.add_argument("--workers", type=int, default=4)
    p2.add_argument("--out", required=True)
    a = ap.parse_args()
    cmd_prompts(a) if a.cmd == "prompts" else cmd_build(a)


if __name__ == "__main__":
    main()
