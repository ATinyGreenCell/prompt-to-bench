#!/usr/bin/env python3
"""R4 summary (PROTOCOL.md, "R4 test plan"): aggregate counts only, so the held-out set stays sealed.

Per run and model, per sample: conversations, tasks passed within three attempts, first-attempt passes, first
files that build, median minutes a task. Then the pre-registered tests. Nothing per task is printed: no task ids,
check names or code.

    python3 -I r4_summary.py [--results DIR] [--pair A B ...] [--fisher A B ...]

Runs are folder names under --results (default: the held-out harness's results), optionally RUN@MODEL.
  --pair A B    Q2: a sign test over tasks on first-attempt passes per task (samples that passed on the first try),
                one-sided A > B, then the same on passes within three attempts, two-sided.
  --fisher A B  Q3: first files that render, A against B over conversations (one-sided, A > B), then passes
                within three attempts (two-sided).
"""
import argparse
import collections
import json
import os
import statistics

from scipy.stats import binomtest, fisher_exact

HELDOUT = os.path.join(os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__)))), "bench", "heldout", "harness", "bench", "results")


def load(results, spec):
    """The newest record per (model, task, sample) of RUN or RUN@MODEL; records flagged needs_rerun are left out."""
    run, _, model = spec.partition("@")
    path = os.path.join(results, run, "results.jsonl")
    newest = {}
    for line in open(path) if os.path.exists(path) else []:
        try:
            r = json.loads(line)
        except json.JSONDecodeError:
            continue
        if r.get("needs_rerun") or (model and r["model"] != model):
            continue
        key = (r["model"], r["task"], r["sample"])
        if key not in newest or str(r.get("finished", "")) >= str(newest[key].get("finished", "")):
            newest[key] = r
    return list(newest.values())


def first_builds(r):
    return bool(r["attempts"] and (r["attempts"][0].get("render") or {}).get("ok"))


def per_sample(results, spec):
    rs = load(results, spec)
    out = []
    for model in sorted({r["model"] for r in rs}):
        by = collections.defaultdict(list)
        for r in rs:
            if r["model"] == model:
                by[r["sample"]].append(r)
        for s in sorted(by):
            x = by[s]
            out.append(f"| {spec} | {model} | {s} | {len(x)} | {sum(r['passed'] for r in x)} | "
                       f"{sum(r['first_pass'] for r in x)} | {sum(first_builds(r) for r in x)} | "
                       f"{statistics.median(r['wall_s'] for r in x) / 60:.1f} |")
    return out


def per_task(rs, key):
    c = collections.Counter()
    for r in rs:
        c[r["task"]] += bool(key(r))
    return c


def sign(results, a, b):
    ra, rb = load(results, a), load(results, b)
    tasks = sorted({r["task"] for r in ra} | {r["task"] for r in rb})
    lines = []
    for label, key, alt in (("first-attempt passes", lambda r: r["first_pass"], "greater"),
                            ("passes within three attempts", lambda r: r["passed"], "two-sided")):
        ca, cb = per_task(ra, key), per_task(rb, key)
        more = sum(ca[t] > cb[t] for t in tasks)
        fewer = sum(ca[t] < cb[t] for t in tasks)
        p = binomtest(more, more + fewer, 0.5, alternative=alt).pvalue if more + fewer else 1.0
        lines.append(f"- {a} vs {b}, {label}: {sum(ca.values())}/{len(ra)} vs {sum(cb.values())}/{len(rb)} "
                     f"conversations; {more} tasks more often, {fewer} less often, {len(tasks) - more - fewer} level; "
                     f"sign test ({alt}) p = {p:.3g}")
    return lines


def fisher(results, a, b):
    ra, rb = load(results, a), load(results, b)
    lines = []
    for label, key, alt in (("first files that render", first_builds, "greater"),
                            ("passes within three attempts", lambda r: r["passed"], "two-sided")):
        xa, xb = sum(bool(key(r)) for r in ra), sum(bool(key(r)) for r in rb)
        p = fisher_exact([[xa, len(ra) - xa], [xb, len(rb) - xb]], alternative=alt)[1]
        lines.append(f"- {a} vs {b}, {label}: {xa}/{len(ra)} vs {xb}/{len(rb)}; Fisher ({alt}) p = {p:.3g}")
    return lines


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("runs", nargs="*")
    ap.add_argument("--results", default=HELDOUT)
    ap.add_argument("--pair", nargs=2, action="append", default=[])
    ap.add_argument("--fisher", nargs=2, action="append", default=[])
    a = ap.parse_args()
    runs = a.runs or sorted(d for d in os.listdir(a.results)
                            if os.path.exists(os.path.join(a.results, d, "results.jsonl")))
    print("| Run | Model | Sample | Conversations | Passed within 3 | First-attempt passes | First files build | "
          "Median min/task |")
    print("|---|---|---:|---:|---:|---:|---:|---:|")
    for spec in runs:
        print("\n".join(per_sample(a.results, spec)))
    for x, y in a.pair:
        print("\n".join(sign(a.results, x, y)))
    for x, y in a.fisher:
        print("\n".join(fisher(a.results, x, y)))


if __name__ == "__main__":
    main()
