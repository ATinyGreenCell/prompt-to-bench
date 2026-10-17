#!/usr/bin/env python3
"""Bench-style part descriptions for distillation that are HELD OUT from the 16 eval tasks.

gen_prompts.py (the v3 distillation set) mirrors several eval prompts nearly word for word - its
tube_rack / funnel / gel_comb / adapter_sleeve / enclosure_lid / dshaft_knob families reach a token
Jaccard of 0.69-0.86 with tube_rack_1p5ml, lab_funnel_60mm, gel_comb_10well, pcr_tube_adapter,
enclosure_box_and_lid and dshaft_knob_6mm - so a model trained on it is tested *in-family* on those
tasks. This module keeps the bench STYLE (concrete mm, print orientation, explicit placement) but
uses part types that are not eval tasks, and drops any prompt whose token Jaccard with an eval
prompt exceeds MAX_JACCARD (the original training set peaks at 0.21; same-style-different-part
prompts sit around 0.25-0.40).

Each family returns (name, description, (X, Y, Z) outer bounding box in mm) like gen_prompts.py, so
distill.py's bbox check works unchanged.

    python gen_prompts_clean.py --per-family 40 --seed 20261018 --out prompts_clean.jsonl
"""
from __future__ import annotations

import argparse
import json
import pathlib
import random
import re
import sys

sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
from gen_prompts import art, even_up, f1, fi  # noqa: E402  (same number formatting as v3)

ROOT = pathlib.Path("/home/seb/printpaper")
MAX_JACCARD = 0.40
TOK = re.compile(r"[a-z]+|\d+(?:\.\d+)?")


def g(x: float) -> str:
    """A dimension as written in the eval prompts: integer if whole, else one decimal."""
    return fi(x) if abs(x - round(x)) < 1e-9 else f1(x)


# --------------------------------------------------------------------------- part families
def cuvette_stand(rng):
    n = rng.choice([4, 5, 6, 8])
    s = rng.choice([12.8, 13.0, 13.2])
    pitch = s + rng.choice([5, 6, 7])
    margin = rng.choice([6, 7, 8])
    X, Y = even_up((n - 1) * pitch + s + 2 * margin), even_up(s + 2 * margin)
    Z = rng.choice([25, 28, 30, 32])
    floor = rng.choice([3, 4, 5])
    txt = (f"Model a stand for {n} standard 1 cm spectrophotometer cuvettes. The stand is one rectangular "
           f"block, {g(X)} mm in X, {g(Y)} mm in Y and {g(Z)} mm high, centred on the origin in X and Y and "
           f"standing on z = 0. A row of {n} square pockets runs along X, each {g(s)} mm by {g(s)} mm and "
           f"{g(Z - floor)} mm deep, opened from the top face and spaced {g(pitch)} mm apart centre to centre; "
           f"the row is centred on the block. The pockets stop {g(floor)} mm above the bottom face.")
    return "cuvette_stand", txt, (X, Y, Z)


def pipette_cradle(rng):
    L = rng.choice([120, 140, 160, 180])
    W = rng.choice([30, 35, 40])
    t = rng.choice([4, 5, 6])
    ut = rng.choice([8, 10, 12])
    H = rng.choice([30, 35, 40])
    r = rng.choice([7, 8, 9, 10])
    txt = (f"Design a horizontal rest for a pipette. A flat base plate {g(L)} mm long (X), {g(W)} mm wide (Y) "
           f"and {g(t)} mm thick sits on the bed (z = 0 to {g(t)}), centred on the origin. At each end of the "
           f"plate, flush with that end, an upright block {g(ut)} mm thick in X and as wide as the plate rises "
           f"from z = 0 to z = {g(H)}. Cut a cradle into the top of each upright: a semicircular notch of radius "
           f"{g(r)} mm whose centre lies on the top edge at y = 0, z = {g(H)}, running through the upright along X.")
    return "pipette_cradle", txt, (L, W, H)


def petri_recess_plate(rng):
    D = rng.choice([35, 55, 60, 90])
    d = D + rng.choice([1.0, 1.5, 2.0])
    n = rng.choice([1, 2, 3])
    pitch = d + rng.choice([8, 10, 12])
    m = rng.choice([8, 10])
    X, Y = even_up((n - 1) * pitch + d + 2 * m), even_up(d + 2 * m)
    T = rng.choice([5, 6, 8])
    rd = rng.choice([2, 3]) if T <= 5 else rng.choice([2, 3, 4])
    if n == 1:
        where = f"one circular recess {g(d)} mm in diameter and {g(rd)} mm deep, centred on the plate"
    else:
        where = (f"{n} circular recesses, each {g(d)} mm in diameter and {g(rd)} mm deep, in a single row along "
                 f"X, {g(pitch)} mm apart centre to centre, the row centred on the plate")
    txt = (f"Create a bench mat that stops {n} Petri dish{'es' if n > 1 else ''} ({g(D)} mm) from sliding. It is a "
           f"flat plate {g(X)} mm (X) by {g(Y)} mm (Y), {g(T)} mm thick, lying on the bed with its centre at the "
           f"origin. Into the top face cut {where}.")
    return "petri_recess_plate", txt, (X, Y, T)


def cap_wrench(rng):
    Dd = rng.choice([40, 45, 50, 55])
    af = rng.choice([22, 24, 27, 30, 32])
    while af > Dd - 14:
        af -= 2
    T = rng.choice([5, 6, 8])
    hw = rng.choice([14, 16, 18])
    Lh = rng.choice([90, 100, 110, 120])
    txt = (f"Design a flat wrench for loosening hexagonal caps on reagent bottles. It is a single plate {g(T)} mm "
           f"thick lying on the bed (z = 0 to {g(T)}). It consists of a round head, a disc {g(Dd)} mm in diameter "
           f"centred on the origin, and a straight handle, a bar {g(hw)} mm wide (Y) running from x = 0 to "
           f"x = {g(Lh)}, centred on y = 0 and merged with the head. Through the head, centred on the origin, cut a "
           f"regular hexagonal hole {g(af)} mm across the flats, with two of its flats parallel to the X axis.")
    return "cap_wrench", txt, (Dd / 2 + Lh, Dd, T)


def groove_block(rng):
    L = rng.choice([40, 50, 60, 70])
    W = rng.choice([24, 28, 32, 36])
    H = rng.choice([16, 18, 20, 24])
    gd = rng.choice([10, 12, 13, 15, 16, 17])
    while gd > W - 8 or gd / 2 > H - 5:
        gd -= 1
    txt = (f"Design a holding block for writing labels on a tube lying on its side. It is a rectangular block "
           f"{g(L)} mm long (X), {g(W)} mm wide (Y) and {g(H)} mm tall (Z), centred on the origin in X and Y and "
           f"standing on z = 0. A straight channel with a semicircular cross-section runs the full length of the "
           f"top face along X: it is {g(gd)} mm in diameter and its axis lies along the top surface at y = 0, "
           f"z = {g(H)}, so the channel is {g(gd / 2)} mm deep.")
    return "groove_block", txt, (L, W, H)


def syringe_end_block(rng):
    Bx = rng.choice([30, 36, 40, 44])
    By = rng.choice([16, 18, 20])
    Bz = rng.choice([20, 24, 28])
    d = rng.choice([8.0, 9.0, 10.0, 12.0])
    zc = Bz / 2
    hd = rng.choice([3.4, 4.5])
    e = rng.choice([5, 6])
    hx = Bx / 2 - e
    txt = (f"Design an end block for a DIY syringe pump. It is a rectangular block {g(Bx)} mm in X, {g(By)} mm in "
           f"Y and {g(Bz)} mm in Z, centred on the origin in X and Y and resting on z = 0. A horizontal bore "
           f"{g(d)} mm in diameter passes straight through the block along Y; its axis is at x = 0, z = {g(zc)}. "
           f"Two vertical mounting holes, each {g(hd)} mm in diameter, go through the full height at "
           f"x = -{g(hx)} and x = {g(hx)}, y = 0.")
    return "syringe_end_block", txt, (Bx, By, Bz)


HEX_KEYS = [1.5, 2.0, 2.5, 3.0, 4.0, 5.0, 6.0, 8.0]


def hex_key_block(rng):
    k = rng.choice([4, 5, 6])
    i0 = rng.randrange(0, len(HEX_KEYS) - k + 1)
    sizes = [round(s + 0.4, 1) for s in HEX_KEYS[i0:i0 + k]]
    pitch = rng.choice([10, 12, 14])
    margin = rng.choice([7, 8])
    X = even_up((k - 1) * pitch + 2 * margin + sizes[-1])
    Y = rng.choice([16, 18, 20])
    Z = rng.choice([20, 25, 30])
    depth = rng.choice([12, 15])
    lst = ", ".join(g(s) for s in sizes)
    txt = (f"Design an organiser block for hex keys. It is a rectangular block {g(X)} mm long (X), {g(Y)} mm wide "
           f"(Y) and {g(Z)} mm tall (Z), centred on the origin in X and Y, standing on z = 0. Along the X axis "
           f"(y = 0), {g(pitch)} mm apart and centred on the block, cut {k} vertical hexagonal pockets {g(depth)} mm "
           f"deep from the top face. From -X to +X their sizes across the flats are {lst} mm; every hexagon has "
           f"two flats parallel to the X axis.")
    return "hex_key_block", txt, (X, Y, Z)


def bolt_circle_ring(rng):
    OD = rng.choice([60, 70, 80, 90, 100])
    band = rng.choice([10, 12, 14, 15])
    ID = OD - 2 * band
    T = rng.choice([3, 4, 5, 6])
    N = rng.choice([3, 4, 6, 8])
    hd = rng.choice([3.4, 4.5, 5.5])
    bcd = (OD + ID) / 2
    txt = (f"Design a flat spacer ring that raises an instrument off the bench. It is an annulus {g(T)} mm thick "
           f"lying on the bed, centred on the origin, with an outer diameter of {g(OD)} mm and an inner diameter "
           f"of {g(ID)} mm. {N} through-holes, each {g(hd)} mm in diameter, are evenly spaced on a {g(bcd)} mm "
           f"diameter circle, the first one on the +X axis.")
    return "bolt_circle_ring", txt, (OD, OD, T)


def peg_board(rng):
    nx, ny = rng.choice([3, 4, 5, 6]), rng.choice([2, 3, 4])
    d = rng.choice([6, 8, 10])
    p = rng.choice([25, 30, 35, 40])
    m = rng.choice([10, 12, 15])
    PX, PY = (nx - 1) * p + 2 * m, (ny - 1) * p + 2 * m
    PT = rng.choice([4, 5, 6])
    h = rng.choice([30, 40, 50, 60])
    txt = (f"Design a drying board for glassware. A flat base plate {g(PX)} mm (X) by {g(PY)} mm (Y) and {g(PT)} mm "
           f"thick lies on the bed (z = 0 to {g(PT)}), centred on the origin. Standing on its top face is a {nx} by "
           f"{ny} grid of vertical round pegs ({nx} along X, {ny} along Y), each {g(d)} mm in diameter, rising from "
           f"z = {g(PT)} to z = {g(PT + h)}; the pegs are {g(p)} mm apart centre to centre in both directions and "
           f"the grid is centred on the plate.")
    return "peg_board", txt, (PX, PY, PT + h)


def diffuser_frame(rng):
    OX, OY = rng.choice([120, 140, 160, 180]), rng.choice([90, 100, 110, 120])
    fw = rng.choice([8, 10, 12])
    T = rng.choice([3, 4, 5])
    hd = rng.choice([3.4, 4.5])
    hx, hy = OX / 2 - fw / 2, OY / 2 - fw / 2
    txt = (f"Design a frame that holds a diffuser sheet over a lab light pad. It is a flat rectangular frame "
           f"{g(T)} mm thick lying on the bed, centred on the origin: outer size {g(OX)} by {g(OY)} mm (X by Y), "
           f"with a rectangular window {g(OX - 2 * fw)} by {g(OY - 2 * fw)} mm cut through its middle, so the "
           f"border is {g(fw)} mm wide all round. A {g(hd)} mm through-hole sits in the border at each of the four "
           f"corners, at x = ±{g(hx)}, y = ±{g(hy)}.")
    return "diffuser_frame", txt, (OX, OY, T)


def slotted_shim(rng):
    L = rng.choice([50, 60, 70, 80])
    W = rng.choice([20, 24, 28, 30])
    T = rng.choice([2, 3, 4])
    sw = rng.choice([3.4, 4.5, 5.5])
    sl = rng.choice([12, 14, 16, 18])
    sx = rng.choice([15, 18, 20])
    while sx + sl / 2 > L / 2 - 5:
        sx -= 1
    txt = (f"Design an adjustable shim plate. It is a flat plate {g(L)} mm long (X), {g(W)} mm wide (Y) and "
           f"{g(T)} mm thick, lying on the bed with its centre at the origin. It has two through-slots for bolts, "
           f"both running along X with fully rounded ends: each slot is {g(sw)} mm wide and {g(sl)} mm long overall "
           f"(end to end), and the slots are centred at x = -{g(sx)} and x = {g(sx)}, y = 0.")
    return "slotted_shim", txt, (L, W, T)


def riser_stand(rng):
    PX, PY = rng.choice([130, 140, 150]), rng.choice([90, 95, 100])
    t = rng.choice([4, 5, 6])
    H = rng.choice([30, 40, 50, 60])
    ls = rng.choice([10, 12, 15])
    wx, wy = PX - 2 * ls - rng.choice([10, 20]), PY - 2 * ls - rng.choice([10, 20])
    txt = (f"Design a riser that lifts a microplate above the bench. It has a flat top plate {g(PX)} mm (X) by "
           f"{g(PY)} mm (Y) and {g(t)} mm thick whose top face is at z = {g(H)}, centred on the origin. Four square "
           f"legs, each {g(ls)} by {g(ls)} mm, support it at the corners, flush with the plate's outer edges, "
           f"running from z = 0 up to the underside of the plate. A rectangular window {g(wx)} by {g(wy)} mm is "
           f"cut through the centre of the top plate.")
    return "riser_stand", txt, (PX, PY, H)


def magnet_disc(rng):
    D = rng.choice([40, 50, 60])
    T = rng.choice([6, 8, 10])
    md = rng.choice([6.2, 8.2, 10.2])
    mdp = rng.choice([2, 3, 4])
    while mdp > T - 2:
        mdp -= 1
    N = rng.choice([2, 4, 6])
    cd = D - md - rng.choice([8, 10])
    ch = rng.choice([4, 5, 6])
    txt = (f"Design a carrier disc that holds magnets for a rotating sample mixer. It is a cylinder {g(D)} mm in "
           f"diameter and {g(T)} mm tall standing on the bed, centred on the origin. In its top face cut {N} round "
           f"pockets for disc magnets, each {g(md)} mm in diameter and {g(mdp)} mm deep, evenly spaced on a "
           f"{g(cd)} mm diameter circle with the first pocket on the +X axis. A {g(ch)} mm diameter hole runs "
           f"through the centre for the motor shaft.")
    return "magnet_disc", txt, (D, D, T)


def countersunk_strip(rng):
    N = rng.choice([2, 3, 4, 5])
    p = rng.choice([30, 40, 50])
    L = (N - 1) * p + rng.choice([20, 24, 30])
    W = rng.choice([16, 20, 24])
    T = rng.choice([4, 5, 6])
    d, cd = rng.choice([(3.4, 6.5), (4.5, 9.0), (5.5, 11.0)])
    txt = (f"Design a mounting strip for screwing lab equipment to a wall. It is a flat bar {g(L)} mm long (X), "
           f"{g(W)} mm wide (Y) and {g(T)} mm thick, lying on the bed, centred on the origin. It has {N} screw holes "
           f"along the X axis at y = 0, {g(p)} mm apart and centred on the bar. Each hole is a {g(d)} mm through-hole "
           f"with a 90-degree countersink on the top face, {g(cd)} mm in diameter at the surface.")
    return "countersunk_strip", txt, (L, W, T)


def box_divider(rng):
    nx, ny = rng.choice([3, 4, 5, 6]), rng.choice([2, 3, 4, 5])
    cell = rng.choice([18, 20, 25, 30])
    wt = rng.choice([1.2, 1.5, 2.0])
    X, Y = round(nx * cell + (nx + 1) * wt, 1), round(ny * cell + (ny + 1) * wt, 1)
    h = rng.choice([20, 25, 30, 35])
    txt = (f"Design a divider insert for a sample storage box. It is an open lattice with no floor: an outer "
           f"rectangular wall {g(X)} mm by {g(Y)} mm (outside size, X by Y), {g(h)} mm tall, standing on the bed and "
           f"centred on the origin, split by straight internal walls into a {nx} by {ny} grid of equal open "
           f"cells ({nx} along X, {ny} along Y), each {g(cell)} mm square inside. All walls, outer and inner, are "
           f"{g(wt)} mm thick.")
    return "box_divider", txt, (X, Y, h)


def cable_comb(rng):
    N = rng.choice([3, 4, 5, 6])
    sw = rng.choice([4, 5, 6, 7, 8])
    p = sw + rng.choice([6, 8, 10])
    L = (N - 1) * p + sw + 2 * rng.choice([8, 10])
    W = rng.choice([24, 28, 32])
    sd = rng.choice([10, 12, 14])
    T = rng.choice([4, 5, 6])
    txt = (f"Design a tubing organiser that keeps several lines side by side. It is a flat plate {g(L)} mm long "
           f"(X), {g(W)} mm wide (Y) and {g(T)} mm thick, lying on the bed, centred on the origin. Along its +Y edge "
           f"cut {N} rectangular notches through the full thickness, each {g(sw)} mm wide (X) and {g(sd)} mm deep "
           f"(into the plate, along -Y), spaced {g(p)} mm apart centre to centre and centred along X.")
    return "cable_comb", txt, (L, W, T)


def tubing_reel(rng):
    Df = rng.choice([50, 60, 70, 80])
    tf = rng.choice([2, 3])
    Dc = rng.choice([20, 25, 30])
    Lc = rng.choice([15, 20, 25, 30])
    b = rng.choice([6, 8, 10])
    Z = 2 * tf + Lc
    txt = (f"Design a small reel for winding silicone tubing, printed lying on one flange. It is round about the "
           f"Z axis: a bottom flange {g(Df)} mm in diameter from z = 0 to z = {g(tf)}, a core {g(Dc)} mm in diameter "
           f"from z = {g(tf)} to z = {g(tf + Lc)}, and a top flange {g(Df)} mm in diameter from z = {g(tf + Lc)} to "
           f"z = {g(Z)}. A {g(b)} mm diameter bore runs straight through the centre along Z.")
    return "tubing_reel", txt, (Df, Df, Z)


FAMILIES = [cuvette_stand, pipette_cradle, petri_recess_plate, cap_wrench, groove_block, syringe_end_block,
            hex_key_block, bolt_circle_ring, peg_board, diffuser_frame, slotted_shim, riser_stand, magnet_disc,
            countersunk_strip, box_divider, cable_comb, tubing_reel]


# --------------------------------------------------------------------------- eval gate + driver
def eval_token_sets() -> dict[str, set]:
    import yaml
    tasks = yaml.safe_load(open(ROOT / "bench" / "tasks.yaml"))
    tasks = tasks if isinstance(tasks, list) else tasks["tasks"]
    return {t["id"]: set(TOK.findall(t["prompt"].lower())) for t in tasks}


def max_jaccard(text: str, evs: dict[str, set]) -> tuple[float, str]:
    t = set(TOK.findall(text.lower()))
    return max((len(t & e) / len(t | e), k) for k, e in evs.items())


def generate(per_family: int, seed: int, max_j: float = MAX_JACCARD) -> tuple[list[dict], dict]:
    rng = random.Random(seed)
    evs = eval_token_sets()
    out, seen, stats = [], set(), {}
    for fam in FAMILIES:
        kept = tries = rejected = 0
        while kept < per_family and tries < 4000:
            tries += 1
            name, user, bbox = fam(rng)
            if user in seen:
                continue
            j, near = max_jaccard(user, evs)
            if j > max_j:
                rejected += 1
                continue
            seen.add(user)
            out.append({"id": f"{name}_{kept:03d}", "family": name, "user": user,
                        "bbox": [round(float(v), 2) for v in bbox], "max_jaccard": round(j, 3), "nearest_eval": near})
            kept += 1
        stats[fam.__name__] = {"kept": kept, "rejected_jaccard": rejected}
    return out, stats


def main() -> None:
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--per-family", type=int, default=40)
    ap.add_argument("--seed", type=int, default=20261018)
    ap.add_argument("--max-jaccard", type=float, default=MAX_JACCARD)
    ap.add_argument("--out", default=None)
    a = ap.parse_args()
    prompts, stats = generate(a.per_family, a.seed, a.max_jaccard)
    for k, v in stats.items():
        js = [p["max_jaccard"] for p in prompts if p["family"] == k]
        print(f"{k:20s} kept {v['kept']:3d}  rejected {v['rejected_jaccard']:3d}  "
              f"max J {max(js) if js else 0:.2f}  nearest {max(((p['max_jaccard'], p['nearest_eval']) for p in prompts if p['family'] == k), default=(0, '-'))[1]}")
    print(f"total {len(prompts)}  overall max Jaccard {max(p['max_jaccard'] for p in prompts):.3f}")
    if a.out:
        with open(a.out, "w", encoding="utf-8") as fh:
            fh.write("\n".join(json.dumps(p, ensure_ascii=False) for p in prompts) + "\n")
        print("wrote", a.out)


if __name__ == "__main__":
    main()
