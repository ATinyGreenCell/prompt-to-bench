#!/usr/bin/env python3
"""A third batch of held-out bench-style part families (for a second on-policy round), same contract and eval
gate as gen_prompts_clean.py: part types that are neither eval tasks nor batch-A/B families, every prompt at
token Jaccard <= MAX_JACCARD with all 16 eval prompts, each family returning the outer bbox.

Also kept out by kind, not just by wording (v3's lesson): no disc or plate with a hole grid (the seed
template), no notched edge (the gel comb), no collar-sleeve-bore stack (the PCR-tube adapter), no open-top
walled container (the gel tank, the enclosure), no block with slots in its top (the slide rack).

    python gen_prompts_clean_c.py --per-family 50 --seed 20261021 --out prompts_clean_c.jsonl
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


def t_slot_nut(rng):
    L = rng.choice([10, 12, 15, 20])
    Wt = rng.choice([10, 12, 14])
    tt = rng.choice([2, 2.5, 3])
    Wn = rng.choice([6, 7, 8])
    hn = rng.choice([3, 4])
    d = rng.choice([x for x in (3.4, 4.5, 5.5) if x <= Wn - 2.5])
    txt = (f"Design a T-shaped nut that slides in the slot of an aluminium extrusion. Seen along its length (the X "
           f"axis) its cross-section is an upside-down T: a bottom flange {g(Wt)} mm wide (Y) and {g(tt)} mm thick, "
           f"from z = 0 to z = {g(tt)}, and above it a centred neck {g(Wn)} mm wide rising to z = {g(tt + hn)}. The "
           f"profile is {g(L)} mm long along X, centred on the origin in X and Y. A {g(d)} mm hole for a screw runs "
           f"vertically through the centre of the part.")
    return "t_slot_nut", txt, (L, Wt, tt + hn)


def dial_ring(rng):
    OD = rng.choice([50, 60, 70, 80])
    band = rng.choice([8, 10, 12])
    ID = OD - 2 * band
    t = rng.choice([3, 4, 5])
    n = rng.choice([12, 24, 36])
    tw = rng.choice([1.0, 1.2, 1.5])
    tl = rng.choice([3, 4])
    td = rng.choice([1.0, 1.5])
    txt = (f"Design a flat dial ring with tick marks for a rotary stage. It is an annulus {g(OD)} mm in outer "
           f"diameter and {g(ID)} mm in inner diameter, {g(t)} mm thick, lying on the bed and centred on the origin. "
           f"Into its top face cut {n} evenly spaced radial tick marks, the first on the +X axis: each is a straight "
           f"groove {g(tw)} mm wide and {g(td)} mm deep that runs {g(tl)} mm inward from the outer edge.")
    return "dial_ring", txt, (OD, OD, t)


def vibration_foot(rng):
    Db = rng.choice([30, 40, 50])
    Dt = Db - rng.choice([8, 10, 14])
    H = rng.choice([12, 15, 20])
    Dr = Db - rng.choice([6, 8])
    rd = rng.choice([2, 3])
    dh = rng.choice([4.5, 5.5])
    txt = (f"Design an anti-vibration foot for a benchtop instrument. It is a frustum (a truncated cone) standing "
           f"on the bed and centred on the Z axis, {g(Db)} mm in diameter at the bottom (z = 0) and narrowing to "
           f"{g(Dt)} mm at its flat top at z = {g(H)}. A round recess {g(Dr)} mm in diameter and {g(rd)} mm deep is "
           f"cut into the bottom face for a rubber pad, and a {g(dh)} mm hole for a screw runs through the centre "
           f"along the axis.")
    return "vibration_foot", txt, (Db, Db, H)


def ribbed_panel(rng):
    L, n = rng.choice([(80, 3), (80, 4), (100, 3), (100, 4), (120, 3), (120, 4), (120, 5)])
    W = rng.choice([50, 60, 80])
    t = rng.choice([2, 3])
    rw = rng.choice([2, 3])
    rh = rng.choice([4, 5, 6])
    p = L / (n + 1)
    txt = (f"Design a stiffened cover panel. A flat plate {g(L)} mm long (X), {g(W)} mm wide (Y) and {g(t)} mm thick "
           f"lies on the bed (z = 0 to {g(t)}), centred on the origin. On top of it stand {n} straight ribs, each "
           f"{g(rw)} mm thick (X) and {g(rh)} mm tall (z = {g(t)} to {g(t + rh)}), running the full width along Y. "
           f"The ribs divide the length into {n + 1} equal parts: their centres are {g(p)} mm apart, and the outer "
           f"ones are {g(p)} mm from the ends of the plate.")
    return "ribbed_panel", txt, (L, W, t + rh)


def lab_scoop(rng):
    R = rng.choice([10, 12, 15])
    w = rng.choice([1.5, 2.0])
    Lh = rng.choice([60, 80, 100])
    wh = rng.choice([8, 10, 12])
    th = rng.choice([3, 4])
    txt = (f"Design a measuring scoop for powders. Its bowl is half of a hollow sphere: outer radius {g(R)} mm and "
           f"wall {g(w)} mm thick, centred at (0, 0, {g(R)}), with only the lower half kept, so the bowl opens upward "
           f"with its rim at z = {g(R)} and its bottom touching the bed at z = 0. A straight flat handle {g(wh)} mm "
           f"wide (Y) and {g(th)} mm thick, with its top face flush with the rim (z = {g(R - th)} to {g(R)}), runs "
           f"along +X from x = {g(R - w)} to x = {g(R + Lh)}, centred on y = 0.")
    return "lab_scoop", txt, (2 * R + Lh, 2 * R, R)


def cable_bridge(rng):
    L = rng.choice([60, 80, 100])
    W = rng.choice([30, 40, 50])
    H = rng.choice([12, 15, 20])
    r = rng.choice([4, 5, 6])
    n = rng.choice([1, 2, 3])
    sp = rng.choice([16, 20])
    if n == 1:
        tun = (f"One semicircular tunnel runs straight through it along Y at floor level: half of a {g(2 * r)} mm "
               f"diameter cylinder whose axis lies along Y at x = 0, z = 0.")
    else:
        tun = (f"{n} semicircular tunnels run straight through it along Y at floor level: each is half of a "
               f"{g(2 * r)} mm diameter cylinder whose axis lies along Y at z = 0, and their axes are {g(sp)} mm "
               f"apart, centred along X.")
    txt = (f"Design a cable bridge that lets cables cross under a bench mat. It is a rectangular block {g(L)} mm long "
           f"(X), {g(W)} mm wide (Y) and {g(H)} mm tall, standing on the bed and centred on the origin in X and Y. "
           + tun)
    return "cable_bridge", txt, (L, W, H)


def torus_weight(rng):
    R = rng.choice([20, 22, 25, 28, 30, 35])
    r = rng.choice([4, 5, 6, 8])
    txt = (f"Design a ring weight that sits around the neck of a flask in a water bath. It is a torus lying flat "
           f"on the bed: its round cross-section, a circle {g(2 * r)} mm in diameter, sweeps around the Z axis with "
           f"its centre on a circle of radius {g(R)} mm, so the ring is {g(2 * (R + r))} mm across, rests on z = 0 "
           f"and has its middle plane at z = {g(r)}.")
    return "torus_weight", txt, (2 * (R + r), 2 * (R + r), 2 * r)


def hinge_leaf(rng):
    L, n = rng.choice([(45, 2), (60, 2), (40, 3), (50, 3), (60, 3)])
    W = rng.choice([20, 25, 30])
    t = rng.choice([2.5, 3.0])
    kd = rng.choice([6, 7, 8])
    pd = rng.choice([2.0, 2.5, 3.0])
    seg = L / (2 * n - 1)
    which = "1st and 3rd" if n == 2 else "1st, 3rd and 5th"
    txt = (f"Design one leaf of a pin hinge. A flat plate {g(L)} mm long (X), {g(W)} mm wide (Y) and {g(t)} mm thick "
           f"lies on the bed, centred on the origin. Along its +Y edge, divide the length into {2 * n - 1} equal "
           f"segments of {g(seg)} mm; on the {which} segments sit round knuckles, cylinders {g(kd)} mm in diameter "
           f"whose common axis runs along X at y = {g(W / 2)}, z = {g(kd / 2)}. A {g(pd)} mm hole for the pin runs "
           f"along that axis through every knuckle.")
    return "hinge_leaf", txt, (L, W + kd / 2, kd)


def cam_disc(rng):
    D = rng.choice([30, 40, 50])
    t = rng.choice([5, 6, 8])
    e = rng.choice([4, 5, 6])
    d = rng.choice([5, 6, 8])
    hd = d + rng.choice([6, 8])
    hh = rng.choice([4, 5, 6])
    txt = (f"Design an eccentric cam for a shaker mechanism. It is a round disc {g(D)} mm in diameter and {g(t)} mm "
           f"thick lying on the bed, with its centre at x = {g(e)}, y = 0, so it sits {g(e)} mm off the shaft. The "
           f"shaft axis is the Z axis: a round hub {g(hd)} mm in diameter rises {g(hh)} mm above the disc around it "
           f"(z = {g(t)} to {g(t + hh)}), and a {g(d)} mm hole for the shaft runs through the hub and the disc on "
           f"that axis.")
    return "cam_disc", txt, (D, D, t + hh)


def star_wheel(rng):
    n = rng.choice([5, 6, 8])
    Ro = rng.choice([30, 35, 40])
    Ri = Ro * rng.choice([0.5, 0.6])
    t = rng.choice([3, 4, 5])
    dh = rng.choice([6, 8])
    pts = [((Ro if k % 2 == 0 else Ri) * math.cos(math.pi * k / n), (Ro if k % 2 == 0 else Ri) * math.sin(math.pi * k / n))
           for k in range(2 * n)]
    xs, ys = [p[0] for p in pts], [p[1] for p in pts]
    txt = (f"Design a star-shaped indexing wheel. Seen from above it is a {n}-pointed star centred on the origin: "
           f"its outline joins, in turn, {n} outer points at {g(Ro)} mm from the centre and {n} inner points at "
           f"{g(Ri)} mm, all evenly spaced in angle, with the first outer point on the +X axis. The star is a flat "
           f"plate {g(t)} mm thick lying on the bed, with a {g(dh)} mm hole through its centre.")
    return "star_wheel", txt, (max(xs) - min(xs), max(ys) - min(ys), t)


def frustum_riser(rng):
    a = rng.choice([60, 80, 100])
    b = a - 2 * rng.choice([10, 15, 20])
    h = rng.choice([20, 25, 30])
    p = b - 2 * rng.choice([4, 5])
    pdp = rng.choice([5, 8])
    txt = (f"Design a tapered riser block for setting a beaker higher. It is a solid square frustum standing on "
           f"the bed and centred on the origin: a {g(a)} by {g(a)} mm square at the bottom (z = 0), with flat sloping "
           f"sides up to a {g(b)} by {g(b)} mm square top face at z = {g(h)}, edges parallel to X and Y. A square "
           f"pocket {g(p)} by {g(p)} mm and {g(pdp)} mm deep, centred, is cut into the top face.")
    return "frustum_riser", txt, (a, a, h)


def pull_handle(rng):
    s = rng.choice([64, 80, 96])
    dp = rng.choice([10, 12, 14])
    h = rng.choice([20, 25, 30])
    tb = rng.choice([6, 8])
    dh = rng.choice([3.4, 4.5])
    hd = rng.choice([10, 12])
    txt = (f"Design a pull handle for a cabinet door. Two round posts, each {g(dp)} mm in diameter, stand on the bed "
           f"from z = 0 to z = {g(h)} with their axes at x = -{g(s / 2)} and x = {g(s / 2)} (y = 0). On top of them "
           f"lies a straight bar {g(s + dp)} mm long (X), {g(dp)} mm wide (Y) and {g(tb)} mm thick (z = {g(h)} to "
           f"{g(h + tb)}), centred on the origin. Each post has a {g(dh)} mm hole for a screw going up its axis from "
           f"the bottom face, {g(hd)} mm deep.")
    return "pull_handle", txt, (s + dp, dp, h + tb)


def dog_bone(rng):
    Lg = rng.choice([25, 30, 35])
    Ln = rng.choice([30, 40, 50])
    Lt = rng.choice([10, 15])
    Wg = rng.choice([15, 19, 20])
    Wn = rng.choice([6, 8, 10])
    t = rng.choice([3, 4])
    L = 2 * Lg + 2 * Lt + Ln
    txt = (f"Design a flat tensile test specimen (a dog bone) for testing printed plastic. It is {g(t)} mm thick, "
           f"lies on the bed and is symmetric about the origin, {g(L)} mm long in total along X. Seen from above: a "
           f"narrow gauge section {g(Wn)} mm wide (Y) and {g(Ln)} mm long in the middle, a {g(Wg)} mm wide grip "
           f"section {g(Lg)} mm long at each end, and between each grip and the gauge a {g(Lt)} mm long transition "
           f"whose width changes linearly from {g(Wg)} to {g(Wn)} mm.")
    return "dog_bone", txt, (L, Wg, t)


def spoked_wheel(rng):
    OD = rng.choice([60, 80, 100])
    rw = rng.choice([4, 5, 6])
    hub = rng.choice([14, 16, 20])
    dh = rng.choice([5, 6, 8])
    n = rng.choice([4, 5, 6, 8])
    sw = rng.choice([4, 5])
    t = rng.choice([5, 6, 8])
    txt = (f"Design a spoked wheel for a small sample cart. It is a flat part {g(t)} mm thick lying on the bed, "
           f"centred on the origin: an outer rim (a ring {g(OD)} mm in outer diameter and {g(rw)} mm wide), a round "
           f"hub {g(hub)} mm in diameter with a {g(dh)} mm axle hole through its centre, and {n} straight spokes, each "
           f"{g(sw)} mm wide, running radially from the hub to the rim, evenly spaced, the first along the +X axis.")
    return "spoked_wheel", txt, (OD, OD, t)


FAMILIES_C = [t_slot_nut, dial_ring, vibration_foot, ribbed_panel, lab_scoop, cable_bridge, torus_weight,
              hinge_leaf, cam_disc, star_wheel, frustum_riser, pull_handle, dog_bone, spoked_wheel]


def main() -> None:
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--per-family", type=int, default=50)
    ap.add_argument("--seed", type=int, default=20261021)
    ap.add_argument("--max-jaccard", type=float, default=MAX_JACCARD)
    ap.add_argument("--out", default=None)
    a = ap.parse_args()
    rng = random.Random(a.seed)
    evs = eval_token_sets()
    out, seen = [], set()
    for fam in FAMILIES_C:
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
