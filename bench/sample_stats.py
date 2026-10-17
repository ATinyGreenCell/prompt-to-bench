#!/usr/bin/env python3
"""Per-task pass statistics for multi-sample runs (e.g. --samples 8), merged across run folders.

A run split over several processes (bench/results/<prefix>-g0 ... -g7) is read as one. For each task:
pass@1 (sample 0 - the paper's one-sample protocol), the pass rate over all samples, pass@k (any sample
passed), first-attempt passes, and the best and mean best score. Totals count tasks.

usage: python bench/sample_stats.py gpu-v3 [gpu-v2 ...] [--json out.json]
"""
from __future__ import annotations

import argparse
import collections
import glob
import json
import os

HERE = os.path.dirname(os.path.abspath(__file__))


def rows_for(prefix: str) -> list[dict]:
    paths = sorted(glob.glob(os.path.join(HERE, "results", prefix, "results.jsonl")) +
                   glob.glob(os.path.join(HERE, "results", f"{prefix}-g*", "results.jsonl")))
    rows = []
    for p in paths:
        rows += [json.loads(l) for l in open(p, encoding="utf-8") if l.strip()]
    return rows


def stats(rows: list[dict]) -> dict:
    by = collections.defaultdict(list)
    for r in rows:
        by[r["task"]].append(r)
    out = {}
    for t, rs in sorted(by.items()):
        rs.sort(key=lambda r: r.get("sample", 0))
        best = [max([a.get("score") or 0.0 for a in r.get("attempts") or []] or [0.0]) for r in rs]
        out[t] = {"n": len(rs),
                  "pass1": bool(rs[0]["passed"]) if rs and rs[0].get("sample", 0) == 0 else None,
                  "passes": sum(bool(r["passed"]) for r in rs),
                  "first_attempt": sum(bool(r.get("first_pass")) for r in rs),
                  "rendered": sum(any((a.get("render") or {}).get("ok") for a in r.get("attempts") or []) for r in rs),
                  "best": round(max(best), 2), "mean_best": round(sum(best) / len(best), 2)}
    return out


def main() -> None:
    ap = argparse.ArgumentParser()
    ap.add_argument("runs", nargs="+")
    ap.add_argument("--json", default=None)
    a = ap.parse_args()
    allst = {}
    for run in a.runs:
        st = stats(rows_for(run))
        allst[run] = st
        n = max((v["n"] for v in st.values()), default=0)
        print(f"\n== {run}: {len(st)} tasks, up to {n} samples each")
        print(f"{'task':24s} {'pass@1':>6s} {'passes':>7s} {'1st':>4s} {'best':>5s} {'mean':>5s}")
        for t, v in st.items():
            p1 = "-" if v["pass1"] is None else ("PASS" if v["pass1"] else ".")
            print(f"{t:24s} {p1:>6s} {v['passes']:>3d}/{v['n']:<3d} {v['first_attempt']:>4d} {v['best']:5.2f} {v['mean_best']:5.2f}")
        tasks = len(st)
        print(f"{'TOTAL':24s} pass@1 {sum(bool(v['pass1']) for v in st.values())}/{tasks}  "
              f"pass@k {sum(v['passes'] > 0 for v in st.values())}/{tasks}  "
              f"sample pass rate {sum(v['passes'] for v in st.values())}/{sum(v['n'] for v in st.values())}  "
              f"rendered {sum(v['rendered'] for v in st.values())}/{sum(v['n'] for v in st.values())}")
    if a.json:
        json.dump(allst, open(a.json, "w"), indent=1)


if __name__ == "__main__":
    main()
