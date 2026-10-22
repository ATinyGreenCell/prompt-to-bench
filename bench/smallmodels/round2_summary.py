#!/usr/bin/env python3
"""R2 summary (PROTOCOL.md, round 2): resampling instead of repair, for the frozen templates 1 and features 1.

Per task, over the 8 fresh samples (one attempt each, no feedback): passes, pass@1, pass@3 and pass@8 by the
unbiased estimator 1 - C(n-c, k) / C(n, k), distinct files (by the code's sha1) and first files that build. The
primary measure is tasks with a pass among samples 0-2, against round 1's tasks passed within three attempts.

    python3 -I round2_summary.py [--corrections audit.jsonl] [--md out.md]

--corrections: a checker audit's records (checker_audit/audit_all.jsonl); an attempt that passes once its mesh is
cleaned counts as a pass, the same rule applied to round 1.
"""
import json
import math
import os
import sys

RESULTS = os.path.join(os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__)))), "bench", "results")
RUNS = [("sm-features-r8", "sm-features", "features, temperature 0.2"),
        ("sm-features-r8t7", "sm-features", "features, temperature 0.7"),
        ("sm-template-r8", "sm-template", "templates, temperature 0.2"),
        ("sm-template-r8t7", "sm-template", "templates, temperature 0.7")]


def load(run):
    """The newest record per (model, task, sample)."""
    path = os.path.join(RESULTS, run, "results.jsonl")
    best = {}
    for line in open(path) if os.path.exists(path) else []:
        r = json.loads(line)
        best[(r["model"], r["task"], r["sample"])] = r
    return list(best.values())


def corrections(path):
    """Attempts that pass once a non-watertight mesh is cleaned: {(run, model, task, sample, attempt)}."""
    fixed = set()
    for line in open(path) if path else []:
        a = json.loads(line)
        if (a.get("clean") or {}).get("passed") or (a.get("cgal") or {}).get("passed"):
            fixed.add((a["run"], a["model"], a["task"], a["sample"], a["attempt"]))
    return fixed


def passed(run, r, fixed):
    return r["passed"] or any((run, r["model"], r["task"], r["sample"], a["attempt"]) in fixed for a in r["attempts"])


def pass_at(n, c, k):
    if n < k:
        return float("nan")
    return 1.0 if n - c < k else 1 - math.comb(n - c, k) / math.comb(n, k)


def main():
    args = sys.argv[1:]
    fixed = corrections(args[args.index("--corrections") + 1] if "--corrections" in args else None)
    out = []
    for run, round1, label in RUNS:
        recs = load(run)
        if not recs:
            out += [f"## `{run}` ({label}): no results yet", ""]
            continue
        base = load(round1)
        for model in sorted({r["model"] for r in recs}):
            rs = [r for r in recs if r["model"] == model]
            tasks = sorted({r["task"] for r in rs})
            out += [f"## `{run}` ({label}): `{model}`", "",
                    "| Task | Samples | Passes | pass@1 | pass@3 | pass@8 | Pass in samples 0-2 | Distinct files | First files build | Round 1 within 3 |",
                    "|---|---:|---:|---:|---:|---:|---|---:|---:|---|"]
            tot = {"p03": 0, "r1": 0, "p1": 0.0, "p3": 0.0, "p8": 0.0, "builds": 0, "n": 0}
            for t in tasks:
                ts = sorted((r for r in rs if r["task"] == t), key=lambda r: r["sample"])
                n, c = len(ts), sum(passed(run, r, fixed) for r in ts)
                p03 = any(passed(run, r, fixed) for r in ts if r["sample"] <= 2)
                files = {a.get("code_sha1") for r in ts for a in r["attempts"] if a.get("code_sha1")}
                builds = sum(bool(r["attempts"] and (r["attempts"][0].get("render") or {}).get("ok")) for r in ts)
                b = [r for r in base if r["model"] == model and r["task"] == t]
                r1 = bool(b) and passed(round1, b[-1], fixed)
                p1, p3, p8 = pass_at(n, c, 1), pass_at(n, c, 3), pass_at(n, c, 8)
                tot["p03"] += p03; tot["r1"] += r1; tot["builds"] += builds; tot["n"] += n
                tot["p1"] += p1; tot["p3"] += 0 if math.isnan(p3) else p3; tot["p8"] += 0 if math.isnan(p8) else p8
                out.append(f"| {t} | {n} | {c} | {p1:.2f} | {p3:.2f} | {p8:.2f} | {'**yes**' if p03 else 'no'} | "
                           f"{len(files)} | {builds}/{n} | {'pass' if r1 else ('fail' if b else '-')} |")
            k = len(tasks)
            out += ["", f"- Tasks with a pass among samples 0-2: **{tot['p03']}/{k}**, against round 1's "
                        f"{tot['r1']}/{k} within three attempts (`{round1}`).",
                    f"- Expected tasks passed: pass@1 {tot['p1']:.2f}, pass@3 {tot['p3']:.2f}, pass@8 {tot['p8']:.2f} "
                    f"(sums over tasks).",
                    f"- First files that build: {tot['builds']}/{tot['n']}.", ""]
    if fixed:
        out.append(f"Checker correction applied: {len(fixed)} attempts pass once their mesh is cleaned.")
    text = "\n".join(out)
    print(text)
    if "--md" in args:
        open(args[args.index("--md") + 1], "w").write(text + "\n")


if __name__ == "__main__":
    main()
