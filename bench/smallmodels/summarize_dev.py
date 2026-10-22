#!/usr/bin/env python3
"""Tables of the development runs (bench/smallmodels/PROTOCOL.md), from their JSONL files; no model calls.

    python3 -I summarize_dev.py [templates] [features]
"""
import collections
import json
import os
import statistics
import sys

HERE = os.path.dirname(os.path.abspath(__file__))


def rows(path):
    out = []
    if os.path.exists(path):
        for line in open(path):
            try:
                out.append(json.loads(line))
            except json.JSONDecodeError:
                pass
    return out


def templates():
    rs = rows(os.path.join(HERE, "templates", "dev_templates.jsonl"))
    print("Templates, development (first attempt; in-library: seed-family descriptions; out-of-library: batch C, "
          "where the right pick is none)\n")
    print("| Model | in-library | right design | right design and parameters | out-of-library | none picked |"
          " errors | median s |")
    print("|---|---:|---:|---:|---:|---:|---:|---:|")
    by = collections.defaultdict(list)
    for r in rs:
        by[r["model"]].append(r)
    for model, xs in by.items():
        ins = [r for r in xs if r["kind"] == "in"]
        outs = [r for r in xs if r["kind"] == "out"]
        print(f"| {model} | {len(ins)} | {sum(r['family_right'] for r in ins)} | {sum(bool(r['params_right']) for r in ins)} "
              f"| {len(outs)} | {sum(r['pick'] == 'none' for r in outs)} | {sum(bool(r.get('error')) for r in xs)} "
              f"| {statistics.median(r['wall_s'] for r in xs):.0f} |")
    for model, xs in by.items():
        wrong = collections.Counter((r["family"], r["pick"]) for r in xs if not r["family_right"])
        if wrong:
            print(f"\n{model} wrong picks (wanted -> picked): "
                  + ", ".join(f"{a}->{b}" + (f" x{n}" if n > 1 else "") for (a, b), n in wrong.most_common()))


def features():
    rs = rows(os.path.join(HERE, "features", "dev_features.jsonl"))
    print("\nFeatures, development (first attempt, batch C; a pass matches the verified file's size per axis, "
          "volume and pieces)\n")
    print("| Model | descriptions | builds a part | passes | mean score | errors | median s |")
    print("|---|---:|---:|---:|---:|---:|---:|")
    by = collections.defaultdict(list)
    for r in rs:
        by[r["model"]].append(r)
    for model, xs in by.items():
        built = sum(1 for r in xs if isinstance(r.get("score"), (int, float)) and r["score"] > 0)
        print(f"| {model} | {len(xs)} | {built} | {sum(r['passed'] for r in xs)} | "
              f"{statistics.mean(float(r.get('score') or 0) for r in xs):.2f} | {sum(bool(r.get('error')) for r in xs)} "
              f"| {statistics.median(r['wall_s'] for r in xs):.0f} |")
    for model, xs in by.items():
        fams = collections.Counter(r["family"] for r in xs if r["passed"])
        if fams:
            print(f"\n{model} passes by family: " + ", ".join(f"{k} {v}" for k, v in sorted(fams.items())))


if __name__ == "__main__":
    which = sys.argv[1:] or ["templates", "features"]
    if "templates" in which:
        templates()
    if "features" in which:
        features()
