#!/usr/bin/env python3
"""Tests for the method backends (templates, features) inside run_bench.py's conversation loop, with the model
replaced by scripted JSON (no Ollama needed; real OpenSCAD renders).

    .venv/bin/python -I bench/smallmodels/test_methods.py      # OpenSCAD on PATH, or set $OPENSCAD
"""
import json
import os
import sys
import tempfile
import types

HERE = os.path.dirname(os.path.abspath(__file__))
BENCH = os.path.dirname(HERE)
sys.path[:0] = [HERE, os.path.join(HERE, "templates"), os.path.join(HERE, "features"), BENCH,
                os.path.join(os.path.dirname(BENCH), "tools")]
import yaml  # noqa: E402
import common  # noqa: E402
import plugins  # noqa: E402
import run_bench  # noqa: E402
import backend as TB  # noqa: E402  (templates)
import fbackend as FB  # noqa: E402

# The frozen library reads the seeds by absolute path (/home/seb/printpaper/finetune/seeds), which exists only in the
# author's checkout; the tests use this tree's own seeds instead (the files templates/FROZEN.sha256 covers).
SEEDS = os.path.join(os.path.dirname(BENCH), "finetune", "seeds")
_load = TB.L.load
TB.L.load = lambda seeds_dir=SEEDS: _load(seeds_dir)
if not TB.L.load():
    sys.exit(f"no template seeds in {SEEDS}")

FAILS = []


def check(name, cond, detail=""):
    print(("PASS " if cond else "FAIL ") + name + (f"  ({detail})" if detail and not cond else ""))
    if not cond:
        FAILS.append(name)


class Script:
    """Stands in for common.ollama_json: returns the scripted objects in order and records the messages sent."""

    def __init__(self, replies):
        self.replies, self.calls = list(replies), []

    def __call__(self, model, messages, schema, opts, timeout=1800):
        self.calls.append({"messages": [dict(m) for m in messages], "schema": schema, "opts": dict(opts)})  # as sent
        r = self.replies.pop(0)
        if isinstance(r, Exception):
            raise r
        return r, json.dumps(r), {"wall_s": 0.1, "prompt_tokens": 10, "gen_tokens": 5, "gen_s": 0.1}


def patch(script):
    TB.ollama_json = script
    FB.ollama_json = script


def args_ns():
    return types.SimpleNamespace(max_repairs=2, seed_base=1000, sample_idx=0, render_timeout=120, feedback="report")


def task(tid):
    tasks = {t["id"]: t for t in yaml.safe_load(open(os.path.join(BENCH, "tasks.yaml")))}
    t = dict(tasks[tid])
    t["prompt_used"] = t["prompt"]
    refs = json.load(open(os.path.join(BENCH, "reference_stats.json")))
    return t, refs[tid]


def template_conversation():
    lib = TB.L.load()
    fam = lib["grid_tray"]
    good = TB.L.clamp(fam, {})
    bad = dict(good)
    script = Script([{"design": "grid_tray"}, bad, good, good])
    patch(script)
    b = TB.TemplateBackend("m", 0.2, 1000)
    t, ref = task("tube_rack_1p5ml")
    with tempfile.TemporaryDirectory() as d:
        attempts = run_bench.run_one(b, "", t, ref, args_ns(), d, "x")
    check("template: three attempts when the part never passes", len(attempts) == 3, len(attempts))
    check("template: every attempt carries a built file that renders",
          all(a["extract"] != "none" and a["render"]["ok"] for a in attempts), [a["render"] for a in attempts])
    check("template: choose once, then one fill per attempt", len(script.calls) == 4, len(script.calls))
    fb = script.calls[2]["messages"][-1]["content"]
    check("template: the second fill sees the harness's feedback", "measurement report" in fb, fb[:200])
    check("template: the fill schema has one field per parameter",
          set(script.calls[1]["schema"]["required"]) == {p["name"] for p in fam["params"]})
    check("template: a fresh seed per attempt reaches the model",
          [c["opts"]["seed"] for c in script.calls[1:]] == [1000, 1001, 1002], [c["opts"]["seed"] for c in script.calls])


def template_none():
    script = Script([{"design": "none"}])
    patch(script)
    b = TB.TemplateBackend("m", 0.2, 1000)
    t, ref = task("gel_comb_10well")
    with tempfile.TemporaryDirectory() as d:
        attempts = run_bench.run_one(b, "", t, ref, args_ns(), d, "x")
    check("template none: no file, three attempts, no further model calls",
          len(attempts) == 3 and all(a["extract"] == "none" for a in attempts) and len(script.calls) == 1,
          (len(attempts), len(script.calls)))
    check("template none: counts as a failure", not any(a["passed"] for a in attempts))


def template_bad_json():
    script = Script([{"design": "grid_tray"}, None, {"cols": "x"}])  # unparsable fill, then a wrong type
    patch(script)
    b = TB.TemplateBackend("m", 0.2, 1000)
    text, usage = b.chat("", "a tray")
    check("template: an unparsable fill falls back to the defaults", "```openscad" in text and usage["params"])
    text, usage = b.chat("", "feedback")
    check("template: a wrong-typed value falls back to the default",
          usage["params"]["cols"] == TB.L.clamp(TB.L.load()["grid_tray"], {})["cols"])


def features_conversation():
    part = {"bodies": [{"solids": [{"shape": "box", "size": [40, 30, 5], "at": [0, 0, 0]}],
                        "cuts": [{"cut": "hole", "d": 4, "depth": None, "at": [0, 0],
                                  "grid": {"nx": 2, "ny": 2, "pitch_x": 30, "pitch_y": 20}}]}]}
    script = Script([part, {"bodies": []}, "not a dict"])
    patch(script)
    b = FB.FeaturesBackend("m", 0.2, 1000)
    t, ref = task("seed_sowing_template")
    with tempfile.TemporaryDirectory() as d:
        attempts = run_bench.run_one(b, "", t, ref, args_ns(), d, "x")
    check("features: three attempts", len(attempts) == 3, len(attempts))
    check("features: the first list builds a part", attempts[0]["render"]["ok"], attempts[0]["render"])
    check("features: an empty or broken list gives a file that does not build, no crash",
          not attempts[1]["render"]["ok"] and not attempts[2]["render"]["ok"])
    msgs = script.calls[1]["messages"]
    check("features: the conversation keeps the earlier list and the feedback",
          msgs[-2]["role"] == "assistant" and "measurement report" in msgs[-1]["content"])


def revolve_on_axis():
    import scadreport  # noqa: E402
    part = {"bodies": [{"solids": [{"shape": "revolve", "profile": [[0, 0], [10, 0], [10, 10], [0, 10]],
                                    "at": [0, 0, 0]}], "cuts": []}]}
    with tempfile.TemporaryDirectory() as d:
        scad, stl = os.path.join(d, "p.scad"), os.path.join(d, "p.stl")
        open(scad, "w").write(FB.C.compile_part(part))
        r = scadreport.render(scad, stl)
        info = scadreport.analyse(scadreport.load_mesh(stl)) if r["ok"] else {}
    check("features: a revolve with points on the axis builds a watertight solid of the right volume",
          info.get("watertight") is True and abs((info.get("volume") or 0) - 3136.5) < 5, info.get("volume"))


def guard_and_names():
    check("method_model parses template:<model>", run_bench.method_model("template:gemma4:e4b-it-q4_K_M") == "gemma4:e4b-it-q4_K_M")
    check("method_model leaves plain names alone", run_bench.method_model("gemma4:e4b-it-q4_K_M") is None)
    check("method_model ignores a bare method name", run_bench.method_model("template:") is None)
    script = Script([OSError("connection refused")])
    patch(script)
    b = plugins.guard(TB.TemplateBackend("m", 0.2, 1000), run_bench.InfraError)
    try:
        b.chat("", "x")
        check("guard: a runtime failure becomes InfraError", False)
    except run_bench.InfraError:
        check("guard: a runtime failure becomes InfraError", True)
    check("guard: the backend's opts stay reachable for the harness's seeds", isinstance(b.opts, dict))


if __name__ == "__main__":
    real = common.ollama_json
    try:
        template_conversation()
        template_none()
        template_bad_json()
        features_conversation()
        revolve_on_axis()
        guard_and_names()
    finally:
        TB.ollama_json = FB.ollama_json = real
    print(f"\n{len(FAILS)} failed" if FAILS else "\nall passed")
    sys.exit(1 if FAILS else 0)
