#!/usr/bin/env python3
"""Build the rejection-sampling PROMPT set: {prompt, ref_scad} pairs the model will be asked to
re-solve on the pod, each with a known-correct reference so rft_score can reward a match.

It reuses augment.py verbatim (same verify/scadreport gate), so every reference renders watertight
by construction. A FRESH rng (default today's date) draws parameter combinations held out from the
training set (--rng 0), and any prompt that still collides with a training prompt is dropped, so the
RFT set is a clean generalisation probe. Balanced: up to --per-family prompts per seed.

Disjoint from the 16 eval tasks by construction (the seeds are). Output lives OUTSIDE finetune/data/
so build_dataset.py never ingests it as training data (it has `ref_scad`, not `scad`).

usage: ~/printpaper/.venv/bin/python -I build_rft_prompts.py [--per-family 8] [--rng 20261015]
"""
from __future__ import annotations

import argparse
import json
import pathlib
import re
import subprocess
import sys

ROOT = pathlib.Path("/home/seb/printpaper")
FT = ROOT / "finetune"
PY = ROOT / ".venv" / "bin" / "python"
AUGMENT = FT / "scripts" / "augment.py"
TAIL = re.compile(r"\s*Reply with .*?(?:OpenSCAD file|code block)\.?\s*$", re.I | re.S)


def strip_tail(p: str) -> str:
    return TAIL.sub("", p).strip()


def training_prompts() -> set:
    """The tail-stripped user prompts already in the training/val split, to hold the RFT set out from."""
    seen = set()
    for name in ("train.jsonl", "val.jsonl"):
        f = FT / "data" / name
        if not f.exists():
            continue
        for ln in f.open():
            ln = ln.strip()
            if not ln:
                continue
            msgs = json.loads(ln).get("messages", [])
            u = next((m["content"] for m in msgs if m.get("role") == "user"), None)
            if u:
                seen.add(strip_tail(u))
    return seen


def main() -> None:
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--per-family", type=int, default=8, help="prompts to keep per seed family")
    ap.add_argument("--tries", type=int, default=50, help="combinations augment samples per family (> per-family, to survive filtering)")
    ap.add_argument("--rng", type=int, default=20261015, help="random seed (held out from training --rng 0)")
    ap.add_argument("--timeout", type=int, default=60)
    ap.add_argument("--out", type=pathlib.Path, default=FT / "rft" / "rft_prompts.jsonl")
    ap.add_argument("--min-total", type=int, default=100, help="fail the build if fewer total prompts than this")
    a = ap.parse_args()

    seeds = sorted((FT / "seeds").glob("*.scad"))
    if not seeds:
        sys.exit("no seeds found")
    stage = a.out.parent / "aug"
    stage.mkdir(parents=True, exist_ok=True)
    train = training_prompts()
    print(f"held-out against {len(train)} existing training prompts", flush=True)

    rows, counts, overlap_drop, seen_prompts = [], {}, 0, set()
    for s in seeds:
        dst = stage / f"{s.stem}.jsonl"
        r = subprocess.run([str(PY), "-I", str(AUGMENT), str(s), "-n", str(a.tries),
                            "--rng", str(a.rng), "-o", str(dst), "--timeout", str(a.timeout)],
                           capture_output=True, text=True)
        if r.returncode != 0:
            sys.exit(f"augment failed on {s.stem}: {r.stderr.strip() or r.stdout.strip()}")
        kept = 0
        for ln in dst.open():
            ln = ln.strip()
            if not ln or kept >= a.per_family:
                continue
            rec = json.loads(ln)
            prompt = strip_tail(rec["prompt"])
            ref = rec["scad"].strip()
            if not prompt or not ref:
                continue
            if prompt in train:                    # already a training prompt: hold it out
                overlap_drop += 1
                continue
            if prompt in seen_prompts:              # dup within the RFT set
                continue
            seen_prompts.add(prompt)
            rows.append({"seed": rec["seed"], "prompt": prompt, "ref_scad": ref})
            kept += 1
        counts[s.stem] = kept

    a.out.parent.mkdir(parents=True, exist_ok=True)
    with a.out.open("w") as fh:
        for row in rows:
            fh.write(json.dumps(row) + "\n")

    empty = [k for k, v in counts.items() if v == 0]
    thin = {k: v for k, v in counts.items() if 0 < v < a.per_family}
    print(f"wrote {len(rows)} RFT prompts across {len(counts)} families -> {a.out}")
    if overlap_drop:
        print(f"  dropped {overlap_drop} that collided with training prompts")
    if thin:
        print(f"  thin families (< {a.per_family}): {thin}")
    if empty:
        sys.exit(f"NO-GO: families produced zero prompts: {empty}")
    if len(rows) < a.min_total:
        sys.exit(f"NO-GO: only {len(rows)} prompts (< --min-total {a.min_total})")
    print("GO - RFT prompt set ready.")


if __name__ == "__main__":
    main()
