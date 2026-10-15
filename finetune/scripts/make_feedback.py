#!/usr/bin/env python3
"""Error-feedback / repair examples - the paper's key lever - with feedback wording taken VERBATIM
from the benchmark, so the training signal matches what the model is shown on a failed attempt.

For each verified design, introduce a realistic flaw, render the flawed version exactly as the eval
does (tools/scadreport.render), and build the feedback string with bench/run_bench.feedback_message
itself - importing it, not copying it, so the two can never drift. The example is single-turn with
the flawed code in the USER turn, so the only target the model is trained to produce is the CORRECT
file: we never teach it to emit the flaw, only to read the feedback and fix it.

usage: ~/printpaper/.venv/bin/python -I make_feedback.py --limit 3000 -o ../data/feedback.jsonl
"""
from __future__ import annotations

import argparse
import json
import os
import pathlib
import random
import re
import sys
import tempfile

ROOT = pathlib.Path("/home/seb/printpaper")
FT = ROOT / "finetune"
sys.path[:0] = [str(ROOT / "tools"), str(ROOT / "bench")]
from scadreport import analyse, format_report, load_mesh, openscad_missing, render  # noqa: E402
from run_bench import feedback_message  # the eval's own feedback wording - single source of truth  # noqa: E402

SYSTEM = (ROOT / "bench" / "prompts" / "system.md").read_text().strip()
TAIL = re.compile(r"\s*Reply with .*?(?:OpenSCAD file|code block)\.?\s*$", re.I | re.S)


def low_fn(scad, params):
    out, n = re.subn(r"\$fn\s*=\s*\d+", "$fn = 6", scad)            # faceted curves: holes come out wrong
    return (out, "low_fn") if n else (None, None)


def wrong_dim(scad, params):
    for k in params:                                               # one dimension 30% too big
        m = re.search(rf"(?m)^({re.escape(k)}\s*=\s*)(-?\d+(?:\.\d+)?)(\s*;)", scad)
        if m:
            return scad[:m.start(2)] + str(round(float(m.group(2)) * 1.3, 1)) + scad[m.end(2):], "wrong_dim"
    return None, None


def drop_semicolon(scad, params):
    idx = [m.start() for m in re.finditer(";", scad)]              # a missing semicolon: parse error
    if len(idx) < 4:
        return None, None
    i = random.choice(idx[1:-1])
    return scad[:i] + scad[i + 1:], "drop_semicolon"


PERTS = [low_fn, wrong_dim, drop_semicolon]


def feedback_for(flawed, timeout=60):
    """Render the flawed file (as the eval does) and return the benchmark's own feedback string."""
    with tempfile.TemporaryDirectory() as d:
        sp, stl = os.path.join(d, "p.scad"), os.path.join(d, "p.stl")
        open(sp, "w").write(flawed)
        rr = render(sp, stl, timeout=timeout)
        if not rr["ok"]:
            return feedback_message("report", rr, None, "fenced")        # render failure
        try:
            report_text = format_report(rr, analyse(load_mesh(stl)))
            return feedback_message("report", rr, report_text, "fenced")  # rendered: measurement report
        except Exception:
            return feedback_message("generic", rr, None, "fenced")        # rendered, but could not measure


def seed_records():
    for f in sorted((FT / "data").glob("*.jsonl")):
        if f.name in ("train.jsonl", "val.jsonl", "feedback.jsonl"):
            continue
        for ln in f.open():
            ln = ln.strip()
            if ln:
                r = json.loads(ln)
                if "scad" in r and "prompt" in r:
                    yield r


def main() -> None:
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--limit", type=int, default=3000)
    ap.add_argument("--rng", type=int, default=0)
    ap.add_argument("-o", default=str(FT / "data" / "feedback.jsonl"))
    a = ap.parse_args()
    miss = openscad_missing()
    if miss:
        sys.exit(miss)
    random.seed(a.rng)

    recs = list(seed_records())
    random.shuffle(recs)
    out, kinds = [], {}
    for rec in recs:
        if len(out) >= a.limit:
            break
        flawed, kind = random.choice(PERTS)(rec["scad"], rec.get("params", {}))
        if not flawed or flawed.strip() == rec["scad"].strip():
            continue
        task = TAIL.sub("", rec["prompt"]).strip()
        user = (f"{task}\n\nThis is the OpenSCAD file I wrote:\n```openscad\n{flawed.strip()}\n```\n\n"
                + feedback_for(flawed))
        out.append({"messages": [
            {"role": "system", "content": SYSTEM},
            {"role": "user", "content": user},
            {"role": "assistant", "content": "```openscad\n" + rec["scad"].strip() + "\n```"}]})
        kinds[kind] = kinds.get(kind, 0) + 1

    with pathlib.Path(a.o).open("w") as fh:
        for r in out:
            fh.write(json.dumps(r) + "\n")
    print(f"wrote {len(out)} repair examples -> {a.o}  (by flaw: {kinds})")


if __name__ == "__main__":
    main()
