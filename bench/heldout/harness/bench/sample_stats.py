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
import re

HERE = os.path.dirname(os.path.abspath(__file__))


def rows_for(prefix: str) -> list[dict]:
    """A run's records, a split run (prefix-g0, -g1, ...) read as one, loaded as analyze.load_runs and analyze.dedupe
    load them: damaged lines and non-records are skipped, attempts after the first passing one (left by a rescore) are
    dropped, within a folder a conversation recorded twice keeps its newest record and one flagged needs_rerun is left
    out until run_bench.py has redone it, and across folders the newest record wins."""
    own = re.compile(re.escape(prefix) + r"(-g\d+)?")  # not prefix-gemma or prefix-gpu-x: a glob would take those
    paths = sorted(p for p in glob.glob(os.path.join(HERE, "results", f"{glob.escape(prefix)}*", "results.jsonl"))
                   if own.fullmatch(os.path.basename(os.path.dirname(p))))
    newest = {}
    for p in paths:
        latest = {}
        for line in open(p, encoding="utf-8", errors="replace"):
            try:
                r = json.loads(line)
            except json.JSONDecodeError:  # a half-written line from a crash, or a blank one
                continue
            if not isinstance(r, dict) or not {"model", "task", "sample", "attempts"} <= r.keys() \
                    or not isinstance(r["attempts"], list) or not all(isinstance(a, dict) for a in r["attempts"]):
                continue  # valid JSON but not a record
            first = next((i for i, a in enumerate(r["attempts"]) if a.get("passed")), None)
            if first is not None:  # the attempts after it would never have been requested
                r["attempts"] = r["attempts"][:first + 1]
            key = (r["model"], r["task"], r["sample"], r.get("lang", "en"), r.get("feedback", "report"))
            if key not in latest or str(r.get("finished", "")) >= str(latest[key].get("finished", "")):
                latest[key] = r
        for key, r in latest.items():
            if not r.get("needs_rerun") and (key not in newest or
                                             str(r.get("finished", "")) >= str(newest[key].get("finished", ""))):
                newest[key] = r
    return list(newest.values())


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
