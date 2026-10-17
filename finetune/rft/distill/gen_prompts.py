#!/usr/bin/env python3
"""Generate diverse, bench-style descriptions of bio-lab 3D-printable parts.

Each prompt is one self-contained paragraph in the exact style of bench/tasks.yaml:
concrete caliper dimensions in mm, an explicit print orientation, hole/feature
counts, and "centred on the block / the origin" so the part is unambiguous. These
descriptions are the `user` turn fed to Opus by distill.py; Opus writes the
OpenSCAD, which is render-verified before it is kept as training data.

Every family also returns the overall outer bounding box (X, Y, Z sizes in mm)
that its dimensions imply, so distill.py can drop any generation whose rendered
bbox is grossly off - a cheap dimensional-fidelity check.

14 part families (racks, holders, adapters, brackets, funnels, clips, caps,
stands, combs, jigs, enclosures, knobs, stoppers, couplers). generate(n, seed)
is round-robin balanced: n a multiple of 14 gives exactly n/14 per family, each
distinct. Combo spaces are >= 80 per family, so hundreds of unique prompts are
available.

    python gen_prompts.py --n 336 --seed 20261017 --out prompts_scaleup.jsonl

    from gen_prompts import generate
    for p in generate(336, seed=20261017): ...   # {id, family, user, bbox:[X,Y,Z]}
"""
from __future__ import annotations

import argparse
import json
import random


# --------------------------------------------------------------------------- formatting helpers
def f1(x: float) -> str:
    return f"{x:.1f}"


def fi(x: float) -> str:
    return f"{int(round(x))}"


def even_up(x: float) -> int:
    n = int(x) + (0 if x == int(x) else 1)
    return n + (n % 2)


def art(x) -> str:
    """'a' / 'an' for a count or dimension read aloud (8x, 11, 18 take 'an')."""
    s = str(int(x))
    return "an" if s[0] == "8" or s in ("11", "18") else "a"


# --------------------------------------------------------------------------- part families
# family(rng) -> (family_name, user_description, (X, Y, Z) outer bbox in mm)

def tube_rack(rng):
    kind, hole_d = rng.choice([
        ("1.5 mL microcentrifuge", 11.2), ("2.0 mL microcentrifuge", 11.0),
        ("0.5 mL microcentrifuge", 8.0), ("15 mL conical", 17.5),
        ("0.2 mL PCR", 6.2), ("5 mL round-bottom", 13.2), ("0.65 mL microcentrifuge", 9.0)])
    pitch = round(hole_d + rng.choice([4, 5, 6, 7]), 0)
    nx, ny = rng.choice([4, 5, 6, 8, 10]), rng.choice([3, 4, 5, 6])
    margin = rng.choice([6, 7, 8, 9])
    Lx, Wy = even_up((nx - 1) * pitch + hole_d + 2 * margin), even_up((ny - 1) * pitch + hole_d + 2 * margin)
    Hz = rng.choice([24, 25, 28, 30, 32, 35])
    floor = rng.choice([4, 5, 6])
    depth = Hz - floor
    n = nx * ny
    txt = (f"Design a bench rack for {n} {kind} tubes. It is a solid rectangular block {fi(Lx)} mm long (X), "
           f"{fi(Wy)} mm wide (Y) and {fi(Hz)} mm tall (Z). It has {n} vertical holes in {ny} rows (along Y) of "
           f"{nx} (along X), {fi(pitch)} mm centre-to-centre in both directions, with the hole grid centred on "
           f"the block. Each hole is {f1(hole_d)} mm in diameter and {fi(depth)} mm deep, open at the top and "
           f"closed at the bottom, leaving {art(floor)} {fi(floor)} mm solid floor.")
    return "tube_rack", txt, (Lx, Wy, Hz)


def vial_holder(rng):
    kind, d = rng.choice([
        ("20 mL scintillation", 28.0), ("7 mL scintillation", 17.0), ("2 mL cryovial", 12.5),
        ("glass HPLC", 11.6), ("13 mm culture", 13.3), ("16 mm culture", 16.2), ("5 mL cryovial", 15.3)])
    n = rng.choice([3, 4, 5, 6, 8])
    pitch = round(d + rng.choice([5, 6, 7, 8]), 0)
    margin = rng.choice([6, 7, 8])
    Lx, Wy = even_up((n - 1) * pitch + d + 2 * margin), even_up(d + 2 * margin)
    Hz = rng.choice([20, 22, 25, 28, 30])
    floor = rng.choice([3, 4, 5])
    depth = Hz - floor
    txt = (f"Design {art(n)} {n}-place holder for {kind} vials, printed upright. It is a solid block {fi(Lx)} mm "
           f"long (X), {fi(Wy)} mm wide (Y) and {fi(Hz)} mm tall (Z). Cut a single row of {n} vertical blind "
           f"holes along X, {fi(pitch)} mm apart centre-to-centre and centred on the block in X and Y. Each hole "
           f"is {f1(d)} mm in diameter and {fi(depth)} mm deep, open at the top and leaving {art(floor)} "
           f"{fi(floor)} mm floor.")
    return "vial_holder", txt, (Lx, Wy, Hz)


def adapter_sleeve(rng):
    collar_d = rng.choice([13.0, 14.0, 15.0, 16.0, 17.0, 18.0])
    body_d = round(collar_d - rng.choice([2.0, 2.2, 2.5, 3.0]), 1)
    bore = round(body_d - 2 * rng.choice([1.5, 2.0, 2.2, 2.5]), 1)
    collar_t = rng.choice([1.5, 2.0, 2.5])
    total_h = rng.choice([18.0, 20.0, 21.5, 24.0, 26.0])
    txt = (f"Design an adapter sleeve that lets a narrow tube sit in a wider rack hole. Print it upside down: a "
           f"collar {f1(collar_d)} mm in diameter and {f1(collar_t)} mm thick lies on the bed (z = 0 to "
           f"{f1(collar_t)}), and the sleeve body, {f1(body_d)} mm in outer diameter, rises from the collar to "
           f"z = {f1(total_h)}. A straight {f1(bore)} mm diameter bore runs through the full height, open at both ends.")
    return "adapter_sleeve", txt, (collar_d, collar_d, total_h)


def l_bracket(rng):
    bx = rng.choice([18, 20, 22, 25, 28])
    depth = rng.choice([35, 40, 45, 50])
    t = rng.choice([4, 5, 6])
    vh = rng.choice([35, 40, 45, 50, 55])
    hole_d = rng.choice([3.4, 4.5, 5.5, 6.5])
    hy = depth - rng.choice([10, 12, 15])
    hx = bx - rng.choice([6, 8, 10])
    hz = vh - rng.choice([12, 15, 18])
    txt = (f"Design an L-shaped mounting bracket, printed with the base plate flat on the bed. Base plate: x from "
           f"{fi(-bx)} to {fi(bx)}, y from 0 to {fi(depth)}, z from 0 to {fi(t)}, with two {f1(hole_d)} mm vertical "
           f"through-holes at (x = {fi(-hx)}, y = {fi(hy)}) and (x = {fi(hx)}, y = {fi(hy)}). Vertical plate: x from "
           f"{fi(-bx)} to {fi(bx)}, y from 0 to {fi(t)}, z from 0 to {fi(vh)}, standing on the back edge of the base "
           f"(y = 0). Through the vertical plate (along Y) cut two {f1(hole_d)} mm holes at (x = {fi(-hx)}, "
           f"z = {fi(hz)}) and (x = {fi(hx)}, z = {fi(hz)}).")
    return "l_bracket", txt, (2 * bx, depth, vh)


def funnel(rng):
    spout_d = rng.choice([8.0, 10.0, 12.0, 14.0])
    wall = rng.choice([1.2, 1.6, 2.0, 2.4])
    bore = round(spout_d - 2 * wall, 1)
    spout_h = rng.choice([15, 18, 20, 22, 25])
    rim_d = rng.choice([40, 45, 50, 55, 60, 70])
    rim_z = spout_h + rng.choice([25, 30, 35, 40])
    txt = (f"Design a small lab funnel, printed upright with the wide opening at the top. A straight spout (tube) "
           f"with {f1(spout_d)} mm outer diameter runs from z = 0 to z = {fi(spout_h)}. On top of it, a cone widens "
           f"from {f1(spout_d)} mm outer diameter at z = {fi(spout_h)} to {fi(rim_d)} mm outer diameter at the rim "
           f"at z = {fi(rim_z)}. The wall is {f1(wall)} mm thick everywhere (so the spout bore is {f1(bore)} mm), "
           f"and the funnel is open at the top and at the bottom so liquid runs straight through.")
    return "funnel", txt, (rim_d, rim_d, rim_z)


def rod_clip(rng):
    rod_d = rng.choice([8.0, 10.0, 12.0, 12.7, 16.0, 20.0])
    wall = rng.choice([2.5, 3.0, 3.5, 4.0])
    gap = round(rod_d * rng.choice([0.55, 0.62, 0.70]), 1)
    height = rng.choice([8, 10, 12, 15])
    od = round(rod_d + 2 * wall, 1)
    txt = (f"Design a snap-on C-clip that grips {art(rod_d)} {f1(rod_d)} mm lab-stand rod, printed flat as "
           f"{art(height)} {fi(height)} mm tall extrusion (Z) of a 2-D profile in the XY plane. The profile is a "
           f"ring with {f1(rod_d)} mm inner diameter and {f1(wall)} mm wall (so {f1(od)} mm outer diameter), "
           f"centred on the origin, with a {f1(gap)} mm wide opening cut out of its -X side (everything with x < 0 "
           f"and -{f1(gap / 2)} < y < {f1(gap / 2)} is removed) so it snaps onto the rod.")
    return "rod_clip", txt, (od, od, height)


def push_cap(rng):
    tube_od = rng.choice([10.0, 12.0, 15.0, 16.0, 18.0, 20.0, 25.0])
    clear = rng.choice([0.3, 0.4, 0.5])
    wall = rng.choice([1.6, 2.0, 2.5, 3.0])
    inner = round(tube_od + 2 * clear, 1)
    outer = round(inner + 2 * wall, 1)
    skirt = rng.choice([8, 10, 12, 14])
    top = rng.choice([2.0, 2.5, 3.0])
    grooves = rng.choice([8, 10, 12, 16])
    txt = (f"Design a push-on cap for a tube with {f1(tube_od)} mm outer diameter, printed open-end up. It is a "
           f"cylinder {f1(outer)} mm in outer diameter and {fi(skirt)} mm tall standing on the bed, with a "
           f"{f1(inner)} mm diameter blind bore going down from the top to leave a {f1(top)} mm thick closed cap "
           f"at the bottom (so the skirt wall is {f1(wall)} mm and the cap slips over the tube with {f1(clear)} mm "
           f"clearance). Around the outside, cut {grooves} evenly spaced vertical grip grooves over the full "
           f"height, each a 2 mm diameter half-cylinder centred on the outer surface.")
    return "push_cap", txt, (outer, outer, skirt)


def rod_stand(rng):
    base_d = rng.choice([60, 70, 80, 90, 100])
    base_t = rng.choice([5, 6, 8, 10])
    boss_d = rng.choice([18, 20, 24, 28, 30])
    boss_h = rng.choice([15, 18, 22, 25, 30])
    rod_d = rng.choice([6.0, 8.0, 10.0, 12.0])
    set_d = rng.choice([4.5, 5.0, 5.5])
    txt = (f"Design a weighted base that holds a vertical support rod, printed upright. It is a solid disc "
           f"{fi(base_d)} mm in diameter and {fi(base_t)} mm thick lying on the bed (z = 0 to {fi(base_t)}), with a "
           f"central cylindrical boss {fi(boss_d)} mm in diameter rising from the disc to z = {fi(base_t + boss_h)}, "
           f"centred on the origin. A {f1(rod_d)} mm diameter blind bore for the rod runs down the axis from the top "
           f"of the boss to z = {fi(base_t)}. Through the boss, cut one radial {f1(set_d)} mm set-screw hole at "
           f"z = {fi(base_t + boss_h - 6)}, from the +X side to the bore.")
    return "rod_stand", txt, (base_d, base_d, base_t + boss_h)


def gel_comb(rng):
    n = rng.choice([6, 8, 10, 12, 14, 16])
    tooth_w = rng.choice([3.0, 4.0, 5.0, 6.0])
    gap = rng.choice([1.5, 2.0, 2.5, 3.0])
    tooth_l = rng.choice([8, 10, 12, 14, 16])
    spine_w = rng.choice([8, 10, 12, 14])
    th = rng.choice([1.5, 2.0, 2.5])
    spine_len = even_up(n * tooth_w + (n - 1) * gap + rng.choice([8, 10, 12]))
    txt = (f"Design {art(n)} {n}-well comb for casting agarose gels, printed lying flat as a {f1(th)} mm thick "
           f"plate (Z) on the bed. Seen from above it has a straight spine (back bar) {fi(spine_len)} mm long (X) "
           f"and {fi(spine_w)} mm wide (Y), and {n} rectangular teeth hanging from one long edge of the spine in "
           f"the -Y direction. Each tooth is {f1(tooth_w)} mm wide (X) and {fi(tooth_l)} mm long (Y), the gaps "
           f"between neighbouring teeth are {f1(gap)} mm, and the row of teeth is centred on the spine in X.")
    return "gel_comb", txt, (spine_len, spine_w + tooth_l, th)


def drill_jig(rng):
    nx, ny = rng.choice([3, 4, 5, 6]), rng.choice([3, 4, 5])
    pitch = rng.choice([8, 9, 10, 12, 15])
    hole_d = rng.choice([3.0, 3.4, 4.0, 5.0, 6.0])
    t = rng.choice([3, 4, 5, 6])
    margin = rng.choice([8, 10, 12])
    Lx, Wy = even_up((nx - 1) * pitch + hole_d + 2 * margin), even_up((ny - 1) * pitch + hole_d + 2 * margin)
    notch_w = rng.choice([8, 10, 12])
    notch_d = rng.choice([3, 4, 5])
    n = nx * ny
    txt = (f"Design a flat drilling/marking jig: a rectangular plate {fi(Lx)} mm long (X), {fi(Wy)} mm wide (Y) and "
           f"{fi(t)} mm thick lying on the bed. It has a {nx} x {ny} grid of {f1(hole_d)} mm diameter through-holes "
           f"({n} in all) at {fi(pitch)} mm centre-to-centre spacing in both directions, centred on the plate. Cut "
           f"a rectangular orientation notch into the +Y edge, centred on the Y axis: {fi(notch_w)} mm wide (X) and "
           f"{fi(notch_d)} mm deep (Y, measured in from the edge).")
    return "drill_jig", txt, (Lx, Wy, t)


def enclosure_lid(rng):
    bx, by, bz = rng.choice([55, 60, 70, 80, 90]), rng.choice([40, 45, 50, 55, 60]), rng.choice([22, 25, 30, 35])
    wall = rng.choice([1.6, 2.0, 2.5])
    floor = rng.choice([1.6, 2.0, 2.5])
    lid_t = rng.choice([2.0, 2.5, 3.0])
    lip_t = rng.choice([1.2, 1.5, 2.0])
    lip_h = rng.choice([3, 4, 5])
    clear = rng.choice([0.2, 0.3])
    lip_x = round(bx - 2 * wall - 2 * clear, 1)
    lip_y = round(by - 2 * wall - 2 * clear, 1)
    txt = (f"Design a two-part enclosure for a small electronics board, with both parts in the same file side by "
           f"side on the bed with a 10 mm gap, so they print together. Part 1, the box: outer size {fi(bx)} x "
           f"{fi(by)} x {fi(bz)} mm (X x Y x Z), {f1(wall)} mm walls, {f1(floor)} mm floor, open top. Part 2, the "
           f"lid, printed upside down: a plate {fi(bx)} x {fi(by)} x {f1(lid_t)} mm lying on the bed, with a "
           f"rectangular lip on top of it - a {f1(lip_t)} mm thick wall {fi(lip_h)} mm tall whose outer size is "
           f"{f1(lip_x)} x {f1(lip_y)} mm, centred on the plate, so it slides into the box opening with {f1(clear)} "
           f"mm clearance per side. Place the lid on the +X side of the box.")
    return "enclosure_lid", txt, (2 * bx + 10, by, bz)


def dshaft_knob(rng):
    knob_d = rng.choice([22, 25, 28, 30, 34, 38])
    knob_h = rng.choice([12, 14, 15, 18, 20])
    shaft = rng.choice([6.0, 6.35])
    bore = round(shaft + 0.2, 1)
    flat = round(bore - rng.choice([1.3, 1.5, 1.7]), 1)
    bore_depth = knob_h - rng.choice([3, 4, 5])
    grooves = rng.choice([14, 16, 18, 20, 24])
    txt = (f"Design a replacement control knob for a {f1(shaft)} mm D-shaft, printed with the hotplate-facing side "
           f"down on the bed. The knob is a cylinder {fi(knob_d)} mm in diameter and {fi(knob_h)} mm tall. From the "
           f"bottom face, a D-shaped blind bore goes {fi(bore_depth)} mm up into the knob: a {f1(bore)} mm diameter "
           f"circle with one side cut flat, so the distance from the flat to the opposite side of the circle is "
           f"{f1(flat)} mm. Around the outside, cut {grooves} evenly spaced vertical grip grooves along the full "
           f"height, each a 2 mm diameter half-cylinder centred on the outer surface.")
    return "dshaft_knob", txt, (knob_d, knob_d, knob_h)


def stopper(rng):
    bottom_d = rng.choice([14.0, 16.0, 18.0, 20.0, 24.0, 28.0])
    top_d = round(bottom_d + rng.choice([3.0, 4.0, 5.0, 6.0]), 1)
    height = rng.choice([16, 18, 20, 22, 25])
    through = rng.choice([True, False])
    hole = rng.choice([3.0, 4.0, 5.0, 6.0])
    txt = (f"Design a tapered stopper/plug for a flask neck, printed standing upright (narrow end down). It is a "
           f"truncated cone, rotationally symmetric about the Z axis, {f1(bottom_d)} mm in diameter at the bottom "
           f"(z = 0) widening to {f1(top_d)} mm in diameter at the top (z = {fi(height)}).")
    if through:
        txt += f" A straight {f1(hole)} mm diameter vent bore runs through the full height on the axis, open at both ends."
    else:
        txt += " It is solid."
    return "stopper", txt, (top_d, top_d, height)


def tube_coupler(rng):
    od = rng.choice([14.0, 16.0, 18.0, 20.0, 22.0])
    length = rng.choice([14, 16, 18, 20, 22, 25])
    bore = rng.choice([3.0, 4.0, 5.0, 6.0])
    set_d = rng.choice([4.5, 5.0, 5.4, 6.0])
    txt = (f"Design a rigid in-line coupler that joins two rods end to end, printed standing upright along Z. It is "
           f"a cylinder {f1(od)} mm in outer diameter and {fi(length)} mm long with a {f1(bore)} mm diameter axial "
           f"bore through the full length. Cut two radial {f1(set_d)} mm set-screw holes through the wall, one at "
           f"1/4 and one at 3/4 of the length, on the +X side.")
    return "tube_coupler", txt, (od, od, length)


FAMILIES = [
    tube_rack, vial_holder, adapter_sleeve, l_bracket, funnel, rod_clip, push_cap,
    rod_stand, gel_comb, drill_jig, enclosure_lid, dshaft_knob, stopper, tube_coupler,
]


# --------------------------------------------------------------------------- driver
def generate(n: int, seed: int = 20261017) -> list[dict]:
    """n prompt dicts {id, family, user, bbox:[X,Y,Z]}, round-robin balanced across
    families (n a multiple of len(FAMILIES) => exactly n/len each), all distinct."""
    rng = random.Random(seed)
    out, seen = [], set()
    fi_, tries = 0, 0
    while len(out) < n:
        name, user, bbox = FAMILIES[fi_ % len(FAMILIES)](rng)
        tries += 1
        if user not in seen:
            seen.add(user)
            out.append({"id": f"{name}_{len(out):03d}", "family": name, "user": user,
                        "bbox": [round(float(v), 2) for v in bbox]})
            fi_ += 1
            tries = 0
        elif tries > 2000:          # family effectively exhausted (never expected): move on
            fi_ += 1
            tries = 0
    return out


def main() -> None:
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--n", type=int, default=336)
    ap.add_argument("--seed", type=int, default=20261017)
    ap.add_argument("--out", default=None)
    a = ap.parse_args()
    prompts = generate(a.n, a.seed)
    lines = [json.dumps(p, ensure_ascii=False) for p in prompts]
    if a.out:
        with open(a.out, "w", encoding="utf-8") as fh:
            fh.write("\n".join(lines) + "\n")
        from collections import Counter
        print(f"wrote {len(prompts)} prompts to {a.out}")
        print("per-family:", dict(Counter(p["family"] for p in prompts)))
        print("unique:", len({p["user"] for p in prompts}))
    else:
        print("\n".join(lines))


if __name__ == "__main__":
    main()
