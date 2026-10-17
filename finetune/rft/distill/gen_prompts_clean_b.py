#!/usr/bin/env python3
"""A second batch of held-out bench-style part families (for v6), same contract and eval gate as
gen_prompts_clean.py: part types that are neither eval tasks nor batch-A families, every prompt at
token Jaccard <= MAX_JACCARD with all 16 eval prompts, each family returning the outer bbox.

    python gen_prompts_clean_b.py --per-family 50 --seed 20261020 --out prompts_clean_b.jsonl
"""
from __future__ import annotations

import argparse
import json
import math
import pathlib
import random
import sys

sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
from gen_prompts_clean import MAX_JACCARD, eval_token_sets, g, max_jaccard  # noqa: E402
from gen_prompts import even_up  # noqa: E402


def tripod_ring(rng):
    OD = rng.choice([60, 70, 80, 90])
    band = rng.choice([8, 10, 12])
    ID = OD - 2 * band
    t = rng.choice([4, 5, 6])
    H = rng.choice([40, 50, 60, 70])
    ld = rng.choice([6, 8])
    rl = (OD + ID) / 4
    txt = (f"Design a support ring that holds a round-bottom flask above the bench. A flat ring (annulus) with an "
           f"outer diameter of {g(OD)} mm and an inner diameter of {g(ID)} mm, {g(t)} mm thick, has its top face at "
           f"z = {g(H)} and is centred on the Z axis. Three round legs, each {g(ld)} mm in diameter, run straight "
           f"down from the ring to the bed at z = 0. Their axes lie on a {g(2 * rl)} mm diameter circle, 120 degrees "
           f"apart, the first on the +X axis.")
    return "tripod_ring", txt, (OD, OD, H)


def counterbored_spacer(rng):
    D = rng.choice([16, 18, 20, 24])
    H = rng.choice([10, 12, 15, 20])
    d = rng.choice([3.4, 4.5, 5.5])
    cd = {3.4: 6.5, 4.5: 8.0, 5.5: 10.0}[d]
    cdep = rng.choice([3, 4, 5])
    txt = (f"Design a spacer for raising a circuit board with a socket-head screw sunk into it. It is a cylinder "
           f"{g(D)} mm in diameter and {g(H)} mm tall standing on the bed (z = 0 to {g(H)}), centred on the origin. "
           f"A {g(d)} mm hole runs through its full height on the axis, and from the top face a coaxial counterbore "
           f"{g(cd)} mm in diameter goes {g(cdep)} mm deep (from z = {g(H - cdep)} to z = {g(H)}).")
    return "counterbored_spacer", txt, (D, D, H)


def dovetail_rail(rng):
    L = rng.choice([60, 80, 100, 120])
    W = rng.choice([30, 36, 40])
    t = rng.choice([4, 5, 6])
    top = rng.choice([14, 16, 18])
    bot = top - rng.choice([4, 6])
    h = rng.choice([5, 6, 8])
    txt = (f"Design a sliding mount with a dovetail rail. A flat base plate {g(L)} mm long (X), {g(W)} mm wide (Y) "
           f"and {g(t)} mm thick lies on the bed (z = 0 to {g(t)}), centred on the origin. Along its full length, "
           f"centred on y = 0, runs a dovetail rail on top of the plate: its cross-section (in the YZ plane) is a "
           f"trapezoid {g(bot)} mm wide where it meets the plate at z = {g(t)} and {g(top)} mm wide at its top face at "
           f"z = {g(t + h)}, so it flares outward as it rises.")
    return "dovetail_rail", txt, (L, W, t + h)


def disc_boss_base(rng):
    D = rng.choice([80, 100, 120])
    t = rng.choice([6, 8, 10])
    bd = rng.choice([20, 24, 30])
    bh = rng.choice([15, 20, 25])
    hd = rng.choice([8.5, 10.5, 12.5])
    txt = (f"Design a weighted base for a lab stand rod. A flat disc {g(D)} mm in diameter and {g(t)} mm thick lies "
           f"on the bed (z = 0 to {g(t)}), centred on the origin. On its top, a coaxial round boss {g(bd)} mm in "
           f"diameter rises from z = {g(t)} to z = {g(t + bh)}. A {g(hd)} mm diameter hole for the rod goes down the "
           f"axis from the top of the boss to {g(2)} mm above the bed, so the bottom stays closed.")
    return "disc_boss_base", txt, (D, D, t + bh)


def wedge_stop(rng):
    L = rng.choice([80, 100, 120])
    W = rng.choice([30, 35, 40])
    H = rng.choice([20, 25, 30])
    sw = rng.choice([6, 8])
    sl = rng.choice([30, 40])
    txt = (f"Design a wedge that keeps a lab door open. It is a right-angled wedge {g(L)} mm long (X), {g(W)} mm wide "
           f"(Y) and {g(H)} mm tall: its cross-section in the XZ plane is a right triangle with corners at "
           f"(x = 0, z = 0), (x = {g(L)}, z = 0) and (x = 0, z = {g(H)}), extruded along Y from y = 0 to y = {g(W)}. A "
           f"straight slot {g(sw)} mm wide (Y) and {g(sl)} mm long (X), centred at x = {g(L / 2)}, y = {g(W / 2)}, "
           f"runs vertically through the whole wedge.")
    return "wedge_stop", txt, (L, W, H)


def washer_set(rng):
    n = rng.choice([3, 4, 5])
    OD = rng.choice([16, 20, 24, 30])
    ID = rng.choice([6.5, 8.5, 10.5])
    while ID > OD - 6:
        ID -= 2
    t = rng.choice([1.5, 2.0, 3.0])
    gap = rng.choice([5, 8, 10])
    X = n * OD + (n - 1) * gap
    txt = (f"Design a set of {n} identical spacer washers that print together. Each washer is a flat ring {g(OD)} mm "
           f"in outer diameter with a {g(ID)} mm hole, {g(t)} mm thick, lying on the bed. Place them in a single row "
           f"along X with a {g(gap)} mm gap between neighbouring washers, all centred on y = 0, and centre the whole "
           f"row on the origin. The washers are separate parts and must not touch.")
    return "washer_set", txt, (X, OD, t)


def v_groove_rest(rng):
    n = rng.choice([3, 4, 5, 6])
    p = rng.choice([15, 18, 20])
    L = (n - 1) * p + rng.choice([20, 24, 30])
    W = rng.choice([30, 40, 50])
    H = rng.choice([12, 15, 18])
    gw = rng.choice([8, 10])
    gd = gw / 2
    txt = (f"Design a rest for glass stirring rods. It is a rectangular block {g(L)} mm long (X), {g(W)} mm wide (Y) "
           f"and {g(H)} mm tall, standing on the bed and centred on the origin in X and Y. Across its top face cut "
           f"{n} V-shaped grooves that each run the full width along Y, {g(p)} mm apart centre to centre and centred "
           f"along X. Each groove has a 90-degree V profile, {g(gw)} mm wide at the top surface and {g(gd)} mm deep.")
    return "v_groove_rest", txt, (L, W, H)


def nut_trap_block(rng):
    Bx, By = rng.choice([20, 24, 30]), rng.choice([20, 24, 30])
    Bz = rng.choice([10, 12, 15])
    d, af, nh = rng.choice([(3.4, 5.6, 2.6), (4.5, 7.2, 3.4), (5.5, 8.2, 4.2)])
    txt = (f"Design a clamping block that holds a hex nut captive. It is a rectangular block {g(Bx)} mm (X) by "
           f"{g(By)} mm (Y) by {g(Bz)} mm (Z), centred on the origin in X and Y and resting on z = 0. A {g(d)} mm hole "
           f"runs vertically through its centre. From the bottom face, a hexagonal pocket {g(af)} mm across the flats "
           f"and {g(nh)} mm deep is cut around the same axis, with two of its flats parallel to the X axis.")
    return "nut_trap_block", txt, (Bx, By, Bz)


def slotted_collet(rng):
    D = rng.choice([16, 20, 24, 30])
    bore = D - 2 * rng.choice([2.0, 2.5, 3.0])
    H = rng.choice([20, 25, 30])
    n = rng.choice([3, 4, 6])
    sw = rng.choice([1.5, 2.0])
    sd = rng.choice([10, 12, 15])
    txt = (f"Design a split collet that grips a tube. It is a round tube {g(D)} mm in outer diameter with a "
           f"{g(bore)} mm bore, standing on the bed from z = 0 to z = {g(H)}, centred on the Z axis. {n} straight slots, "
           f"each {g(sw)} mm wide, are cut through the wall from the top end down to z = {g(H - sd)}; they run along "
           f"the axis and are evenly spaced around it, the first centred on the +X axis.")
    return "slotted_collet", txt, (D, D, H)


def cross_spacer(rng):
    arm = rng.choice([50, 60, 70, 80])
    w = rng.choice([10, 12, 15])
    t = rng.choice([3, 4, 5])
    hd = rng.choice([4.5, 5.5, 6.5])
    txt = (f"Design a cross-shaped stabiliser that sits under a tall bottle. It is a flat plate {g(t)} mm thick lying "
           f"on the bed, shaped like a plus sign centred on the origin: one bar {g(arm)} mm long along X and one bar "
           f"{g(arm)} mm long along Y, both {g(w)} mm wide, crossing at their middles. A {g(hd)} mm hole goes through "
           f"the centre, and another {g(hd)} mm hole goes through each of the four arm ends, centred "
           f"{g(arm / 2 - w / 2)} mm from the origin.")
    return "cross_spacer", txt, (arm, arm, t)


def keyhole_hanger(rng):
    L = rng.choice([50, 60, 70])
    W = rng.choice([25, 30, 35])
    t = rng.choice([3, 4, 5])
    big = rng.choice([8, 9, 10])
    small = rng.choice([4, 4.5, 5])
    sl = rng.choice([10, 12, 15])
    txt = (f"Design a wall plate that hangs on a screw head through a keyhole slot. It is a flat plate {g(L)} mm long "
           f"(X), {g(W)} mm wide (Y) and {g(t)} mm thick, lying on the bed with its centre at the origin. The keyhole "
           f"is cut through the plate: a round hole {g(big)} mm in diameter centred at x = 0, y = 0, joined to a "
           f"straight slot {g(small)} mm wide that runs from that centre in the +X direction to a rounded end whose "
           f"centre is at x = {g(sl)}, y = 0.")
    return "keyhole_hanger", txt, (L, W, t)


def stair_block(rng):
    n = rng.choice([3, 4, 5])
    run = rng.choice([10, 12, 15])
    rise = rng.choice([6, 8, 10])
    W = rng.choice([20, 30, 40])
    L, H = n * run, n * rise
    txt = (f"Design a stepped riser for setting samples at different heights. It is a solid staircase of {n} equal "
           f"steps, standing on the bed. Seen from the side (the XZ plane) the profile climbs in the +X direction: "
           f"each step is {g(run)} mm long in X and {g(rise)} mm higher than the one before, from a first step of "
           f"height {g(rise)} at x = 0 to x = {g(run)}, up to a top step of height {g(H)} ending at x = {g(L)}. The "
           f"profile is extruded {g(W)} mm along Y, from y = 0 to y = {g(W)}, and every step is solid down to the bed.")
    return "stair_block", txt, (L, W, H)


def chamfered_base(rng):
    X, Y = rng.choice([60, 80, 100]), rng.choice([40, 50, 60])
    H = rng.choice([10, 12, 15])
    c = rng.choice([2, 3, 4])
    txt = (f"Design a small display base with bevelled top edges. It is a rectangular block {g(X)} mm (X) by {g(Y)} mm "
           f"(Y) by {g(H)} mm (Z), centred on the origin in X and Y and standing on z = 0. All four top edges carry a "
           f"45-degree chamfer {g(c)} mm wide, so the top face measures {g(X - 2 * c)} by {g(Y - 2 * c)} mm and the "
           f"vertical sides stop at z = {g(H - c)}. The bottom edges stay sharp.")
    return "chamfered_base", txt, (X, Y, H)


def rounded_tag(rng):
    L = rng.choice([50, 60, 70, 80])
    W = rng.choice([20, 25, 30])
    t = rng.choice([2, 3])
    r = rng.choice([3, 4, 5])
    hd = rng.choice([4, 5, 6])
    hx = L / 2 - rng.choice([6, 7, 8])
    txt = (f"Design a label tag for a gas cylinder. It is a flat plate {g(L)} mm long (X), {g(W)} mm wide (Y) and "
           f"{g(t)} mm thick, lying on the bed with its centre at the origin, and all four corners (seen from above) "
           f"are rounded with a {g(r)} mm radius. A {g(hd)} mm hole for a cable tie goes through the plate at "
           f"x = -{g(hx)}, y = 0.")
    return "rounded_tag", txt, (L, W, t)


FAMILIES_B = [tripod_ring, counterbored_spacer, dovetail_rail, disc_boss_base, wedge_stop, washer_set,
              v_groove_rest, nut_trap_block, slotted_collet, cross_spacer, keyhole_hanger, stair_block,
              chamfered_base, rounded_tag]


def main() -> None:
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--per-family", type=int, default=50)
    ap.add_argument("--seed", type=int, default=20261020)
    ap.add_argument("--max-jaccard", type=float, default=MAX_JACCARD)
    ap.add_argument("--out", default=None)
    a = ap.parse_args()
    rng = random.Random(a.seed)
    evs = eval_token_sets()
    out, seen = [], set()
    for fam in FAMILIES_B:
        kept = tries = rej = 0
        while kept < a.per_family and tries < 5000:
            tries += 1
            name, user, bbox = fam(rng)
            if user in seen:
                continue
            j, near = max_jaccard(user, evs)
            if j > a.max_jaccard:
                rej += 1
                continue
            seen.add(user)
            out.append({"id": f"{name}_{kept:03d}", "family": name, "user": user,
                        "bbox": [round(float(v), 2) for v in bbox], "max_jaccard": round(j, 3), "nearest_eval": near})
            kept += 1
        js = [p["max_jaccard"] for p in out if p["family"] == fam.__name__]
        print(f"{fam.__name__:20s} kept {kept:3d}  rejected {rej:3d}  max J {max(js) if js else 0:.2f}")
    print(f"total {len(out)}  overall max Jaccard {max(p['max_jaccard'] for p in out):.3f}")
    if a.out:
        with open(a.out, "w", encoding="utf-8") as fh:
            fh.write("\n".join(json.dumps(p, ensure_ascii=False) for p in out) + "\n")
        print("wrote", a.out)


if __name__ == "__main__":
    main()
