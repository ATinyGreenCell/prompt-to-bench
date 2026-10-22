#!/usr/bin/env python3
"""No-op check: scadfix must leave valid OpenSCAD alone. Runs fix() over every verified file in the repository and
reports how many there are and on how many any rule fired (the requirement is none).

    python -I -B noop_check.py [--out noop_check.json]

Valid files: bench/reference/*.scad, bench/variants/*.scad, designs/**/*.scad, finetune/seeds/*.scad and the
verified assistant code of the distilled batches A, B and C (finetune/rft/distill/clean_shard*.jsonl,
clean_b_shard*.jsonl, clean_c_shard*.jsonl; the code taken from the reply as the benchmark extracts it).
"""
import glob
import json
import os
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, "..", "..", ".."))
sys.dont_write_bytecode = True
sys.path[:0] = [HERE, os.path.join(ROOT, "bench"), os.path.join(ROOT, "tools")]
import scadfix  # noqa: E402
from run_bench import extract_code  # noqa: E402


def corpora():
    files = {
        "bench/reference": sorted(glob.glob(os.path.join(ROOT, "bench/reference/*.scad"))),
        "bench/variants": sorted(glob.glob(os.path.join(ROOT, "bench/variants/*.scad"))),
        "designs": sorted(glob.glob(os.path.join(ROOT, "designs/**/*.scad"), recursive=True)),
        "finetune/seeds": sorted(glob.glob(os.path.join(ROOT, "finetune/seeds/*.scad"))),
    }
    for name, path in files.items():
        for f in path:
            yield name, os.path.relpath(f, ROOT), open(f, encoding="utf-8").read()
    for batch, pat in (("distill batch A", "clean_shard*.jsonl"), ("distill batch B", "clean_b_shard*.jsonl"),
                       ("distill batch C", "clean_c_shard*.jsonl")):
        for f in sorted(glob.glob(os.path.join(ROOT, "finetune/rft/distill", pat))):
            for n, line in enumerate(open(f, encoding="utf-8")):
                msgs = json.loads(line)["messages"]
                code, _ = extract_code(msgs[-1]["content"])
                if code:
                    yield batch, f"{os.path.relpath(f, ROOT)}:{n}", code


def main():
    out = sys.argv[sys.argv.index("--out") + 1] if "--out" in sys.argv else None
    counts, fired = {}, []
    for group, ident, code in corpora():
        new, rules = scadfix.fix(code)
        c = counts.setdefault(group, [0, 0])
        c[0] += 1
        if rules or new != code:
            c[1] += 1
            fired.append({"file": ident, "rules": rules})
    total = sum(c[0] for c in counts.values())
    nfired = sum(c[1] for c in counts.values())
    for g, (n, k) in counts.items():
        print(f"{g:18s} {n:5d} files, a rule fired on {k}")
    print(f"{'all':18s} {total:5d} files, a rule fired on {nfired}; rule errors {len(scadfix.ERRORS)}")
    for f in fired[:40]:
        print("   ", f["file"], f["rules"])
    if out:
        json.dump({"scadfix_version": scadfix.VERSION, "files": total, "fired": nfired, "by_group": counts,
                   "fired_on": fired, "rule_errors": scadfix.ERRORS}, open(out, "w"), indent=1)
    return 1 if nfired else 0


if __name__ == "__main__":
    sys.exit(main())
