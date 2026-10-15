#!/usr/bin/env python3
"""Score pod-generated OpenSCAD outputs with the REAL benchmark checker (pass@1 per task).

Input files are {task_id: scad} JSON (outputs_base.json / outputs_ft.json from the pod). For each,
render with the harness renderer and run the task's hidden checks (same evaluate() as the eval), so
the number is directly comparable to the benchmark. Single-shot (attempt 1), so it is a pass@1
lower bound on the 3-attempt protocol - fine for an A/B signal.

usage: ~/printpaper/.venv/bin/python -I score_outputs.py outputs_base.json outputs_ft.json
"""
from __future__ import annotations

import json
import os
import pathlib
import sys
import tempfile

ROOT = pathlib.Path("/home/seb/printpaper")
sys.path[:0] = [str(ROOT / "bench"), str(ROOT / "tools")]
import yaml  # noqa: E402
from checks import evaluate  # noqa: E402
from scadreport import load_mesh, render  # noqa: E402

TASKS = {t["id"]: t for t in yaml.safe_load(open(ROOT / "bench" / "tasks.yaml"))}
REFS = json.load(open(ROOT / "bench" / "reference_stats.json"))


def score(path: str) -> None:
    outs = json.load(open(path))
    rows, n = [], 0
    for tid, scad in outs.items():
        task, ref = TASKS.get(tid), REFS.get(tid)
        ok, sc, rendered = False, 0.0, False
        if task is not None:
            with tempfile.TemporaryDirectory() as d:
                sp, stl = os.path.join(d, "p.scad"), os.path.join(d, "p.stl")
                open(sp, "w").write(scad or "// empty\n")
                rr = render(sp, stl, timeout=120)
                rendered = rr["ok"]
                if rr["ok"]:
                    try:
                        res = evaluate(load_mesh(stl), task, ref)
                        ok, sc = res["passed"], round(res["score"], 2)
                    except Exception:
                        pass
        n += ok
        rows.append((tid, ok, sc, rendered))
    print(f"\n{os.path.basename(path)}: {n}/{len(rows)} passed (pass@1)")
    for tid, ok, sc, rendered in rows:
        tag = "PASS" if ok else ("fail" if rendered else "FAIL(no-render)")
        print(f"  {tag:16s} {tid:24s} score {sc}")


if __name__ == "__main__":
    for p in sys.argv[1:]:
        if os.path.exists(p):
            score(p)
        else:
            print(f"(missing: {p})")
