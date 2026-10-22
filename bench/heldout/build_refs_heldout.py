#!/usr/bin/env python3
"""Render the held-out reference designs, record reference statistics, and validate the checker.
A copy of bench/build_refs.py pointed at bench/heldout/, with a wider cross-task test.

    python bench/heldout/build_refs_heldout.py            # validate against reference_stats.json
    python bench/heldout/build_refs_heldout.py --write    # regenerate bench/heldout/reference_stats.json

1. renders every held-out reference solution and compares it with bench/heldout/reference_stats.json
   (`--write` regenerates that file instead; only do this when adding or changing a task)
2. every reference must pass all of its own checks
3. invariance: a reference that is rotated 90 deg / mirrored / moved must still pass
4. discrimination: references scaled by 3 % must fail
5. cross-task false positives: every held-out reference must fail every *other* held-out task and every
   one of the 16 original tasks (bench/tasks.yaml), and every original reference (bench/reference/)
   must fail every held-out task
6. known-wrong parts in bench/heldout/mutants/ must fail their task
7. known-right parts in bench/heldout/variants/ (an allowed difference from the reference) must pass their task

The checker is the unmodified bench/checks.py. Meshes are rendered into a temporary directory that is
deleted afterwards, so nothing outside bench/heldout/ is written. Run it under `nice` on a busy machine:
renders are sequential.
"""
import glob
import json
import os
import shutil
import sys
import tempfile
import time

import numpy as np
import trimesh
import yaml

HERE = os.path.dirname(os.path.abspath(__file__))   # bench/heldout
BENCH = os.path.dirname(HERE)                        # bench
ROOT = os.path.dirname(BENCH)                        # repository root
sys.path.insert(0, BENCH)
sys.path.insert(0, os.path.join(ROOT, "tools"))
from checks import evaluate, reference_stats  # noqa: E402
from scadreport import load_mesh, openscad_missing, render  # noqa: E402


def need(ok, message):
    """Like assert, but still checked under `python -O`."""
    if not ok:
        sys.exit(f"build_refs_heldout: {message}")


def render_refs(tasks, out_dir, tag):
    """Render each task's reference; returns {id: mesh}, {id: seconds}."""
    meshes, secs = {}, {}
    for t in tasks:
        stl = os.path.join(out_dir, f"{tag}_{t['id']}.stl")
        r = render(os.path.join(ROOT, t["reference"]), stl)
        need(r["ok"], f"{t['id']}: the reference did not render: {r['messages']}")
        m = load_mesh(stl)
        need(abs(m.bounds[0][2]) < 1e-6, f"{t['id']}: reference must start at z = 0")
        meshes[t["id"]], secs[t["id"]] = m, r["seconds"]
    return meshes, secs


def main():
    if openscad_missing():
        sys.exit(openscad_missing())
    tasks = yaml.safe_load(open(os.path.join(HERE, "tasks.yaml")))
    orig_tasks = yaml.safe_load(open(os.path.join(BENCH, "tasks.yaml")))
    orig_stats = json.load(open(os.path.join(BENCH, "reference_stats.json")))
    ids = [t["id"] for t in tasks]
    need(len(ids) == len(set(ids)), "duplicate task ids")
    clash = sorted(set(ids) & {t["id"] for t in orig_tasks})
    need(not clash, f"held-out ids collide with original task ids: {clash}")
    out_dir = tempfile.mkdtemp(prefix="heldout_refs_")
    try:
        return run(tasks, orig_tasks, orig_stats, out_dir)
    finally:
        shutil.rmtree(out_dir, ignore_errors=True)


def run(tasks, orig_tasks, orig_stats, out_dir):
    meshes, secs = render_refs(tasks, out_dir, "ho")
    stats = {t["id"]: reference_stats(meshes[t["id"]], t) for t in tasks}
    path = os.path.join(HERE, "reference_stats.json")
    if "--write" in sys.argv:  # only when adding or changing a task: every score depends on this file
        json.dump(stats, open(path, "w"), indent=1)
    else:  # validate against the frozen statistics, and say so if this OpenSCAD build disagrees
        frozen = json.load(open(path))
        for tid, st in stats.items():
            fz = frozen.get(tid)
            need(fz is not None, f"{tid}: not in reference_stats.json (run with --write)")
            pairs = [(st["volume"], fz["volume"])] + [(v, fz["material_area"].get(z)) for z, v in st["material_area"].items()]
            for new, old in pairs:
                need(old is not None and abs(new - old) <= 1e-3 * abs(old),
                     f"{tid}: reference statistics differ from reference_stats.json ({new:.1f} vs {old}); check your OpenSCAD version")
        stats = frozen
    orig_meshes, _ = render_refs(orig_tasks, out_dir, "orig")

    tally = {k: [0, 0] for k in ("own", "invariance", "scaled", "cross_heldout", "cross_vs_original",
                                 "original_vs_heldout", "mutants", "variants")}  # [passed, failed]

    def count(step, ok):
        tally[step][0 if ok else 1] += 1
        return ok

    fails = 0
    print(f"{'task':28s} {'render':>7s} {'own':>7s} {'rot+mir':>8s} {'scaled':>8s}  cross-task false positives")
    for t in tasks:
        tid, m, ref = t["id"], meshes[t["id"]], stats[t["id"]]
        t0 = time.time()
        own = evaluate(m, t, ref)
        moved = m.copy()
        moved.apply_transform(trimesh.transformations.rotation_matrix(np.pi / 2, [0, 0, 1]))
        moved.apply_transform(np.diag([-1, 1, 1, 1]))  # mirror X
        moved.apply_translation([13.0, -7.0, 2.5])
        inv = evaluate(moved, t, ref)
        sc = m.copy()
        sc.apply_scale(1.03)
        scaled = evaluate(sc, t, ref)
        fp = [o["id"] for o in tasks if o["id"] != tid and evaluate(m, o, stats[o["id"]])["passed"]]
        fpo = [o["id"] for o in orig_tasks if evaluate(m, o, orig_stats[o["id"]])["passed"]]
        ok = all([count("own", own["passed"]), count("invariance", inv["passed"]), count("scaled", not scaled["passed"])])
        for o in tasks:
            if o["id"] != tid:
                ok &= count("cross_heldout", o["id"] not in fp)
        for o in orig_tasks:
            ok &= count("cross_vs_original", o["id"] not in fpo)
        fails += not ok
        print(f"{tid:28s} {secs[tid]:6.2f}s {own['n_ok']:>3d}/{own['n']:<3d} {inv['n_ok']:>4d}/{inv['n']:<3d} "
              f"{scaled['n_ok']:>4d}/{scaled['n']:<3d}  {(fp + fpo) or '-'}  ({time.time() - t0:.1f}s)")
        for res, label in ((own, "own"), (inv, "rot+mir")):
            for i in res["items"]:
                if not i["ok"]:
                    print(f"    {label} FAIL {i['check']}: {i['msg']}")
    # every original reference must fail every held-out task
    for o in orig_tasks:
        fp = [t["id"] for t in tasks if evaluate(orig_meshes[o["id"]], t, stats[t["id"]])["passed"]]
        for t in tasks:
            fails += not count("original_vs_heldout", t["id"] not in fp)
        if fp:
            print(f"original {o['id']:28s} passes held-out task(s) {fp}")
    # known-wrong parts (mutants/<task>__<what is wrong>.scad) must fail their task; variants must pass
    by_id = {t["id"]: t for t in tasks}
    for kind, folder, should_pass in (("mutant", "mutants", False), ("variant", "variants", True)):
        for p in sorted(glob.glob(os.path.join(HERE, folder, "*.scad"))):
            tid = os.path.basename(p).split("__")[0]
            need(tid in by_id, f"{p}: name must start with a task id and '__'")
            stl = os.path.join(out_dir, f"{kind}.stl")
            need(render(p, stl)["ok"], f"{p} did not render")
            res = evaluate(load_mesh(stl), by_id[tid], stats[tid])
            good = bool(res["passed"]) == should_pass
            fails += not count(folder, good)
            verdict = ("passes, as it should" if should_pass else "PASSED - checks too weak") if res["passed"] else \
                ("FAILED - checks too strict: " + "; ".join(i["check"] for i in res["items"] if not i["ok"])[:120]
                 if should_pass else "fails, as it should")
            print(f"{kind:7s} {os.path.basename(p):60s} {verdict}")
    print("\nsummary (step: passed / failed)")
    for k, (a, b) in tally.items():
        print(f"  {k:22s} {a:5d} / {b}")
    print("ALL OK" if not fails else f"{fails} validation problem(s)")
    return 1 if fails else 0


if __name__ == "__main__":
    sys.exit(main())
