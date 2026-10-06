#!/usr/bin/env python3
"""Robustness tests for the benchmark harness, checker and scadreport (no model or GPU needed).

    python bench/test_harness.py

Uses a fake backend in place of Ollama/Claude and runs real OpenSCAD renders. Covers:
pathological model output, runtime errors that must not be scored, resume after a
damaged results file, the single-writer lock, and per-language file names.
"""
import json
import os
import shutil
import subprocess
import sys
import tempfile

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.dirname(HERE)
sys.path.insert(0, HERE)
sys.path.insert(0, os.path.join(ROOT, "tools"))
import run_bench  # noqa: E402
from checks import evaluate  # noqa: E402
from scadreport import load_mesh, render, report  # noqa: E402

REF = open(os.path.join(ROOT, "bench/reference/tube_rack_1p5ml.scad")).read()  # frozen v1 key
FAILS = []


def check(name, cond, detail=""):
    print(("PASS " if cond else "FAIL ") + name + (f"  ({detail})" if detail and not cond else ""))
    if not cond:
        FAILS.append(name)


# ------------------------------------------------------------------ pathological model output
def scad_outcomes():
    tmp = tempfile.mkdtemp()
    cases = {
        "empty file": "",
        "2-D only": "square(10);",
        "syntax error": "cube([1,2,3]",
        "functional style": "a = cube(10); render(a);",
        "include of a missing file": "include <nope.scad>\ncube(5);",
        "far-away second body": "cube(10); translate([1e4,0,0]) cube(1);",
        "zero-thickness wall": "cube([10,10,0]);",
        "infinite loop guard": "function f(x) = f(x); echo(f(1));",
    }
    for name, code in cases.items():
        p = os.path.join(tmp, "x.scad")
        open(p, "w").write(code)
        text, data, mesh = report(p, timeout=30)
        ok = data["render"]["ok"]
        if name == "include of a missing file":  # OpenSCAD warns, then renders the rest
            check(f"report: {name} -> renders with a warning", ok and "WARNING" in text)
        elif name == "far-away second body":
            check(f"report: {name} renders and reports 2 bodies", ok and data["geometry"]["bodies"] == 2)
        else:
            check(f"report: {name} -> no printable part, no crash", not ok, text[:120])
    # a huge mesh must be refused before analysis
    p = os.path.join(tmp, "big.stl")
    with open(p, "wb") as fh:
        fh.write(b"\0" * 80 + (3_000_000).to_bytes(4, "little"))
        fh.truncate(84 + 50 * 2_100_000)
    try:
        load_mesh(p)
        check("huge mesh refused", False)
    except ValueError:
        check("huge mesh refused", True)
    shutil.rmtree(tmp)


# ------------------------------------------------------------------ checker invariances
def checker_cases():
    import yaml
    tasks = {t["id"]: t for t in yaml.safe_load(open(os.path.join(HERE, "tasks.yaml")))}
    refs = json.load(open(os.path.join(HERE, "reference_stats.json")))
    tmp = tempfile.mkdtemp()
    variants = {
        "reference": (REF, True),
        "shifted far from origin": (f"translate([500,-300,40]) {{ {REF.split('difference()', 1)[0]} difference(){REF.split('difference()', 1)[1]} }}", True),
        "holes 0.6 mm too small": (REF.replace("hole_d = 11.2;", "hole_d = 10.6;"), False),
        "through holes (no floor)": (REF.replace("hole_depth = 25;", "hole_depth = 30;"), False),
        "low $fn (polygonal holes)": (REF.replace("$fn = 64;", "$fn = 6;"), False),
        "upside down": (f"translate([0,0,30]) mirror([0,0,1]) {{ {REF.split('/* [Hidden] */')[1]} }}".replace("$fn = 64;\neps = 0.01;", "") , False),
    }
    for name, (code, should_pass) in variants.items():
        if name not in ("reference", "upside down", "shifted far from origin") and code == REF:
            check(f"checker: mutation '{name}' applies", False, "mutation did not change the design")
            continue
        if name == "upside down":
            code = REF.split("difference()")[0] + "translate([0,0,30]) mirror([0,0,1]) difference()" + REF.split("difference()", 1)[1]
        if name == "shifted far from origin":
            code = REF.split("difference()")[0] + "translate([500,-300,40]) difference()" + REF.split("difference()", 1)[1]
        p = os.path.join(tmp, "v.scad")
        open(p, "w").write(code)
        r = render(p, p + ".stl")
        res = evaluate(load_mesh(p + ".stl"), tasks["tube_rack_1p5ml"], refs["tube_rack_1p5ml"]) if r["ok"] else None
        got = bool(res and res["passed"])
        check(f"checker: {name} -> {'pass' if should_pass else 'fail'}", got == should_pass,
              str([i for i in (res or {}).get('items', []) if not i['ok']][:2]))
    shutil.rmtree(tmp)


# ------------------------------------------------------------------ harness with a fake backend
class Fake:
    """Replays scripted replies; a reply of None raises a runtime error."""
    script = []

    def __init__(self, *a, **k):
        self.think = None
        self.opts = {}

    def chat(self, system, user):
        reply = Fake.script.pop(0)
        if reply is None:
            raise run_bench.InfraError("server went away")
        return reply, {"gen_tokens": 1, "gen_s": 0.1}

    def close(self):
        pass


def run(args, script):
    Fake.script = list(script)
    run_bench.make_backend = lambda *a, **k: Fake()
    run_bench.ollama_ready = lambda m, wait_s=0: None
    sys.argv = ["run_bench.py"] + args
    try:
        run_bench.main()
        return 0
    except SystemExit as e:
        return e.code


def harness_cases():
    run_dir = os.path.join(HERE, "results", "_selftest")
    shutil.rmtree(run_dir, ignore_errors=True)
    good = "```openscad\n" + REF + "\n```"
    base = ["--run", "_selftest", "--models", "fake:1", "--tasks", "tube_rack_1p5ml", "gel_comb_10well"]
    res = os.path.join(run_dir, "results.jsonl")

    # 1: a runtime error on the first task is skipped, not scored; the second task still runs
    run(base, [None, "no code here", "still nothing", "nope"])
    recs = [json.loads(line) for line in open(res)]
    check("runtime error is not recorded as a model failure",
          [r["task"] for r in recs] == ["gel_comb_10well"], str([r["task"] for r in recs]))
    # 2: resume reruns only the skipped task; a damaged last line is dropped and rerun
    with open(res, "a") as fh:
        fh.write('{"model": "fake:1", "task": "tube_r')  # power loss mid-write
    run(base, [good])
    recs = [json.loads(line) for line in open(res)]
    check("resume after damaged line", sorted(r["task"] for r in recs) == ["gel_comb_10well", "tube_rack_1p5ml"])
    check("reference passes through the full harness",
          any(r["task"] == "tube_rack_1p5ml" and r["passed"] for r in recs))
    # 3: three runtime errors in a row stop the run with a clear message
    code = run(base + ["--lang", "es", "--prompts", os.path.join(HERE, "prompts", "translations.yaml"),
                       "--tasks", "tube_rack_1p5ml", "gel_comb_10well", "lab_funnel_60mm"], [None, None, None])
    check("3 runtime errors stop the run", isinstance(code, str) and "runtime errors" in code, str(code))
    # 4: per-language file names do not overwrite English ones
    run(base + ["--lang", "es", "--prompts", os.path.join(HERE, "prompts", "translations.yaml")], [good] * 4)
    files = os.listdir(os.path.join(run_dir, "code", "fake_1"))
    check("language runs keep their own code files",
          "tube_rack_1p5ml_s0_a0.scad" in files and "tube_rack_1p5ml_s0_es_a0.scad" in files, str(sorted(files))[:200])
    # 5: a missing translation is an error, never a silent English fallback
    tmp_yaml = os.path.join(run_dir, "t.yaml")
    open(tmp_yaml, "w").write("xx:\n  tube_rack_1p5ml: hola\n")
    code = run(base + ["--lang", "xx", "--prompts", tmp_yaml], [])
    check("missing translation refused", isinstance(code, str) and "translation" in code, str(code))
    # 6: a second writer on the same run is refused
    import fcntl
    lock = open(os.path.join(run_dir, ".lock"), "w")
    fcntl.flock(lock, fcntl.LOCK_EX | fcntl.LOCK_NB)
    code = run(base, [])
    check("second concurrent writer refused", isinstance(code, str) and "already" in code, str(code))
    lock.close()
    shutil.rmtree(run_dir)


if __name__ == "__main__":
    if not shutil.which(os.environ.get("OPENSCAD", "openscad")):
        sys.exit("OpenSCAD is needed for these tests")
    scad_outcomes()
    checker_cases()
    harness_cases()
    print(f"\n{'ALL PASS' if not FAILS else str(len(FAILS)) + ' FAILED: ' + ', '.join(FAILS)}")
    sys.exit(1 if FAILS else 0)
