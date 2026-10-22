#!/usr/bin/env python3
"""R4's offline measures on the held-out set (PROTOCOL.md, "R4 test plan", "Offline, free"), counts only.

    nice -n 10 ~/printpaper/.venv/bin/python -I r4_offline.py scadfix [--workers 3] [--tmp DIR]
    nice -n 10 ~/printpaper/.venv/bin/python -I r4_offline.py spec --write [--workers 3]

scadfix: scadfix 1.0 re-scores the saved attempts, as round 1's scadfix/test_eval.py did on the original set. Every
  saved attempt's file goes through scadfix.fix; where a rule fires, the fixed file is rendered and checked with the
  harness's own hidden checks, and that verdict replaces the recorded one. A what-if, not a rerun: the feedback and
  the later attempts are as recorded.
spec: the spec 1 gate, as spec/bench_gate.py did on the original set. The frozen writer (Gemma 4 E4B, prompt v1,
  seed 1000) writes one spec per request (--write makes the missing ones: the only model calls); the reference
  parts and every saved attempt are measured (spec.measure); the gate's verdicts are compared with the hidden
  checks' recorded ones: precision and recall, on first attempts and on all attempts.

Everything per task (specs, measurements, per-attempt rows) goes to --out, by default inside bench/heldout/, and is
never printed. --harness, --runs, --model, --specs and --cache point the same code at the original set, to check
it against round 1's numbers.
"""
import argparse
import collections
import filecmp
import hashlib
import json
import os
import re
import shutil
import sys
import tempfile
from concurrent.futures import ProcessPoolExecutor

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
HELDOUT = os.path.join(ROOT, "bench", "heldout", "harness")
RUNS = ["r4-coder7b", "r4-gemma4e4b", "r4-bonsai", "r4-gemma26b-std", "r4-gemma26b-h4", "r4-qwen38-std",
        "r4-qwen36-std"]
SCADFIX_SHA = "85f74e839594e33576d6923be770a90f05c918324252febda804f40b490dc334"  # 1.0
SPEC_SHA = "8333f8d6e1b9c1a4a47b50978e2716c9d6a5028f97aefa33541ab65020ed2541"  # spec 1
WRITER = "gemma4:e4b-it-q4_K_M"
_W = {}


def sha256(path):
    return hashlib.sha256(open(path, "rb").read()).hexdigest()


def load(harness, run, model=None):
    """The newest record per (model, task, sample, feedback), as r4_summary.py; records flagged needs_rerun are left
    out, and so are damaged lines (counted). A missing run, or one without records, is an error."""
    path = os.path.join(harness, "bench", "results", run, "results.jsonl")
    if not os.path.exists(path):
        raise SystemExit(f"{run}: no {path}")
    newest, bad = {}, 0
    for line in open(path, encoding="utf-8", errors="replace"):
        try:
            r = json.loads(line)
            key = (r["model"], r["task"], r["sample"], r.get("feedback", "report"))
        except (json.JSONDecodeError, KeyError, TypeError, AttributeError):  # half-written or foreign line
            bad += bool(line.strip())
            continue
        if r.get("needs_rerun") or r.get("lang", "en") != "en" or (model and r["model"] != model):
            continue
        if key not in newest or str(r.get("finished", "")) >= str(newest[key].get("finished", "")):
            newest[key] = r
    if bad:
        print(f"warning: {run}: {bad} damaged line(s) skipped", file=sys.stderr)
    if not newest:
        raise SystemExit(f"{run}: no records" + (f" for model {model!r}" if model else ""))
    return list(newest.values())


def attempt_path(harness, run, rec, k):
    """As spec/bench_gate.py: bench/results/RUN/code/MODEL/TASK_sS[_lang][_feedback]_aK.scad."""
    suffix = "".join(f"_{x}" for x, d in ((rec.get("lang", "en"), "en"), (rec.get("feedback", "report"), "report"))
                     if x != d)
    safe = re.sub(r"[^A-Za-z0-9._-]+", "_", rec["model"])
    return os.path.join(harness, "bench", "results", run, "code", safe,
                        f"{rec['task']}_s{rec['sample']}{suffix}_a{k}.scad")


def _init(harness, tmp):
    sys.path[:0] = [os.path.join(harness, "bench"), os.path.join(harness, "tools")]
    import yaml
    _W["tmp"] = tmp
    tempfile.tempdir = tmp
    _W["tasks"] = {t["id"]: t for t in yaml.safe_load(open(os.path.join(harness, "bench", "tasks.yaml"),
                                                           encoding="utf-8"))}
    _W["refs"] = json.load(open(os.path.join(harness, "bench", "reference_stats.json"), encoding="utf-8"))


def score(job):
    """(code, task id, file name) -> (renders, passes): the file rendered and checked as bench/rescore.py does."""
    from checks import evaluate
    from scadreport import load_mesh, render
    code, task, name = job
    d = tempfile.mkdtemp(prefix="r4_offline_", dir=_W["tmp"])
    try:
        src, stl = os.path.join(d, name), os.path.join(d, "x.stl")
        with open(src, "w", encoding="utf-8", errors="replace") as fh:
            fh.write(code)
        if not render(src, stl)["ok"]:
            return False, False
        try:
            res = evaluate(load_mesh(stl), _W["tasks"][task], _W["refs"][task])
        except Exception:  # noqa: BLE001  (rescore: mesh analysis failed)
            return False, False
        return True, bool(res["passed"])
    finally:
        shutil.rmtree(d, ignore_errors=True)


def run_scadfix(a):
    sys.path.insert(0, os.path.join(HERE, "scadfix"))
    import scadfix
    if sha256(os.path.join(HERE, "scadfix", "scadfix.py")) != SCADFIX_SHA:
        raise SystemExit("scadfix.py is not the frozen 1.0")
    rows = []
    for run in a.runs:
        for rec in load(a.harness, run, a.model):
            for k, at in enumerate(rec["attempts"][:3]):
                p = attempt_path(a.harness, run, rec, k)
                row = {"run": run, "model": rec["model"], "task": rec["task"], "sample": rec["sample"], "attempt": k,
                       "render_before": bool((at.get("render") or {}).get("ok")), "pass_before": bool(at.get("passed")),
                       "missing": not os.path.exists(p), "fired": []}
                if not row["missing"] and at.get("extract") != "none":
                    fixed, fired = scadfix.fix(open(p, encoding="utf-8", errors="replace").read())
                    if fired:
                        row.update(fired=fired, _job=(fixed, rec["task"], os.path.basename(p)))
                rows.append(row)
    fired = [r for r in rows if r["fired"]]
    with ProcessPoolExecutor(a.workers, initializer=_init, initargs=(a.harness, a.tmp)) as ex:
        for r, (ren, ok) in zip(fired, ex.map(score, [r["_job"] for r in fired], chunksize=2)):
            r["render_after"], r["pass_after"] = ren, ok
    for r in rows:
        if not r["fired"]:
            r["render_after"], r["pass_after"] = r["render_before"], r["pass_before"]
    os.makedirs(a.out, exist_ok=True)
    with open(os.path.join(a.out, "scadfix_rows.jsonl"), "w") as fh:
        for r in rows:
            fh.write(json.dumps({k: v for k, v in r.items() if not k.startswith("_")}) + "\n")
    print(f"scadfix {scadfix.VERSION}: {len(rows)} saved attempts, {sum(r['missing'] for r in rows)} without a file; "
          f"a rule fired on {len(fired)}; rule errors {len(scadfix.ERRORS)}")
    print("| Run | Model | Renders 1st try | Pass 1st try | Pass <=3 tries | Fixed files (render / pass) | Rules |")
    print("|---|---|---:|---:|---:|---:|---|")
    by = collections.defaultdict(list)
    for r in rows:
        by[(r["run"], r["model"])].append(r)
    for (run, model), rs in by.items():
        conv = collections.defaultdict(list)
        for r in rs:
            conv[(r["sample"], r["task"])].append(r)
        samples = sorted({s for s, _ in conv})
        first = {s: [r for r in rs if r["sample"] == s and r["attempt"] == 0] for s in samples}

        def fmt(f):
            return " + ".join(str(f(s)) for s in samples)
        tasks = lambda s, key: sum(any(r[key] for r in v) for (s2, _), v in conv.items() if s2 == s)  # noqa: E731
        fx = [r for r in rs if r["fired"]]
        rules = collections.Counter(n for r in fx for n in r["fired"])
        print(f"| {run} | {model} | {fmt(lambda s: sum(r['render_before'] for r in first[s]))} -> "
              f"{fmt(lambda s: sum(r['render_after'] for r in first[s]))} | "
              f"{fmt(lambda s: sum(r['pass_before'] for r in first[s]))} -> "
              f"{fmt(lambda s: sum(r['pass_after'] for r in first[s]))} | "
              f"{fmt(lambda s: tasks(s, 'pass_before'))} -> {fmt(lambda s: tasks(s, 'pass_after'))} | "
              f"{len(fx)} ({sum(r['render_after'] for r in fx)} / {sum(r['pass_after'] for r in fx)}) | "
              + ", ".join(f"{k} {v}" for k, v in rules.most_common()) + " |")


def run_spec(a):
    sys.path.insert(0, os.path.join(HERE, "spec"))
    import spec as S
    import yaml
    if sha256(os.path.join(HERE, "spec", "spec.py")) != SPEC_SHA:
        raise SystemExit("spec.py is not the frozen spec 1")
    if not filecmp.cmp(os.path.join(ROOT, "tools", "scadreport.py"), os.path.join(a.harness, "tools", "scadreport.py"),
                       shallow=False):
        raise SystemExit("spec.measure renders with the repo's tools/scadreport.py, and the harness's copy differs")
    tasks = yaml.safe_load(open(os.path.join(a.harness, "bench", "tasks.yaml"), encoding="utf-8"))
    order = [t["id"] for t in tasks]
    os.makedirs(a.out, exist_ok=True)
    specs_path = a.specs or os.path.join(a.out, "specs.jsonl")
    specs = {}
    for line in open(specs_path) if os.path.exists(specs_path) else []:
        d = json.loads(line)
        if d["writer"] == WRITER:
            specs[d["task"]] = d["spec"]
    if a.write:
        for t in tasks:
            if t["id"] not in specs:
                res = S.write_spec(WRITER, t["prompt"])  # prompt v1, seed 1000: as frozen
                with open(specs_path, "a") as fh:
                    fh.write(json.dumps({"writer": WRITER, "task": t["id"], "spec": res["spec"], "raw": res["raw"],
                                         "usage": res["usage"]}) + "\n")
                specs[t["id"]] = res["spec"]
    if any(t not in specs for t in order):
        raise SystemExit(f"{sum(t not in specs for t in order)} of {len(order)} specs missing: rerun with --write")
    print(f"specs: {len(order)} written by {WRITER}, {sum(specs[t] is not None for t in order)} parsed", flush=True)

    files = {("ref", t): os.path.join(a.harness, "bench", "reference", f"{t}.scad") for t in order}
    recs = {run: load(a.harness, run, a.model) for run in a.runs}
    for run, rs in recs.items():
        for r in rs:
            for k in range(len(r["attempts"])):
                files[(run, r["model"], r["task"], r["sample"], k)] = attempt_path(a.harness, run, r, k)
    present = {key: p for key, p in files.items() if os.path.exists(p)}
    cache_path = a.cache or os.path.join(a.out, "measure_cache.json")
    cache = json.load(open(cache_path)) if os.path.exists(cache_path) else {}
    keys = {key: f"{os.path.relpath(p, a.harness)}#{hashlib.sha1(open(p, 'rb').read()).hexdigest()[:12]}"
                 f"#mv{S.MEASURE_VERSION}" for key, p in present.items()}  # spec/bench_gate.py's cache key
    todo = sorted({keys[key]: p for key, p in present.items() if keys[key] not in cache}.items())
    print(f"{len(present)} files ({len(files) - len(present)} missing), {len(todo)} to measure", flush=True)
    with ProcessPoolExecutor(a.workers) as ex:
        for i, ((ck, _), m) in enumerate(zip(todo, ex.map(S.measure, [p for _, p in todo], chunksize=4)), 1):
            cache[ck] = m
            if i % 50 == 0 or i == len(todo):
                json.dump(cache, open(cache_path, "w"))
                print(f"  measured {i}/{len(todo)}", flush=True)
    m_of = lambda key: cache.get(keys[key]) if key in keys else None  # noqa: E731

    print(f"the gate accepts {sum(S.gate(specs[t], m_of(('ref', t)))[0] for t in order)}/{len(order)} reference parts")
    print("| Run | Model | First attempts | right | gate accepts | of them right | right accepted |")
    print("|---|---|---:|---:|---:|---:|---:|")
    pool = collections.Counter()
    for run, rs in recs.items():
        for model in sorted({r["model"] for r in rs}):
            c = collections.Counter()
            for r in (x for x in rs if x["model"] == model):
                for k, att in enumerate(r["attempts"]):
                    g = S.gate(specs[r["task"]], m_of((run, model, r["task"], r["sample"], k)))[0]
                    h = bool(att.get("passed"))
                    c[("first_" if k == 0 else "later_") + (("tp" if h else "fp") if g else ("fn" if h else "tn"))] += 1
            for key, v in c.items():
                pool[key.split("_", 1)[1]] += v
                pool[key] += v
            tp, fp, fn, tn = (c.get("first_" + x, 0) for x in ("tp", "fp", "fn", "tn"))
            print(f"| {run} | {model} | {tp + fp + fn + tn} | {tp + fn} | {tp + fp} | "
                  f"{tp / (tp + fp) if tp + fp else float('nan'):.2f} | {tp / (tp + fn) if tp + fn else float('nan'):.2f} |")
    for label, pre in (("first attempts", "first_"), ("all attempts", "")):
        tp, fp, fn, tn = (pool[pre + x] for x in ("tp", "fp", "fn", "tn"))
        ratio = lambda x, n: f"{x / n:.2f}" if n else "n/a"  # noqa: E731  (0/0 is not a precision of 0)
        print(f"{label}: {tp + fp + fn + tn}, right {tp + fn}; the gate accepts {tp + fp}, of them right "
              f"{ratio(tp, tp + fp)} (precision), right parts accepted {ratio(tp, tp + fn)} (recall)")


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("what", choices=["scadfix", "spec"])
    ap.add_argument("--harness", default=HELDOUT, help="a harness root holding bench/ and tools/")
    ap.add_argument("--runs", nargs="+", default=RUNS)
    ap.add_argument("--model", help="only this model's records")
    ap.add_argument("--out", help="where per-task material goes (default: bench/results/_offline in the harness)")
    ap.add_argument("--specs", help="specs file (default: specs.jsonl in --out)")
    ap.add_argument("--cache", help="measurement cache (default: measure_cache.json in --out)")
    ap.add_argument("--write", action="store_true", help="spec: write the missing specs (the frozen writer's calls)")
    ap.add_argument("--workers", type=int, default=3)
    ap.add_argument("--tmp", default=tempfile.gettempdir())
    a = ap.parse_args()
    a.out = a.out or os.path.join(a.harness, "bench", "results", "_offline")
    run_scadfix(a) if a.what == "scadfix" else run_spec(a)


if __name__ == "__main__":
    main()
