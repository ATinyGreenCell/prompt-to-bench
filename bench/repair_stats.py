#!/usr/bin/env python3
"""How a model uses the benchmark's feedback (README §6.4, "Fine-tuned models stop listening").

Over every repair attempt - an attempt made after a feedback message - count how often the model changed its
file (the reply is not byte-identical code to the previous attempt's: Table 3's "same code after feedback",
inverted; a reply with no code counts as changed), how often the score rose, and which samples passed only
after a repair. A run split over several processes (results/<prefix>-g0 ... -g7) is read as one.

usage: python bench/repair_stats.py gpu-base gpu-v5 gpu-v9 [--json out.json]
"""
from __future__ import annotations

import argparse
import json
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from sample_stats import rows_for  # noqa: E402


def repair_stats(rows: list[dict]) -> dict:
    feedback = changed = improved = 0
    wins = []
    for r in rows:
        att = sorted(r.get("attempts") or [], key=lambda a: int(a.get("attempt", 0)))
        for prev, cur in zip(att, att[1:]):
            feedback += 1
            if cur.get("code_sha1") != prev.get("code_sha1"):
                changed += 1
            if (cur.get("score") or 0.0) > (prev.get("score") or 0.0):
                improved += 1
        if r.get("passed") and not r.get("first_pass"):
            wins.append(f"{r['task']}#{r.get('sample', 0)}")
    return {"samples": len(rows), "feedback": feedback, "changed": changed, "improved": improved,
            "repair_wins": sorted(wins)}


def main() -> None:
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("runs", nargs="+")
    ap.add_argument("--json", default=None)
    a = ap.parse_args()
    out = {}
    print("| Run | samples | feedback messages | file changed | score rose | passes won by repair |")
    print("|---|---:|---:|---:|---:|---:|")
    for run in a.runs:
        s = out[run] = repair_stats(rows_for(run))
        fb = max(1, s["feedback"])
        print(f"| {run} | {s['samples']} | {s['feedback']} | {s['changed']} ({100 * s['changed'] / fb:.0f}%) | "
              f"{s['improved']} ({100 * s['improved'] / fb:.0f}%) | {len(s['repair_wins'])} |")
    for run, s in out.items():
        if s["repair_wins"]:
            print(f"{run} won by repair: {', '.join(s['repair_wins'])}")
    if a.json:
        json.dump(out, open(a.json, "w"), indent=1)


if __name__ == "__main__":
    main()
