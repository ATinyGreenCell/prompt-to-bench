#!/usr/bin/env python3
"""Development evaluation of scadfix on attempts outside the 16 benchmark tasks.

    nice -n 10 python -I -B dev_eval.py --tmp /some/scratch/dir [--workers 4]

Data (finetune/rft/onpolicy/, read-only):
  first attempts  attempts_*.jsonl - the fine-tuned models' first replies to batch C (and, for v5, to batch A/B
                  and the training families); each id points into the distilled shards, whose verified file is the
                  reference (prompts.jsonl, prompts_c.jsonl, prompts_c_holdout.jsonl hold it as `ref`).
  repair replies  repair_t02_*.jsonl - the same models' replies to the benchmark's feedback on a failed batch-C
                  attempt (reference in repair_prompts_*.jsonl).
bench/results/harness-search/hs_*.jsonl hold only outcomes (render, passed, code hash), not the code, so they cannot
be repaired and are not used.

Every reply's code is extracted as the benchmark does (run_bench.extract_code). The original is rendered with
OpenSCAD (60 s, as batch C was scored) and, when a rule fired, so is the fixed file. A file "renders a watertight
solid" when OpenSCAD exports a mesh and trimesh finds it watertight; it "passes" when it matches its reference
within batch C's tolerances (onpolicy_repairs.ref_ok with rft_score's bounds: bounding box per axis 1 mm or 3%,
volume 8%, body count, triangle floor 30%).
"""
import argparse
import collections
import glob
import json
import os
import shutil
import sys
import tempfile
import time
from concurrent.futures import ProcessPoolExecutor

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, "..", "..", ".."))
sys.dont_write_bytecode = True
os.environ.setdefault("OPENSCAD", "/home/seb/.local/bin/openscad")
sys.path[:0] = [HERE, os.path.join(ROOT, "bench"), os.path.join(ROOT, "tools"), os.path.join(ROOT, "finetune", "scripts")]
import scadfix  # noqa: E402
from run_bench import extract_code  # noqa: E402
from scadreport import analyse, load_mesh, render  # noqa: E402
import onpolicy_repairs  # noqa: E402
import rft_score  # noqa: E402

OP = os.path.join(ROOT, "finetune", "rft", "onpolicy")
TMP = None


def _init(tmp):
    global TMP
    TMP = tmp
    tempfile.tempdir = tmp  # rft_score.measure renders in a TemporaryDirectory


def outcome(job):
    """(code, reference measurement) -> {render, watertight, pass}."""
    code, refm = job
    d = tempfile.mkdtemp(prefix="scadfix_dev_", dir=TMP)
    try:
        sp, stl = os.path.join(d, "a.scad"), os.path.join(d, "a.stl")
        with open(sp, "w", encoding="utf-8", errors="replace") as fh:
            fh.write(code)
        rr = render(sp, stl, timeout=60)
        if not rr["ok"]:
            return {"render": False, "watertight": False, "pass": False}
        try:
            mesh = load_mesh(stl)
            an = analyse(mesh)
        except Exception:  # noqa: BLE001
            return {"render": True, "watertight": False, "pass": False}
        ok = bool(refm and refm.get("ok") and onpolicy_repairs.ref_ok(mesh, an, refm))
        return {"render": True, "watertight": bool(an["watertight"]), "pass": ok}
    finally:
        shutil.rmtree(d, ignore_errors=True)


def measure_ref(code):
    return rft_score.measure(code)


def load():
    """[(set, line, id, sample, reply, reference code)] for the first attempts and the repair replies."""
    prompts = {}
    for f in ("prompts.jsonl", "prompts_c.jsonl", "prompts_c_holdout.jsonl"):
        for line in open(os.path.join(OP, f), encoding="utf-8"):
            p = json.loads(line)
            prompts[p["id"]] = p["ref"]
    rows = []
    for f in sorted(glob.glob(os.path.join(OP, "attempts_*.jsonl"))):
        for n, line in enumerate(open(f, encoding="utf-8")):
            a = json.loads(line)
            rows.append(("first", os.path.basename(f), n, a["id"], a.get("sample"), a.get("reply") or "",
                         prompts[a["id"]]))
    for f in sorted(glob.glob(os.path.join(OP, "repair_t02_*.jsonl"))):
        tag = os.path.basename(f)[len("repair_t02_"):]
        refs = {}
        for line in open(os.path.join(OP, "repair_prompts_" + tag), encoding="utf-8"):
            p = json.loads(line)
            refs[p["id"]] = p["ref"]
        for n, line in enumerate(open(f, encoding="utf-8")):
            a = json.loads(line)
            rows.append(("repair", os.path.basename(f), n, a["id"], a.get("sample"), a.get("reply") or "",
                         refs[a["id"]]))
    return rows


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--tmp", default=tempfile.gettempdir(), help="scratch directory for renders")
    ap.add_argument("--workers", type=int, default=4)
    ap.add_argument("--out", default=os.path.join(HERE, "dev_results.json"))
    ap.add_argument("--rows", default=os.path.join(HERE, "dev_attempts.jsonl"), help="attempts a rule fired on")
    a = ap.parse_args()
    t0 = time.time()
    rows = load()
    recs = []
    for kind, f, n, pid, sample, reply, ref in rows:
        code, how = extract_code(reply)
        fixed, fired = scadfix.fix(code) if code else (None, [])
        recs.append({"kind": kind, "file": f, "line": n, "id": pid, "sample": sample, "extract": how,
                     "code": code, "fixed": fixed if fired else None, "fired": fired, "ref": ref})
    refs_needed = sorted({r["ref"] for r in recs if r["code"]})
    with ProcessPoolExecutor(a.workers, initializer=_init, initargs=(a.tmp,)) as ex:
        refm = dict(zip(refs_needed, ex.map(measure_ref, refs_needed, chunksize=8)))
        jobs = [(r["code"], refm[r["ref"]]) for r in recs if r["code"]]
        before = iter(list(ex.map(outcome, jobs, chunksize=8)))
        jobs2 = [(r["fixed"], refm[r["ref"]]) for r in recs if r["fired"]]
        after = iter(list(ex.map(outcome, jobs2, chunksize=4)))
    none = {"render": False, "watertight": False, "pass": False}
    for r in recs:
        r["ref_ok"] = bool(r["code"] and refm[r["ref"]].get("ok"))
        r["before"] = next(before) if r["code"] else dict(none)
        r["after"] = next(after) if r["fired"] else dict(r["before"])
    with open(a.rows, "w", encoding="utf-8") as fh:  # the attempts a rule fired on (totals: dev_results.json)
        for r in recs:
            if r["fired"]:
                fh.write(json.dumps({k: r[k] for k in ("kind", "file", "line", "id", "sample", "extract", "fired",
                                                       "ref_ok", "before", "after")}) + "\n")
    summary = summarise(recs)
    summary.update({"scadfix_version": scadfix.VERSION, "rule_errors": scadfix.ERRORS,
                    "seconds": round(time.time() - t0)})
    json.dump(summary, open(a.out, "w"), indent=1)
    print_summary(summary)


def tally(rs):
    c = collections.Counter()
    for r in rs:
        c["attempts"] += 1
        c["fired"] += bool(r["fired"])
        for when in ("before", "after"):
            for k in ("render", "watertight", "pass"):
                c[f"{k}_{when}"] += r[when][k]
    return dict(c)


def summarise(recs):
    out = {"by_kind": {}, "by_file": {}, "by_rule": {}}
    for kind in ("first", "repair"):
        rs = [r for r in recs if r["kind"] == kind]
        out["by_kind"][kind] = tally(rs)
        out["by_kind"][kind + "_fired_only"] = tally([r for r in rs if r["fired"]])
        for f in sorted({r["file"] for r in rs}):
            out["by_file"][f] = tally([r for r in rs if r["file"] == f])
        rules = collections.Counter(n for r in rs for n in r["fired"])
        out["by_rule"][kind] = {n: tally([r for r in rs if n in r["fired"]]) for n in rules}
    out["references_that_do_not_measure"] = sum(1 for r in recs if r["code"] and not r["ref_ok"])
    return out


def print_summary(s):
    cols = ("attempts", "fired", "render_before", "render_after", "watertight_before", "watertight_after",
            "pass_before", "pass_after")
    print("set".ljust(34) + "".join(c.replace("_before", " b").replace("_after", " a").rjust(14) for c in cols))
    for name, t in list(s["by_kind"].items()) + list(s["by_file"].items()):
        print(name.ljust(34) + "".join(str(t.get(c, 0)).rjust(14) for c in cols))
    for kind, rules in s["by_rule"].items():
        print(f"-- rules, {kind}")
        for n, t in sorted(rules.items(), key=lambda kv: -kv[1]["fired"]):
            print(("  " + n).ljust(34) + "".join(str(t.get(c, 0)).rjust(14) for c in cols))


if __name__ == "__main__":
    main()
