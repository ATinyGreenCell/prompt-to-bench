#!/usr/bin/env python3
"""Robustness tests for the benchmark harness, checker and scadreport (no model or GPU needed).

    python bench/test_harness.py

Uses a fake backend in place of Ollama/Claude and runs real OpenSCAD renders. Covers:
pathological model output, runtime errors that must not be scored, resume after a
damaged results file, the single-writer lock, per-language file names, code extraction,
render/checker edge cases, argument validation, missing binaries, and the rescore,
analyze, slicing and build-log tools on odd input.
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
    """Replays scripted replies; a reply of None raises a runtime error, Fake.NULL replies None."""
    script = []
    NULL = object()

    def __init__(self, *a, **k):
        self.think = None
        self.opts = {}

    def chat(self, system, user):
        reply = Fake.script.pop(0)
        if reply is None:
            raise run_bench.InfraError("server went away")
        if reply is Fake.NULL:
            reply = None
        return reply, {"gen_tokens": 1, "gen_s": 0.1}

    def close(self):
        pass


REAL_READY = run_bench.ollama_ready


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


# ------------------------------------------------------------------ code extraction
def extraction_cases():
    import random
    import re
    import time
    ex = run_bench.extract_code
    cases = [  # (name, reply, expected code, expected how)
        ("```OpenSCAD label", "```OpenSCAD\ncube(1);\n```", "cube(1);", "fenced"),
        ("```scad label", "text\n```scad\ncube(1);\n```", "cube(1);", "fenced"),
        ("CRLF line endings", "Here:\r\n```openscad\r\ncube(1);\r\n```\r\n", "cube(1);", "fenced"),
        ("labelled block wins over a longer other block", "```python\nprint('a long line of python')\n```\n```openscad\ncube(1);\n```",
         "cube(1);", "fenced"),
        ("longest of several openscad blocks", "```openscad\ncube(1);\n```\n```openscad\ncube([1,2,3]);\n```", "cube([1,2,3]);", "fenced"),
        ("fence inside <think> ignored", "<think>```openscad\nsphere(1);\n```</think>```openscad\ncube(1);\n```", "cube(1);", "fenced"),
        ("unclosed <think> (cut off while reasoning)", "<think>```openscad\nsphere(1);\n```", None, "none"),
        ("empty reply", "", None, "none"),
        ("None reply", None, None, "none"),
        ("prose only", "Sorry, I cannot design that part.", None, "none"),
        ("block without OpenSCAD calls is still code", "```openscad\nx = 1;\n```", "x = 1;", "fenced"),
        ("empty code block", "Here it is:\n```openscad\n```", None, "none"),
        ("whitespace-only blocks", "```openscad\n  \n```\n```\n\n```", None, "none"),
        ("empty labelled block, code in an unlabelled one", "```openscad\n```\n```\ncube(1);\n```", "cube(1);", "fenced"),
        ("unterminated block", "```openscad\ncube(1);", "cube(1);", "unterminated"),
        ("bare code", "cube(1);", "cube(1);", "bare"),
        ("unicode kept", "```openscad\n// Ä µ 😀 हिन्दी\ncube(1);\n```", "// Ä µ 😀 हिन्दी\ncube(1);", "fenced"),
        # deliberately unchanged mid-study (see report): ~~~ fences are not recognised
        ("~~~ fence stays 'bare' (unchanged)", "~~~openscad\ncube(1);\n~~~", "~~~openscad\ncube(1);\n~~~", "bare"),
    ]
    for name, reply, code, how in cases:
        got = ex(reply)
        check(f"extract: {name}", got == (code, how), repr(got))
    # possessive FENCE finds exactly what the original backtracking pattern found
    old = re.compile(r"```[ \t]*([A-Za-z0-9_+-]*)[^\n]*\n(.*?)```", re.S)
    rnd, alphabet = random.Random(1), ["```", "`", " ", "\t", "\n", "\r", "openscad", "scad", "a", "+", "-", "cube(1);", "~~~"]
    same = all(old.findall(t) == run_bench.FENCE.findall(t)
               for t in ("".join(rnd.choice(alphabet) for _ in range(rnd.randint(0, 40))) for _ in range(5000)))
    check("extract: FENCE pattern unchanged on 5000 random replies", same)
    for name, reply in (("a long line after a fence", "``` " + " " * 200_000 + "x"),
                        ("a 2 MB reply", "```openscad\n" + "cube(1);\n" * 200_000 + "```"),
                        ("many fences", "```\n" * 50_000)):
        t0 = time.time()
        ex(reply)
        run_bench.code_block_complete(reply)
        check(f"extract: {name} in linear time", time.time() - t0 < 2, f"{time.time() - t0:.1f}s")


# ------------------------------------------------------------------ render edge cases
def render_edges():
    import scadreport
    tmp = tempfile.mkdtemp(prefix="p2b test ")  # a path with spaces
    p = os.path.join(tmp, "my part.scad")

    def rep(code, **kw):
        open(p, "w").write(code)
        return report(p, **kw)
    text, data, _ = rep('import("missing.stl");')
    check("render: import() of a missing file -> no part, says why", not data["render"]["ok"] and "import" in text, text[:200])
    text, data, _ = rep('import("missing.stl"); cube(3);')
    check("render: missing import + other geometry -> renders with a warning", data["render"]["ok"] and "WARNING" in text)
    text, data, _ = rep("x = [for (i=[0:99999]) for (j=[0:99999]) if (i<0) i]; echo(len(x)); cube(1);", timeout=3)
    check("render: endless loop -> timeout message", not data["render"]["ok"] and "timed out" in text, text[:200])
    text, data, _ = rep("cube(5); translate([20,0,0]) cube(5);")
    check("render: disjoint bodies counted", data["geometry"]["bodies"] == 2 and "2 separate bodies" in text)
    text, data, _ = rep("cube(5); translate([5,5,0]) cube(5);")
    check("render: edge-touching cubes reported as not watertight", "NOT watertight" in text and data["geometry"]["volume"] is None)
    text, data, _ = rep("translate([0,0,-50]) cube(10);")
    check("render: part below z=0 is reported, not shifted", data["render"]["ok"] and "does not start at z = 0" in text)
    text, data, _ = rep("cube(1); // path with spaces")
    check("render: file path with spaces", data["render"]["ok"] and tmp not in text)
    open(p, "wb").write(b'echo("\xff\xfe latin-1"); cube(1);\n')
    text, data, _ = report(p)
    check("render: non-UTF-8 output from OpenSCAD does not crash", data["render"]["ok"])
    stl = os.path.join(tmp, "out.stl")
    open(p, "w").write("cube(2);")
    render(p, stl)
    open(p, "w").write("square(2);")
    r = render(p, stl)
    check("render: a failed render never reuses the previous STL", not r["ok"] and not os.path.exists(stl))
    old, scadreport.OPENSCAD = scadreport.OPENSCAD, "/nonexistent/openscad"
    try:
        render(p, stl)
        check("render: missing OpenSCAD binary -> clear error", False)
    except FileNotFoundError as e:
        check("render: missing OpenSCAD binary -> clear error", "OPENSCAD=" in str(e), str(e))
    check("render: openscad_missing() names the fix", "OPENSCAD=" in (scadreport.openscad_missing() or ""))
    scadreport.OPENSCAD = old
    # scadreport command line
    cli = [sys.executable, os.path.join(ROOT, "tools", "scadreport.py")]
    out = subprocess.run(cli + [os.path.join(tmp, "nope.scad")], capture_output=True, text=True)
    check("scadreport CLI: missing file -> clear message", out.returncode != 0 and "no such file" in out.stderr, out.stderr[-200:])
    out = subprocess.run(cli + [tmp], capture_output=True, text=True)
    check("scadreport CLI: a directory -> clear message", out.returncode != 0 and "no such file" in out.stderr)
    open(p, "w").write("cube([10,20,3]);")
    render(p, stl)
    out = subprocess.run(cli + [stl], capture_output=True, text=True)
    check("scadreport CLI: .stl input is analysed directly",
          out.returncode == 0 and "MESH FILE" in out.stdout and "size 20.00" in out.stdout, (out.stdout + out.stderr)[-300:])
    open(stl, "w").write("not a mesh")
    out = subprocess.run(cli + [stl], capture_output=True, text=True)
    check("scadreport CLI: broken .stl -> clean failure", out.returncode == 1 and "could not" in out.stdout, (out.stdout + out.stderr)[-300:])
    out = subprocess.run(cli + [p], capture_output=True, text=True, env={**os.environ, "OPENSCAD": "/nonexistent/openscad"})
    check("scadreport CLI: missing OpenSCAD -> clear message", out.returncode != 0 and "OpenSCAD not found" in out.stderr)
    shutil.rmtree(tmp)


# ------------------------------------------------------------------ checker on degenerate meshes
def checker_edges():
    import numpy as np
    import trimesh
    import yaml
    from checks import ref_problems
    tasks = {t["id"]: t for t in yaml.safe_load(open(os.path.join(HERE, "tasks.yaml")))}
    refs = json.load(open(os.path.join(HERE, "reference_stats.json")))
    box = trimesh.creation.box([10, 10, 10])
    nan = trimesh.Trimesh(np.where(np.arange(8)[:, None] == 0, np.nan, box.vertices), box.faces, process=False)
    meshes = {"box": box, "single triangle (zero volume)": trimesh.Trimesh([[0, 0, 0], [1, 0, 0], [0, 1, 0]], [[0, 1, 2]]),
              "point-like mesh": trimesh.Trimesh([[0, 0, 0]] * 3, [[0, 1, 2]], process=False), "NaN vertex": nan}
    for name, m in meshes.items():
        try:  # every slice of these is above / outside the part and every probe misses it
            res = [evaluate(m, t, refs[tid]) for tid, t in tasks.items()]
            check(f"checker: {name} vs every task -> fails cleanly", not any(r["passed"] for r in res))
        except Exception as e:  # noqa: BLE001
            check(f"checker: {name} vs every task -> fails cleanly", False, repr(e))
    try:
        evaluate(trimesh.Trimesh(), tasks["tube_rack_1p5ml"], refs["tube_rack_1p5ml"])
        check("checker: empty mesh -> ValueError", False)
    except ValueError:
        check("checker: empty mesh -> ValueError", True)
    t = tasks["gel_comb_10well"]
    check("checker: complete reference stats accepted", not any(ref_problems(t, refs[tid]) for tid, t in tasks.items()))
    broken = {k: v for k, v in refs[t["id"]].items() if k != "design_center"}
    check("checker: reference without design_center detected", ref_problems(t, broken) == ["design_center"])
    check("checker: reference without a slice area detected",
          ref_problems(t, dict(refs[t["id"]], material_area={})) == ["material_area[0.75]"], str(ref_problems(t, dict(refs[t["id"]], material_area={}))))
    check("checker: missing reference entry detected", ref_problems(t, None) != [])
    r = evaluate(box, tasks["conical_rack_50ml"], refs["conical_rack_50ml"])
    msg = {i["check"]: i["msg"] for i in r["items"]}
    check("checker: hole_d with no holes does not say 'ok'", msg.get("slice z=2 hole_d") == "no holes", str(msg.get("slice z=2 hole_d")))


def harness_edges():
    run_dir = os.path.join(HERE, "results", "_selftest")
    shutil.rmtree(run_dir, ignore_errors=True)
    res = os.path.join(run_dir, "results.jsonl")
    base = ["--run", "_selftest", "--models", "fake:1", "--max-repairs", "1"]

    def recs():
        return [json.loads(line) for line in open(res)]
    # empty code block: told there was no code, never "OpenSCAD could not build"
    run(base + ["--tasks", "gel_comb_10well"], ["```openscad\n```", "no code either"])
    a = recs()[-1]["attempts"]
    check("harness: empty code block -> 'no code' feedback",
          a[0]["extract"] == "none" and a[0]["feedback"].startswith("I could not find any OpenSCAD code"), str(a[0].get("feedback"))[:80])
    # a None reply and a reply with a lone surrogate are recorded, not a crash
    run(base + ["--tasks", "lab_funnel_60mm"], [Fake.NULL, "```openscad\ncube(1); // \ud800\n```"])
    r = recs()[-1]
    check("harness: None reply and lone-surrogate reply recorded",
          r["task"] == "lab_funnel_60mm" and r["attempts"][0]["reply_chars"] == 0 and r["attempts"][1]["render"]["ok"],
          str(r["attempts"])[:200])
    # duplicate task ids run once
    n = len(recs())
    run(base + ["--tasks", "micropestle_1p5ml", "micropestle_1p5ml"], ["x", "y", "z", "w"])
    check("harness: --tasks duplicates run once", len(recs()) == n + 1, str(len(recs()) - n))
    # resume: valid JSON that is not a record is dropped; a last line without newline is repaired
    with open(res, "a") as fh:
        fh.write("[]\n{}\n" + json.dumps(recs()[0]))  # no trailing newline
    code = run(base + ["--tasks", "gel_comb_10well", "lab_funnel_60mm", "micropestle_1p5ml"], [])
    lines = open(res).read().splitlines(keepends=True)
    check("harness: non-record lines dropped, file ends with a newline",
          code == 0 and all(line.endswith("\n") and json.loads(line).get("model") for line in lines), str(code))
    # bad arguments are refused before anything runs
    for name, extra, want in (
            ("unknown task id", ["--tasks", "tube_rack_1p5ml", "no_such_task"], "unknown task"),
            ("negative --max-repairs", ["--tasks", "tube_rack_1p5ml", "--max-repairs", "-1"], 2),
            ("--samples 0", ["--tasks", "tube_rack_1p5ml", "--samples", "0"], 2),
            ("--run with a path", ["--run", "../escape"], 2),
            ("missing --system file", ["--system", "/nonexistent/system.md"], 2),
            ("--prompts without that language", ["--lang", "fr", "--prompts", os.path.join(HERE, "prompts", "translations.yaml")], "no 'fr' section")):
        code = run(base + extra, [])
        check(f"harness: {name} refused", code == want if isinstance(want, int) else isinstance(code, str) and want in code, str(code))
    which = run_bench.shutil.which
    run_bench.shutil.which = lambda c, *a, **k: None if c == "claude" else which(c, *a, **k)
    code = run(["--run", "_selftest", "--models", "claude:x", "--tasks", "tube_rack_1p5ml"], [])
    run_bench.shutil.which = which
    check("harness: Claude CLI missing -> refused up front", isinstance(code, str) and "claude" in code, str(code))
    path = os.environ["PATH"]
    os.environ["PATH"] = run_dir
    cli = run_bench.ClaudeCLI("x")
    try:
        cli.chat("s", "u")
        check("harness: Claude CLI vanishing mid-run -> immediate clear error", False)
    except SystemExit as e:
        check("harness: Claude CLI vanishing mid-run -> immediate clear error", "not found" in str(e))
    finally:
        os.environ["PATH"] = path
        cli.close()
    shutil.rmtree(run_dir)


def ollama_edges():
    import http.server
    import threading

    class H(http.server.BaseHTTPRequestHandler):
        def log_message(self, *a):
            pass

        def do_GET(self):
            if self.server.mode == "html":
                self.send_response(200)
                self.end_headers()
                self.wfile.write(b"<html>not ollama</html>")
            elif self.server.mode == "404":
                self.send_error(404)
            else:
                self.send_response(200)
                self.end_headers()
                self.wfile.write(json.dumps({"models": [{"name": "a:1"}]}).encode())

        def do_POST(self):
            self.rfile.read(int(self.headers["Content-Length"]))
            self.send_response(200)
            self.end_headers()
            self.wfile.write(b'{"message": {"content": "partial "}}\n{"error": "model runner has unexpectedly stopped"}\n')

    srv = http.server.HTTPServer(("127.0.0.1", 0), H)
    srv.mode = "ok"
    threading.Thread(target=srv.serve_forever, daemon=True).start()
    old = run_bench.OLLAMA
    try:
        run_bench.OLLAMA = "http://127.0.0.1:9"  # nothing listens on the discard port
        try:
            REAL_READY("a:1", wait_s=0)
            check("ollama: server not running -> clear message", False)
        except SystemExit as e:
            check("ollama: server not running -> clear message", "ollama serve" in str(e), str(e))
        run_bench.OLLAMA = f"http://127.0.0.1:{srv.server_port}"
        REAL_READY("a:1", wait_s=0)
        check("ollama: installed model accepted", True)
        for mode, model, want in (("ok", "b:1", "ollama pull b:1"), ("404", "a:1", "OLLAMA_HOST"), ("html", "a:1", "OLLAMA_HOST")):
            srv.mode = mode
            try:
                REAL_READY(model, wait_s=0)
                check(f"ollama: {mode} server, model {model} -> clear message", False)
            except SystemExit as e:
                check(f"ollama: {mode} server, model {model} -> clear message", want in str(e), str(e))
        text, usage = run_bench.Ollama("a:1", 0.2, 1).chat("s", "u")
        check("ollama: error event mid-stream is recorded", text == "partial " and "unexpectedly" in usage.get("stream_error", ""),
              str(usage))
    finally:
        run_bench.OLLAMA = old
        srv.shutdown()


# ------------------------------------------------------------------ rescore / analyze / tools
def rescore_analyze_edges():
    import analyze
    import rescore
    import yaml
    out = subprocess.run([sys.executable, os.path.join(HERE, "rescore.py"), "_no_such_run", "--dry-run"],
                         capture_output=True, text=True)
    check("rescore: run folder that does not exist -> message, exit 1", out.returncode == 1 and "skipped" in out.stdout,
          (out.stdout + out.stderr)[-300:])
    run_dir = os.path.join(HERE, "results", "_selftest_rescore")
    os.makedirs(run_dir, exist_ok=True)
    tasks = {t["id"]: t for t in yaml.safe_load(open(os.path.join(HERE, "tasks.yaml")))}
    refs = json.load(open(os.path.join(HERE, "reference_stats.json")))
    check("rescore: missing results.jsonl -> skipped", rescore.rescore_run("_selftest_rescore", tasks, refs, True, "x") is False)
    open(os.path.join(run_dir, "results.jsonl"), "w").write('{"model": "m", "task": "tube_r')
    check("rescore: damaged line -> run skipped, file untouched",
          rescore.rescore_run("_selftest_rescore", tasks, refs, False, "x") is False
          and open(os.path.join(run_dir, "results.jsonl")).read() == '{"model": "m", "task": "tube_r')
    shutil.rmtree(run_dir)

    # analyze on odd results folders (analyze.HERE points at a scratch copy)
    tmp = tempfile.mkdtemp()
    rec = {"model": "not-in-models-yaml", "task": "tube_rack_1p5ml", "category": "benchware", "sample": 0,
           "attempts": [], "wall_s": 3, "finished": "2026-01-01T00:00:00"}
    files = {"empty": "", "damaged": '{"model": "x", "ta', "junk": "[]\n{}\n\"text\"\n", "zero": json.dumps(rec) + "\n",
             "spanish": json.dumps(dict(rec, lang="es", attempts=[{"passed": True, "render": {"ok": True}}])) + "\n"}
    for name, content in files.items():
        os.makedirs(os.path.join(tmp, "results", name))
        open(os.path.join(tmp, "results", name, "results.jsonl"), "w").write(content)
    old, analyze.HERE = analyze.HERE, tmp
    try:
        runs = analyze.load_runs()
        check("analyze: empty / damaged / non-record files load as empty runs",
              runs["empty"] == [] and runs["damaged"] == [] and runs["junk"] == [], str({k: len(v) for k, v in runs.items()}))
        all_tasks = yaml.safe_load(open(os.path.join(HERE, "tasks.yaml")))
        meta = {m["id"]: m for m in yaml.safe_load(open(os.path.join(HERE, "models.yaml")))}
        rows = analyze.summarise(runs["zero"], meta, all_tasks)
        tables = [analyze.table_main(rows), analyze.table_graded(rows), analyze.table_failures(rows),
                  analyze.table_categories(runs["zero"], rows), analyze.table_main(analyze.summarise([], meta, all_tasks))]
        check("analyze: zero-attempt record of an unknown model -> tables", "not-in-models-yaml" in tables[0] and rows[0]["pass3"] == 0)
        check("analyze: wilson with n=0", analyze.wilson(0, 0) == (0.0, 0.0))
        lt = analyze.language_tests(runs["spanish"])
        check("analyze: language run without an English baseline -> no rows", lt.count("\n") == 1, lt)
        drawn = analyze.fig_lang(runs["spanish"] + runs["zero"], meta, analyze.THEMES["light"], os.path.join(tmp, "f.png"), "t")
        check("analyze: language figure without English", drawn and os.path.exists(os.path.join(tmp, "f.png")))
    finally:
        analyze.HERE = old
        shutil.rmtree(tmp)


def tool_edges():
    env = {**os.environ, "OPENSCAD": "/nonexistent/openscad", "PRUSASLICER": "/nonexistent/prusa-slicer"}
    for script, want in (("slice_library.py", "PrusaSlicer command not found"), ("render_designs.py", "OpenSCAD not found")):
        out = subprocess.run([sys.executable, os.path.join(ROOT, "tools", script)], capture_output=True, text=True, env=env)
        check(f"{script}: missing binary -> clear message", out.returncode != 0 and want in out.stderr
              and "Traceback" not in out.stderr, out.stderr[-300:])
    out = subprocess.run([sys.executable, os.path.join(ROOT, "tools", "slice_library.py")], capture_output=True, text=True,
                         env={**env, "PRUSASLICER": sys.executable})
    check("slice_library.py: missing OpenSCAD -> clear message", out.returncode != 0 and "OpenSCAD not found" in out.stderr,
          out.stderr[-300:])
    sys.path.insert(0, os.path.join(ROOT, "meta"))
    import build_log
    tmp = tempfile.mkdtemp()
    p = os.path.join(tmp, "s.jsonl")
    with open(p, "wb") as fh:
        fh.write(b'[]\n"x"\n{"type": "assistant", "message": "just a string"}\n'
                 b'{"type": "assistant", "message": {"content": "plain text reply"}}\n'
                 b'{"type": "assistant", "message": {"content": ["s", {"type": "tool_use", "name": "X", "input": "raw"}]}}\n'
                 b'{"type": "user", "message": {"content": 5}}\n{"type": "user", "message": {"content": "hi \xff"}}\n')
    try:
        ev = list(build_log.events(p))
        check("build_log: malformed session lines skipped", [w for _, w, _ in ev] == ["claude", "tool", "human"], str(ev))
    except Exception as e:  # noqa: BLE001
        check("build_log: malformed session lines skipped", False, repr(e))
    shutil.rmtree(tmp)


if __name__ == "__main__":
    if not shutil.which(os.environ.get("OPENSCAD", "openscad")):
        sys.exit("OpenSCAD is needed for these tests")
    scad_outcomes()
    checker_cases()
    harness_cases()
    extraction_cases()
    render_edges()
    checker_edges()
    harness_edges()
    ollama_edges()
    rescore_analyze_edges()
    tool_edges()
    print(f"\n{'ALL PASS' if not FAILS else str(len(FAILS)) + ' FAILED: ' + ', '.join(FAILS)}")
    sys.exit(1 if FAILS else 0)
