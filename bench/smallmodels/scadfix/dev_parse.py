#!/usr/bin/env python3
"""Parse errors before and after scadfix on the development attempts (the same data as dev_eval.py).

    nice -n 10 python -I -B dev_parse.py --tmp /some/scratch/dir [--workers 4]

Each file is evaluated with OpenSCAD's CSG export (it parses and evaluates the file but builds no geometry); a
"parse error" is OpenSCAD's "Parser error" message. Writes dev_parse.json.
"""
import argparse
import collections
import json
import os
import shutil
import subprocess
import sys
import tempfile
from concurrent.futures import ProcessPoolExecutor

HERE = os.path.dirname(os.path.abspath(__file__))
sys.dont_write_bytecode = True
sys.path.insert(0, HERE)
import dev_eval  # noqa: E402  (its loader and extraction)
import scadfix  # noqa: E402

OPENSCAD = os.environ.get("OPENSCAD", "/home/seb/.local/bin/openscad")
TMP = None


def _init(tmp):
    global TMP
    TMP = tmp


def parse_error(code):
    d = tempfile.mkdtemp(prefix="scadfix_parse_", dir=TMP)
    try:
        with open(os.path.join(d, "f.scad"), "w", encoding="utf-8", errors="replace") as fh:
            fh.write(code)
        p = subprocess.run([OPENSCAD, "-o", os.path.join(d, "f.csg"), "f.scad"], cwd=d, capture_output=True,
                           text=True, errors="replace", timeout=60)
        return "Parser error" in p.stdout + p.stderr
    except subprocess.TimeoutExpired:
        return False
    finally:
        shutil.rmtree(d, ignore_errors=True)


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--tmp", default=tempfile.gettempdir())
    ap.add_argument("--workers", type=int, default=4)
    ap.add_argument("--out", default=os.path.join(HERE, "dev_parse.json"))
    a = ap.parse_args()
    recs = []
    for kind, f, n, pid, sample, reply, ref in dev_eval.load():
        code, _ = dev_eval.extract_code(reply)
        if code:
            fixed, fired = scadfix.fix(code)
            recs.append({"kind": kind, "file": f, "code": code, "fixed": fixed, "fired": fired})
    with ProcessPoolExecutor(a.workers, initializer=_init, initargs=(a.tmp,)) as ex:
        before = list(ex.map(parse_error, [r["code"] for r in recs], chunksize=16))
        changed = [r for r in recs if r["fired"]]
        after = dict(zip(map(id, changed), ex.map(parse_error, [r["fixed"] for r in changed], chunksize=4)))
    out = {"scadfix_version": scadfix.VERSION, "by_kind": {}, "by_rule": {}}
    for kind in ("first", "repair"):
        rs = [(r, b) for r, b in zip(recs, before) if r["kind"] == kind]
        aft = [after[id(r)] if r["fired"] else b for r, b in rs]
        out["by_kind"][kind] = {"files": len(rs), "parse_errors_before": sum(b for _, b in rs),
                                "fired": sum(bool(r["fired"]) for r, _ in rs),
                                "fired_on_files_that_parsed": sum(bool(r["fired"]) and not b for r, b in rs),
                                "parse_errors_after": sum(aft)}
        by = collections.defaultdict(lambda: [0, 0])
        for r, b in rs:
            for name in r["fired"]:
                by[name][0] += 1
                by[name][1] += b and not after[id(r)]
        out["by_rule"][kind] = {k: {"fired": v[0], "parse_error_cleared": v[1]}
                                for k, v in sorted(by.items(), key=lambda kv: -kv[1][0])}
    json.dump(out, open(a.out, "w"), indent=1)
    print(json.dumps(out["by_kind"], indent=1))


if __name__ == "__main__":
    main()
