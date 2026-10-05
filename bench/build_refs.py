#!/usr/bin/env python3
"""Render the reference designs, record reference statistics, and validate the checker.

    python bench/build_refs.py

1. renders every reference solution and stores reference_stats.json
2. every reference must pass all of its own checks
3. invariance: a reference that is rotated 90 deg / mirrored / moved must still pass
4. discrimination: references scaled by 3 % must fail; every reference must fail
   every *other* task's checks (cross-task false positives)
"""
import json
import os
import sys
import time

import numpy as np
import trimesh
import yaml

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.dirname(HERE)
sys.path.insert(0, HERE)
sys.path.insert(0, os.path.join(ROOT, "tools"))
from checks import evaluate, reference_stats  # noqa: E402
from scadreport import load_mesh, render  # noqa: E402


def main():
    tasks = yaml.safe_load(open(os.path.join(HERE, "tasks.yaml")))
    out_dir = os.path.join(ROOT, "build", "ref")
    os.makedirs(out_dir, exist_ok=True)
    stats, meshes = {}, {}
    for t in tasks:
        stl = os.path.join(out_dir, t["id"] + ".stl")
        r = render(os.path.join(ROOT, t["reference"]), stl)
        assert r["ok"], (t["id"], r["messages"])
        m = load_mesh(stl)
        assert abs(m.bounds[0][2]) < 1e-6, f"{t['id']}: reference must start at z = 0"
        stats[t["id"]] = reference_stats(m, t)
        meshes[t["id"]] = m
    json.dump(stats, open(os.path.join(HERE, "reference_stats.json"), "w"), indent=1)

    fails = 0
    print(f"{'task':28s} {'own':>7s} {'rot+mir':>8s} {'scaled':>8s}  cross-task false positives")
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
        ok = own["passed"] and inv["passed"] and not scaled["passed"] and not fp
        fails += not ok
        print(f"{tid:28s} {own['n_ok']:>3d}/{own['n']:<3d} {inv['n_ok']:>4d}/{inv['n']:<3d} "
              f"{scaled['n_ok']:>4d}/{scaled['n']:<3d}  {fp or '-'}  ({time.time() - t0:.1f}s)")
        for res, label in ((own, "own"), (inv, "rot+mir")):
            for i in res["items"]:
                if not i["ok"]:
                    print(f"    {label} FAIL {i['check']}: {i['msg']}")
    print("ALL OK" if not fails else f"{fails} task(s) with validation problems")
    sys.exit(1 if fails else 0)


if __name__ == "__main__":
    main()
