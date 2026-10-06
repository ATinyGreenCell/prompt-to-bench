#!/usr/bin/env python3
"""Re-check every saved attempt of a run with the current checker and tasks.

    python bench/rescore.py main-claude lang-claude      # rewrite those runs' scores
    python bench/rescore.py main --dry-run               # only report what would change

Each attempt's saved .scad is rendered again and evaluated with the current
`tasks.yaml` checks and `reference_stats.json`. Records keep their replies; only the
`check`, `passed` and `score` fields are updated, and every changed verdict is listed
and stored under `rescored`. Takes the run's lock, so it never collides with a running
benchmark on the same folder.
"""
import argparse
import datetime as dt
import fcntl
import json
import os
import re
import subprocess
import sys
import tempfile

import yaml

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
sys.path.insert(0, os.path.join(os.path.dirname(HERE), "tools"))
from checks import evaluate  # noqa: E402
from scadreport import load_mesh, render  # noqa: E402


def scad_path(run, rec, i):
    suffix = "".join(f"_{x}" for x, d in ((rec.get("lang", "en"), "en"), (rec.get("feedback", "report"), "report")) if x != d)
    model = re.sub(r"[^A-Za-z0-9._-]+", "_", rec["model"])
    return os.path.join(HERE, "results", run, "code", model, f"{rec['task']}_s{rec['sample']}{suffix}_a{i}.scad")


def rescore_run(run, tasks, refs, dry, commit):
    path = os.path.join(HERE, "results", run, "results.jsonl")
    lock = open(os.path.join(HERE, "results", run, ".lock"), "w")
    try:
        fcntl.flock(lock, fcntl.LOCK_EX | fcntl.LOCK_NB)
    except BlockingIOError:
        print(f"{run}: a benchmark is still writing this run - skipped (rescore it when it finishes)")
        return
    recs = [json.loads(line) for line in open(path) if line.strip()]
    changes, missing, tmp = [], 0, tempfile.mkdtemp(prefix="rescore_")
    for rec in recs:
        task = tasks[rec["task"]]
        for i, a in enumerate(rec["attempts"]):
            if not a.get("render", {}).get("ok"):
                continue  # never rendered: nothing to re-check
            src = scad_path(run, rec, i)
            if not os.path.exists(src):
                missing += 1
                continue
            stl = os.path.join(tmp, "x.stl")
            r = render(src, stl)
            if not r["ok"]:
                continue
            res = evaluate(load_mesh(stl), task, refs[rec["task"]])
            if bool(res["passed"]) != bool(a.get("passed")) or abs(res["score"] - (a.get("score") or 0)) > 1e-9:
                changes.append((rec["model"], rec["task"], rec.get("lang", "en"), i, a.get("passed"), res["passed"],
                                round(a.get("score") or 0, 2), round(res["score"], 2)))
                a["check"], a["passed"], a["score"] = res, bool(res["passed"]), res["score"]
        before = (rec["passed"], rec["first_pass"])
        rec["passed"] = any(a.get("passed") for a in rec["attempts"])
        rec["first_pass"] = bool(rec["attempts"] and rec["attempts"][0].get("passed"))
        if (rec["passed"], rec["first_pass"]) != before:
            rec["rescored"] = {"date": dt.date.today().isoformat(), "commit": commit,
                               "was": {"passed": before[0], "first_pass": before[1]}}
    print(f"{run}: {len(recs)} conversations, {len(changes)} attempt verdict/score changes, {missing} missing files")
    for c in changes:
        print(f"   {c[0]:28s} {c[1]:24s} {c[2]} a{c[3]}: passed {c[4]} -> {c[5]}, score {c[6]} -> {c[7]}")
    if not dry and changes:
        tmp_path = path + ".tmp"
        with open(tmp_path, "w") as fh:
            fh.writelines(json.dumps(r) + "\n" for r in recs)
        os.replace(tmp_path, path)


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("runs", nargs="+")
    ap.add_argument("--dry-run", action="store_true")
    a = ap.parse_args()
    tasks = {t["id"]: t for t in yaml.safe_load(open(os.path.join(HERE, "tasks.yaml")))}
    refs = json.load(open(os.path.join(HERE, "reference_stats.json")))
    commit = subprocess.run(["git", "rev-parse", "--short", "HEAD"], capture_output=True, text=True,
                            cwd=HERE).stdout.strip()
    for run in a.runs:
        rescore_run(run, tasks, refs, a.dry_run, commit)


if __name__ == "__main__":
    main()
