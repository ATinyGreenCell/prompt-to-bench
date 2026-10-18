#!/usr/bin/env python3
"""Choose one of k samples without the answer key (self-consistency over geometry).

Render every sample's final file, group the samples whose parts measure the same - bounding box to the
millimetre, its dimensions sorted so that orientation does not matter, and volume within 2% - and keep one
sample from the largest group (the earliest, on a tie the first such group). The selector sees only each
part's own size and volume, which a lab gets by rendering the file, never the hidden checks, so it turns k
samples into one answer a lab could act on. It is reported beside pass@1 (sample 0) and pass@k (any sample
passed - which needs the answer key to pick).

The size and volume are read from the candidate side of the check log ("size A x B x C vs [...]",
"volume V vs ref ..."); a sample whose final file did not render has neither and cannot be chosen.

usage: python bench/self_consistency.py gpu-base gpu-v5 gpu-v9 [--json out.json]
"""
from __future__ import annotations

import argparse
import collections
import json
import os
import re
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from sample_stats import rows_for  # noqa: E402

SIZE = re.compile(r"size ([\d.]+) x ([\d.]+) x ([\d.]+)")
VOL = re.compile(r"volume ([\d.]+)")


def measured(attempt: dict) -> tuple[tuple | None, float | None]:
    """(sorted bbox in whole mm, volume) of the candidate's own part, from its final attempt's check log."""
    bb = vol = None
    for it in (attempt.get("check") or {}).get("items") or []:
        m = SIZE.search(it.get("msg", ""))
        if m and it.get("check") == "bbox":
            bb = tuple(sorted(round(float(x)) for x in m.groups()))
        v = VOL.search(it.get("msg", ""))
        if v and it.get("check") == "volume":
            vol = float(v.group(1))
    return bb, vol


def select(rows: list[dict]) -> dict:
    by = collections.defaultdict(list)
    for r in rows:
        by[r["task"]].append(r)
    out = {"pass1": [], "pick": [], "passk": []}
    for task, rs in sorted(by.items()):
        rs.sort(key=lambda r: r.get("sample", 0))
        if rs[0]["passed"]:
            out["pass1"].append(task)
        if any(r["passed"] for r in rs):
            out["passk"].append(task)
        cands = []
        for r in rs:
            bb, vol = measured((r.get("attempts") or [{}])[-1])
            if bb and vol:
                cands.append((bb, vol, bool(r["passed"])))
        if not cands:
            continue
        size = [sum(1 for d in cands if d[0] == c[0] and abs(d[1] - c[1]) <= 0.02 * max(c[1], 1.0)) for c in cands]
        if cands[size.index(max(size))][2]:
            out["pick"].append(task)
    return out


def main() -> None:
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("runs", nargs="+")
    ap.add_argument("--json", default=None)
    a = ap.parse_args()
    res = {}
    print("| Run | pass@1 | self-consistency pick | pass@k |")
    print("|---|---:|---:|---:|")
    for run in a.runs:
        s = res[run] = select(rows_for(run))
        print(f"| {run} | {len(s['pass1'])}/16 | {len(s['pick'])}/16 | {len(s['passk'])}/16 |")
    for run, s in res.items():
        print(f"{run} picked and passed: {', '.join(s['pick']) or '-'}")
    if a.json:
        json.dump(res, open(a.json, "w"), indent=1)


if __name__ == "__main__":
    main()
