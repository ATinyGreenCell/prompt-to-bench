#!/usr/bin/env python3
"""Test-run summary for templates and features (PROTOCOL.md, "Test procedures"): per task, the outcome of each
attempt and, for templates, the design picked; totals against the same model's standard laptop run (`main`) and the
viability bar (at least 8 of 16 tasks within three attempts, median at most 10 minutes a task).

    python3 -I summarize_test.py sm-template|sm-features [--md out.md]
"""
import json
import os
import statistics
import sys

RESULTS = os.path.join(os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__)))), "bench", "results")
# Tasks with a related design in the template library (PROTOCOL.md, "Templates and features").
RELATED = {"tube_rack_1p5ml": "grid_tray", "conical_rack_50ml": "grid_tray", "pcr_tube_rack_sbs": "grid_tray",
           "lab_funnel_60mm": "funnel", "dshaft_knob_6mm": "knurled_knob", "enclosure_box_and_lid": "lidded_box",
           "hose_barb_reducer_8_5": "stepped_adapter / flanged_bushing",
           "pcr_tube_adapter": "stepped_adapter / flanged_bushing", "rod_tubing_clip": "pipe_saddle_clamp"}


def load(run):
    path = os.path.join(RESULTS, run, "results.jsonl")
    return [json.loads(line) for line in open(path)] if os.path.exists(path) else []


def attempt_cell(a, templates):
    r = (a.get("render") or {}).get("ok")
    mark = "pass" if a.get("passed") else ("builds" if r else ("no file" if a.get("extract") == "none" else "no build"))
    if templates:
        mark += f" `{(a.get('usage') or {}).get('template') or 'none'}`"
    return mark


def main():
    run = sys.argv[1]
    templates = run == "sm-template"
    recs = load(run)
    if not recs:
        sys.exit(f"no results in {run}")
    out = []
    for model in sorted({r["model"] for r in recs}):
        rs = sorted((r for r in recs if r["model"] == model), key=lambda r: r["task"])
        base_model = model.split(":", 1)[1]
        base = [r for r in load("main") if r["model"] == base_model and r.get("feedback") == "report"]
        out += [f"## {run}: `{model}`", "",
                "| Task | Within 3 | Attempt 1 | Attempt 2 | Attempt 3 | Minutes |" + (" Related design |" if templates else ""),
                "|---|---|---|---|---|---:|" + ("---|" if templates else "")]
        for r in rs:
            cells = [attempt_cell(a, templates) for a in r["attempts"]] + [""] * (3 - len(r["attempts"]))
            row = (f"| {r['task']} | {'**PASS**' if r['passed'] else 'fail'} | " + " | ".join(cells[:3])
                   + f" | {r['wall_s'] / 60:.1f} |")
            out.append(row + (f" {RELATED.get(r['task'], '')} |" if templates else ""))
        n = len(rs)
        passed = sum(r["passed"] for r in rs)
        first = sum(r["first_pass"] for r in rs)
        builds = sum(bool(r["attempts"] and (r["attempts"][0].get("render") or {}).get("ok")) for r in rs)
        med = statistics.median(r["wall_s"] for r in rs) / 60
        out += ["", f"- Tasks passed within three attempts: **{passed}/{n}**; on the first attempt: {first}/{n}.",
                f"- First files that build: {builds}/{n}. Median {med:.1f} minutes a task."]
        if base:
            bp = sum(r["passed"] for r in base)
            bb = sum(bool(r["attempts"] and (r["attempts"][0].get("render") or {}).get("ok")) for r in base)
            out.append(f"- The same model writing OpenSCAD (`main`): {bp}/{len(base)} passed, {bb}/{len(base)} first files "
                       f"build, median {statistics.median(r['wall_s'] for r in base) / 60:.1f} minutes.")
        bar = passed >= 8 and med <= 10 and n == 16
        out.append(f"- Viability bar (at least 8 of 16 within three attempts, median at most 10 minutes): "
                   f"{'met' if bar else 'not met'}.")
        if templates:
            rel = [r for r in rs if r["task"] in RELATED]
            out.append(f"- Passes on tasks with a related library design: {sum(r['passed'] for r in rel)} of {len(rel)}; "
                       f"on the others: {sum(r['passed'] for r in rs if r['task'] not in RELATED)} of {n - len(rel)}.")
        out.append("")
    text = "\n".join(out)
    print(text)
    if "--md" in sys.argv:
        open(sys.argv[sys.argv.index("--md") + 1], "w").write(text + "\n")


if __name__ == "__main__":
    main()
