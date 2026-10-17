#!/usr/bin/env python3
"""Multi-turn repair examples in the benchmark's own conversation shape, with real measurement reports.

The benchmark's repair turn shows the model a measurement report of the part ITS OWN file built
(bench/run_bench.py feedback_message, kind "report"). The older repair data (make_feedback.py) put the
flawed file in the user turn, single-turn. These examples reproduce the eval conversation exactly:

    system | user: part description | assistant: flawed file | user: report of that file | assistant: correct file

For each verified (description, correct file) pair, one named top-of-file parameter is perturbed (a
dimension scaled, or a count changed by 1-2), the flawed file is rendered with the benchmark's renderer,
and its report is formatted with the benchmark's own scadreport + feedback_message, verbatim. A pair is
kept only if the flawed file renders and measurably differs from the correct one (bbox or volume).
Train on the LAST assistant turn only (train_vlm.py --last-turn-only): the flawed turn is context.

usage: python make_report_repairs.py --src a.jsonl b.jsonl --n 1500 --out ../data/report_repairs.jsonl
"""
from __future__ import annotations

import argparse
import json
import os
import random
import re
import sys
import tempfile
from concurrent.futures import ProcessPoolExecutor

ROOT = "/home/seb/printpaper"
os.environ.setdefault("OPENSCAD", "/home/seb/.local/bin/openscad")
sys.path.insert(0, os.path.join(ROOT, "tools"))
sys.path.insert(0, os.path.join(ROOT, "bench"))
from scadreport import analyse, format_report, load_mesh, render  # noqa: E402

FENCE = re.compile(r"```[ \t]*([A-Za-z0-9_+-]*)[^\n]*\n(.*?)```", re.S)
ASSIGN = re.compile(r"^(\s*)([A-Za-z_]\w*)(\s*=\s*)(-?\d+(?:\.\d+)?)(\s*;.*)$")
COUNT_HINT = re.compile(r"(^n_|^n$|count|num|rows|cols|holes|teeth|slots|pegs|wells|pockets|spokes|ribs)", re.I)


def feedback_message(rr, report_text):
    import run_bench  # the benchmark's own wording (single source of truth)
    return run_bench.feedback_message("report", rr, report_text, "fenced")


def code_of(text):
    blocks = [b for _, b in FENCE.findall(text or "") if b.strip()]
    return max(blocks, key=len).strip() if blocks else None


def perturb(code, rng):
    """Change one top-of-file numeric parameter. Returns (new_code, description) or None."""
    lines = code.split("\n")
    cands = []
    for i, ln in enumerate(lines[:60]):
        m = ASSIGN.match(ln)
        if m and m.group(2) not in ("$fn", "$fa", "$fs", "eps", "e", "epsilon", "tol"):
            v = float(m.group(4))
            if v > 0:
                cands.append((i, m, v))
    if not cands:
        return None
    i, m, v = rng.choice(cands)
    name = m.group(2)
    is_int = re.fullmatch(r"-?\d+", m.group(4)) is not None
    if is_int and (COUNT_HINT.search(name) or v <= 12):
        nv = max(1, int(v) + rng.choice([-2, -1, 1, 2]))
        if nv == v:
            return None
        txt = str(nv)
    else:
        nv = v * rng.choice([0.6, 0.75, 0.85, 1.2, 1.35, 1.6])
        txt = (str(int(round(nv))) if is_int else f"{nv:.4g}")
        if float(txt) == v:
            return None
    lines[i] = f"{m.group(1)}{name}{m.group(3)}{txt}{m.group(5)}"
    return "\n".join(lines), f"{name}: {m.group(4)} -> {txt}"


def measure(code, tmp):
    p, s = os.path.join(tmp, "x.scad"), os.path.join(tmp, "x.stl")
    with open(p, "w") as fh:
        fh.write(code)
    rr = render(p, s, timeout=60)
    if not rr["ok"]:
        return rr, None, None
    mesh = load_mesh(s)
    return rr, mesh, analyse(mesh)


def one(job):
    rec, seed = job
    rng = random.Random(seed)
    msgs = rec["messages"]
    system = msgs[0]["content"]
    user = next(m["content"] for m in msgs if m["role"] == "user")
    good = code_of(msgs[-1]["content"])
    if not good:
        return None
    with tempfile.TemporaryDirectory() as tmp:
        try:
            rr0, mesh0, _ = measure(good, tmp)
            if mesh0 is None:
                return None
            for _ in range(4):  # a few tries to find a perturbation that renders and changes the part
                pr = perturb(good, rng)
                if pr is None:
                    return None
                bad, what = pr
                rr, mesh, data = measure(bad, tmp)
                if mesh is None:
                    continue
                dv = abs(float(mesh.volume) - float(mesh0.volume)) / max(1e-6, abs(float(mesh0.volume)))
                db = float(abs(mesh.extents - mesh0.extents).max())
                if dv < 0.005 and db < 0.05:
                    continue
                fb = feedback_message(rr, format_report(rr, data))
                return {"messages": [
                    {"role": "system", "content": system},
                    {"role": "user", "content": user},
                    {"role": "assistant", "content": f"```openscad\n{bad}\n```"},
                    {"role": "user", "content": fb},
                    {"role": "assistant", "content": f"```openscad\n{good}\n```"}],
                    "perturbation": what}
        except Exception:  # noqa: BLE001 - a broken source pair is skipped, never fatal
            return None
    return None


def main() -> None:
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--src", nargs="+", required=True, help="jsonl files of verified single-turn pairs")
    ap.add_argument("--n", type=int, default=1500, help="target examples (sources are sampled evenly)")
    ap.add_argument("--seed", type=int, default=20261019)
    ap.add_argument("--workers", type=int, default=4)
    ap.add_argument("--out", required=True)
    a = ap.parse_args()
    pool = []
    for f in a.src:
        pool += [json.loads(l) for l in open(f) if l.strip()]
    # single-turn description -> file pairs only (not the older repair examples, whose user turn holds code)
    pool = [r for r in pool if len(r["messages"]) == 3 and "```" not in r["messages"][1]["content"]]
    rng = random.Random(a.seed)
    rng.shuffle(pool)
    jobs = [(r, a.seed + i) for i, r in enumerate(pool[: int(a.n * 1.4)])]  # headroom for skips
    kept = []
    with ProcessPoolExecutor(a.workers) as ex:
        for res in ex.map(one, jobs, chunksize=4):
            if res:
                kept.append(res)
                if len(kept) >= a.n:
                    break
    with open(a.out, "w", encoding="utf-8") as fh:
        for r in kept:
            fh.write(json.dumps(r, ensure_ascii=False) + "\n")
    print(f"kept {len(kept)} of {len(jobs)} tried -> {a.out}")


if __name__ == "__main__":
    main()
