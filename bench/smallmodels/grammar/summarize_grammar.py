#!/usr/bin/env python3
"""Grammar test runs (PROTOCOL.md, intervention 2b): each model with the frozen grammar against the same model
without it. Qwen2.5-Coder 7B: grammar-off vs grammar-on, on the same llama-server path. Bonsai 2 27B: main-bonsai
(the same path, no grammar) vs grammar-on. The newest record per task counts, as in run_bench.py.

    python3 -I summarize_grammar.py [--md out.md]
"""
import json
import os
import statistics
import sys

RESULTS = os.path.join(os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__)))), "results")
PAIRS = [("qwen2.5-coder-7b-llamacpp", "grammar-off", "grammar-on"), ("bonsai2-27b-pq2_0", "main-bonsai", "grammar-on")]


def records(run, model):
    path = os.path.join(RESULTS, run, "results.jsonl")
    newest = {}
    if os.path.exists(path):
        for line in open(path):
            d = json.loads(line)
            if d["model"] == model and d.get("feedback") == "report":
                newest[(d["task"], d["sample"])] = d
    return newest


def stats(recs):
    att = [a for r in recs.values() for a in r["attempts"]]
    fails = [a for a in att if not (a.get("render") or {}).get("ok") and a.get("extract") != "none"]
    parse = sum(any("Parser error" in m or "syntax error" in m for m in (a.get("render") or {}).get("messages") or [])
                for a in fails)
    return {"tasks": len(recs), "passed": sum(r["passed"] for r in recs.values()),
            "first_pass": sum(r["first_pass"] for r in recs.values()),
            "first_builds": sum(bool(r["attempts"] and (r["attempts"][0].get("render") or {}).get("ok"))
                                for r in recs.values()),
            "attempts": len(att), "builds": sum(bool((a.get("render") or {}).get("ok")) for a in att),
            "parse_errors": parse, "cut_off": sum((a.get("usage") or {}).get("done_reason") == "length" for a in att),
            "median_min": round(statistics.median(r["wall_s"] for r in recs.values()) / 60, 1) if recs else None}


def main():
    out = []
    for model, off, on in PAIRS:
        a, b = records(off, model), records(on, model)
        if not b:
            out += [f"## `{model}`: no grammar-on results yet", ""]
            continue
        sa, sb = stats(a), stats(b)
        out += [f"## `{model}`: `{off}` (no grammar) vs `{on}` (grammar v1)", "",
                "| | No grammar | Grammar |", "|---|---:|---:|"]
        for k, label in [("tasks", "Tasks run"), ("passed", "Passed within three attempts"),
                         ("first_pass", "Passed on the first attempt"), ("first_builds", "First files that build"),
                         ("attempts", "Attempts"), ("builds", "Attempts that build"),
                         ("parse_errors", "Attempts with a parse error"), ("cut_off", "Replies cut off at the limit"),
                         ("median_min", "Median minutes a task")]:
            out.append(f"| {label} | {sa[k]} | {sb[k]} |")
        out += ["", "| Task | No grammar | Grammar |", "|---|---|---|"]
        for t, s in sorted(set(a) | set(b)):
            cell = lambda r: ("—" if r is None else ("**PASS**" if r["passed"] else "fail") + " ("
                              + ", ".join("pass" if x.get("passed") else ("builds" if (x.get("render") or {}).get("ok")
                                          else "no build") for x in r["attempts"]) + ")")
            out.append(f"| {t} | {cell(a.get((t, s)))} | {cell(b.get((t, s)))} |")
        out.append("")
    text = "\n".join(out)
    print(text)
    if "--md" in sys.argv:
        open(sys.argv[sys.argv.index("--md") + 1], "w").write(text + "\n")


if __name__ == "__main__":
    main()
