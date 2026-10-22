#!/usr/bin/env python3
"""Test evaluation of the frozen scadfix on the benchmark's saved attempts (an offline what-if, run once).

    nice -n 10 python -I -B test_eval.py --tmp /some/scratch/dir [--workers 4]

Runs: the laptop runs main (all models), ft-scad (scadcoder) and main-bonsai, and the NPU-box run main-tiiny (all
models, several samples each). Records are loaded as bench/analyze.py does (load_runs: the newest record per
conversation, attempts after a pass dropped, records flagged needs_rerun left out; English prompts and the
standard report feedback only). Every attempt's saved .scad (bench/rescore.py scad_path) goes through scadfix.fix;
when a rule fires, the fixed file is rendered and scored with the benchmark's hidden checks exactly as rescore.py
does (render() with its default timeout, then checks.evaluate(load_mesh(stl), task, reference_stats[task])).
An attempt whose reply held no code (extract "none") has nothing to repair and is skipped.

What-if, not a rerun: the model never saw the fixed file, so the feedback and every later attempt are unchanged.
"Passed within three attempts" after the fix counts a conversation as passed if any of its attempts passes as
recorded or, where a rule fired, as fixed.
"""
import argparse
import collections
import hashlib
import json
import os
import shutil
import sys
import tempfile
import time
from concurrent.futures import ProcessPoolExecutor

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, "..", "..", ".."))
BENCH = os.path.join(ROOT, "bench")
sys.dont_write_bytecode = True
os.environ.setdefault("OPENSCAD", "/home/seb/.local/bin/openscad")
sys.path[:0] = [HERE, BENCH, os.path.join(ROOT, "tools")]
import yaml  # noqa: E402

import scadfix  # noqa: E402
import analyze  # noqa: E402  (read-only: load_runs, dedupe)
import rescore  # noqa: E402  (read-only: scad_path)
from checks import evaluate  # noqa: E402
from scadreport import load_mesh, render  # noqa: E402

LAPTOP_RUNS = ["main", "ft-scad", "main-bonsai"]
BOX_RUNS = ["main-tiiny"]
_W = {}


def _init(tmp):
    _W["tmp"] = tmp
    tempfile.tempdir = tmp
    _W["tasks"] = {t["id"]: t for t in yaml.safe_load(open(os.path.join(BENCH, "tasks.yaml"), encoding="utf-8"))}
    _W["refs"] = json.load(open(os.path.join(BENCH, "reference_stats.json"), encoding="utf-8"))


def score(job):
    """(code, task id, file name) -> {render, passed, score, error}: rescore.py's path on a temporary copy."""
    code, task, name = job
    d = tempfile.mkdtemp(prefix="scadfix_test_", dir=_W["tmp"])
    try:
        src, stl = os.path.join(d, name), os.path.join(d, "x.stl")
        with open(src, "w", encoding="utf-8", errors="replace") as fh:
            fh.write(code)
        r = render(src, stl)
        if not r["ok"]:
            return {"render": False, "passed": False, "score": 0.0,
                    "error": next((m for m in r["messages"] if m.startswith("ERROR")), "no solid")[:200]}
        try:
            res = evaluate(load_mesh(stl), _W["tasks"][task], _W["refs"][task])
        except Exception as e:  # noqa: BLE001  (rescore: mesh analysis failed)
            return {"render": False, "passed": False, "score": 0.0, "error": f"mesh analysis failed: {e}"[:200]}
        return {"render": True, "passed": bool(res["passed"]), "score": round(res["score"], 4), "error": None}
    finally:
        shutil.rmtree(d, ignore_errors=True)


def records():
    runs = analyze.load_runs()
    out = {}
    for group, names in (("laptop", LAPTOP_RUNS), ("box", BOX_RUNS)):
        missing = [n for n in names if n not in runs]
        if missing:
            raise SystemExit(f"no results for {missing}")
        recs = analyze.dedupe([r for n in names for r in runs[n]])
        out[group] = [r for r in recs if r.get("lang", "en") == "en" and r.get("feedback", "report") == "report"]
    return out


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--tmp", default=tempfile.gettempdir())
    ap.add_argument("--workers", type=int, default=4)
    ap.add_argument("--out", default=os.path.join(HERE, "test_results.json"))
    ap.add_argument("--rows", default=os.path.join(HERE, "test_attempts.jsonl"))
    a = ap.parse_args()
    t0 = time.time()
    sha = hashlib.sha256(open(os.path.join(HERE, "scadfix.py"), "rb").read()).hexdigest()
    groups = records()
    atts = []  # one per saved attempt
    for group, recs in groups.items():
        for rec in recs:
            for i, at in enumerate(rec["attempts"][:3]):
                path = rescore.scad_path(rec["_run"], rec, i)
                row = {"group": group, "run": rec["_run"], "model": rec["model"], "task": rec["task"],
                       "sample": rec["sample"], "attempt": i, "extract": at.get("extract"),
                       "render_before": bool(at.get("render", {}).get("ok")), "pass_before": bool(at.get("passed")),
                       "score_before": at.get("score") or 0.0, "stage_before": analyze.failure_stage(at),
                       "fired": [], "missing": not os.path.exists(path)}
                if not row["missing"] and at.get("extract") != "none":
                    code = open(path, encoding="utf-8", errors="replace").read()
                    fixed, fired = scadfix.fix(code)
                    if fired:
                        row.update(fired=fired, _code=code, _fixed=fixed, _name=os.path.basename(path))
                    if "close_truncated" in fired:  # the same repair without the cut-off rule, reported apart
                        row["_fixed_nt"], row["fired_no_trunc"] = scadfix.fix(code, skip=("close_truncated",))
                atts.append(row)
    fired = [r for r in atts if r["fired"]]
    with ProcessPoolExecutor(a.workers, initializer=_init, initargs=(a.tmp,)) as ex:
        after = list(ex.map(score, [(r["_fixed"], r["task"], r["_name"]) for r in fired], chunksize=2))
        again = [r for r in fired if r["render_before"]]  # rescore the original too where it had rendered
        before = list(ex.map(score, [(r["_code"], r["task"], r["_name"]) for r in again], chunksize=2))
        trunc = [r for r in fired if r.get("fired_no_trunc")]
        no_trunc = list(ex.map(score, [(r["_fixed_nt"], r["task"], r["_name"]) for r in trunc], chunksize=2))
    for r, res in zip(trunc, no_trunc):
        r["after_no_trunc"] = res
    for r, res in zip(fired, after):
        r["after"] = res
    for r, res in zip(again, before):
        r["rescored_before"] = res
    for r in atts:
        r["render_after"] = r["after"]["render"] if r["fired"] else r["render_before"]
        r["pass_after"] = r["after"]["passed"] if r["fired"] else r["pass_before"]
        # without close_truncated: a file only it repaired stays as recorded
        if "close_truncated" not in r["fired"]:
            r["render_after_nt"], r["pass_after_nt"] = r["render_after"], r["pass_after"]
        elif r.get("fired_no_trunc"):
            r["render_after_nt"], r["pass_after_nt"] = r["after_no_trunc"]["render"], r["after_no_trunc"]["passed"]
        else:
            r["render_after_nt"], r["pass_after_nt"] = r["render_before"], r["pass_before"]
    with open(a.rows, "w", encoding="utf-8") as fh:
        for r in fired:
            fh.write(json.dumps({k: v for k, v in r.items() if not k.startswith("_")}) + "\n")
    meta = {m["id"]: m for m in yaml.safe_load(open(os.path.join(BENCH, "models.yaml"), encoding="utf-8"))}
    summary = {"scadfix_version": scadfix.VERSION, "scadfix_sha256": sha,
               "runs": {"laptop": LAPTOP_RUNS, "box": BOX_RUNS},
               "attempts": len(atts), "attempts_missing_file": sum(r["missing"] for r in atts),
               "attempts_fired": len(fired), "rule_errors": scadfix.ERRORS,
               "rescored_originals_that_differ": [
                   {k: r[k] for k in ("run", "model", "task", "sample", "attempt", "pass_before")}
                   | {"rescored": r["rescored_before"]["passed"]}
                   for r in fired if "rescored_before" in r and r["rescored_before"]["passed"] != r["pass_before"]],
               "models": per_model(atts, meta)}
    summary["seconds"] = round(time.time() - t0)
    json.dump(summary, open(a.out, "w"), indent=1)
    print_table(summary)


def per_model(atts, meta):
    out = []
    by = collections.defaultdict(list)
    for r in atts:
        by[(r["group"], r["model"])].append(r)
    order = lambda gm: (gm[0] != "laptop", meta.get(gm[1], {}).get("size_gb") or 1e9, gm[1])  # noqa: E731
    for (group, model), rs in sorted(by.items(), key=lambda kv: order(kv[0])):
        conv = collections.defaultdict(list)
        for r in rs:
            conv[(r["sample"], r["task"])].append(r)
        samples = sorted({s for s, _ in conv})
        per_sample = []
        for s in samples:
            cs = [sorted(v, key=lambda r: r["attempt"]) for (s2, _), v in conv.items() if s2 == s]
            first = [c[0] for c in cs if c and c[0]["attempt"] == 0]
            per_sample.append({
                "sample": s, "tasks": len(cs),
                "render1_before": sum(r["render_before"] for r in first),
                "render1_after": sum(r["render_after"] for r in first),
                "pass1_before": sum(r["pass_before"] for r in first),
                "pass1_after": sum(r["pass_after"] for r in first),
                "syntax1_before": sum(r["stage_before"] == "syntax error" for r in first),
                "syntax1_fired": sum(r["stage_before"] == "syntax error" and bool(r["fired"]) for r in first),
                "syntax1_render_after": sum(r["stage_before"] == "syntax error" and r["render_after"] for r in first),
                "tasks_passed_before": sum(any(r["pass_before"] for r in c) for c in cs),
                "tasks_passed_after": sum(any(r["pass_after"] for r in c) for c in cs),
                "render1_after_no_trunc": sum(r["render_after_nt"] for r in first),
                "pass1_after_no_trunc": sum(r["pass_after_nt"] for r in first),
                "tasks_passed_after_no_trunc": sum(any(r["pass_after_nt"] for r in c) for c in cs)})
        rules_all = collections.Counter(n for r in rs for n in r["fired"])
        rules_first = collections.Counter(n for r in rs if r["attempt"] == 0 for n in r["fired"])
        out.append({"group": group, "model": model, "label": meta.get(model, {}).get("label", model),
                    "samples": per_sample, "attempts": len(rs),
                    "attempts_fired": sum(bool(r["fired"]) for r in rs),
                    "first_attempts_fired": sum(bool(r["fired"]) for r in rs if r["attempt"] == 0),
                    "fixed_files_render": sum(bool(r["fired"]) and r["after"]["render"] for r in rs),
                    "fixed_files_pass": sum(bool(r["fired"]) and r["after"]["passed"] for r in rs),
                    "rules_all_attempts": dict(rules_all.most_common()),
                    "rules_first_attempts": dict(rules_first.most_common())})
    return out


def print_table(s):
    print(f"scadfix {s['scadfix_version']} sha256 {s['scadfix_sha256']}")
    print(f"{s['attempts']} attempts ({s['attempts_missing_file']} without a saved file), a rule fired on "
          f"{s['attempts_fired']}; rule errors {len(s['rule_errors'])}; "
          f"rescored originals that differ from the record: {len(s['rescored_originals_that_differ'])}")
    print("| Model | 1st-try syntax errors (rule fired / renders after) | Renders 1st try | Pass 1st try | "
          "Pass <=3 tries | Renders 1st try, no close_truncated | Pass <=3, no close_truncated | "
          "Attempts fixed (render / pass) | Rules |")
    print("|---|---:|---:|---:|---:|---:|---:|---:|---|")
    for m in s["models"]:
        sm = m["samples"]
        fmt = lambda b, a: " + ".join(str(x[b]) for x in sm) + " -> " + " + ".join(str(x[a]) for x in sm)  # noqa: E731
        syn = " + ".join(f"{x['syntax1_before']} ({x['syntax1_fired']} / {x['syntax1_render_after']})" for x in sm)
        print(f"| {m['label']} | {syn} | {fmt('render1_before', 'render1_after')} | "
              f"{fmt('pass1_before', 'pass1_after')} | {fmt('tasks_passed_before', 'tasks_passed_after')} | "
              f"{fmt('render1_before', 'render1_after_no_trunc')} | "
              f"{fmt('tasks_passed_before', 'tasks_passed_after_no_trunc')} | {m['attempts_fired']} "
              f"({m['fixed_files_render']} / {m['fixed_files_pass']}) | "
              + ", ".join(f"{k} {v}" for k, v in m["rules_all_attempts"].items()) + " |")


if __name__ == "__main__":
    main()
