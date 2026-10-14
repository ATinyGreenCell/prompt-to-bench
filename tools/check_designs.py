#!/usr/bin/env python3
"""Render every design in designs/ with its defaults and with edge-case parameters.

    python tools/check_designs.py          (or: make designs)

Defaults and realistic Customizer changes must give a watertight solid with the expected
number of bodies, no OpenSCAD warnings and, where a design is hollow, open holes at the
heights listed in HOLES; impossible parameters must stop at one of the design's assert()
checks instead of producing a broken part.
"""
import glob
import os
import subprocess
import sys
import tempfile

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.dirname(HERE)
sys.path.insert(0, HERE)
from scadreport import load_mesh  # noqa: E402

BODIES = {"enclosure_box_and_lid": 2, "clearance_coupon": 2}  # everything else is one body
# heights [mm] where a horizontal slice must cut at least one hole: a valid-looking solid can still have filled in
# (a funnel whose inner cone OpenSCAD silently dropped was watertight, one body, and solid)
HOLES = {"lab_funnel_60mm": [10, 30, 45], "clearance_coupon": [2]}

# (design, overrides, expected): "ok" = valid solid, "assert" = stopped by a parameter check
CASES = [
    ("tube_rack_1p5ml", {"cols": 1, "rows": 1}, "ok"),
    ("tube_rack_1p5ml", {"cols": 8, "rows": 3}, "ok"),            # tutorial Part 5
    ("tube_rack_1p5ml", {"pitch": 18}, "ok"),                     # designs/README example
    ("tube_rack_1p5ml", {"pitch": 12}, "assert"),
    ("tube_rack_1p5ml", {"hole_depth": 30}, "assert"),
    ("conical_rack_50ml", {"cols": 1, "rows": 1}, "ok"),
    ("conical_rack_50ml", {"pitch": 31}, "assert"),
    ("pcr_tube_rack_sbs", {"cols": 14}, "assert"),
    ("pcr_tube_rack_sbs", {"hole_d": 8.5}, "assert"),
    ("slide_drying_rack", {"n_slots": 1}, "ok"),
    ("slide_drying_rack", {"n_slots": 20}, "ok"),
    ("slide_drying_rack", {"slot_depth": 10}, "assert"),
    ("clearance_coupon", {"extra": [0, 0.1, 0.2]}, "ok"),
    ("clearance_coupon", {"peg_d": 16}, "assert"),
    ("clearance_coupon", {"peg_d": 16, "pitch": 18}, "ok"),
    ("clearance_coupon", {"peg_d": 25, "pitch": 27}, "assert"),   # holes would open the plate edge
    ("clearance_coupon", {"peg_d": 18, "pitch": 20}, "assert"),   # holes would cut into the labels
    ("enclosure_box_and_lid", {"clearance": 0.1}, "ok"),
    ("enclosure_box_and_lid", {"box": [100, 60, 40]}, "ok"),
    ("enclosure_box_and_lid", {"wall": 0.4}, "assert"),
    ("enclosure_box_and_lid", {"cable_z": 4}, "ok"),
    ("enclosure_box_and_lid", {"box": [70, 50, 15]}, "assert"),   # cable hole would reach the lid's lip
    ("enclosure_box_and_lid", {"box": [70, 50, 20], "cable_d": 12}, "assert"),
    ("mini_gel_tank", {"groove": [1.2, 2.5]}, "assert"),
    ("mini_gel_tank", {"platform_len": 110}, "assert"),
    ("nema17_motor_bracket", {"boss_z": 18}, "assert"),
    ("nema17_motor_bracket", {"mount_x": 15, "mount_y": 35}, "ok"),
    ("nema17_motor_bracket", {"base": [50, 32, 5]}, "assert"),     # M4 holes would break out of the base
    ("nema17_motor_bracket", {"base": [42, 45, 5], "plate": [42, 5, 50]}, "assert"),  # gussets over the screws
    ("stirrer_fan_housing", {"outer": [80, 80, 40]}, "assert"),
    ("dshaft_knob_6mm", {"shaft_d": 6.55, "shaft_flat": 5.0}, "ok"),  # 1/4" shaft
    ("dshaft_knob_6mm", {"bore_depth": 15}, "assert"),
    ("dshaft_knob_6mm", {"shaft_flat": 6.5}, "assert"),
    ("dshaft_knob_6mm", {"knob_d": 9.4}, "assert"),               # 0.6 mm between the bore and a grip groove
    ("hose_barb_reducer_8_5", {"n_barbs": 1}, "ok"),
    ("hose_barb_reducer_8_5", {"n_barbs": 0}, "assert"),
    ("hose_barb_reducer_8_5", {"bore_d": 3.5}, "assert"),
    ("hose_barb_reducer_8_5", {"collar": [14, 4]}, "ok"),
    ("hose_barb_reducer_8_5", {"collar": [16, 3]}, "assert"),     # the 45 deg cone would not fit under it
    ("hose_barb_reducer_8_5", {"collar": [12, 1]}, "assert"),
    ("pcr_tube_adapter", {"bore_depth": 22}, "assert"),
    ("pcr_tube_adapter", {"collar_d": 10}, "assert"),
    ("rod_tubing_clip", {"rod_id": 11.8, "tube_id": 11}, "ok"),
    ("rod_tubing_clip", {"rod_id": 25, "tube_id": 4}, "ok"),
    ("rod_tubing_clip", {"tube_id": 16.5}, "ok"),                 # 3/8" to 1/2" tubing: snap openings must cut through
    ("rod_tubing_clip", {"tube_id": 15, "tube_wall": 3}, "ok"),
    ("rod_tubing_clip", {"rod_id": 36}, "ok"),
    ("gel_comb_10well", {"n_teeth": 8, "tooth_w": 7}, "ok"),
    ("gel_comb_10well", {"n_teeth": 13}, "assert"),
    ("lab_funnel_60mm", {"top_od": 80}, "ok"),                    # renders; steeper than 45 deg, so print it rim-down
    ("lab_funnel_60mm", {"wall": 4.6}, "assert"),
    ("lab_funnel_60mm", {"spout_od": 7.5}, "ok"),                 # used to fill in silently (inner cone dropped)
    ("lab_funnel_60mm", {"wall": 2.6}, "ok"),
    ("lab_funnel_60mm", {"wall": 3.6}, "assert"),
    ("micropestle_1p5ml", {"groove_z": [10, 20]}, "ok"),
    ("micropestle_1p5ml", {"groove_z": [50]}, "assert"),
    ("seed_sowing_template", {"n": 5, "pitch": 12}, "ok"),
    ("seed_sowing_template", {"n": 9}, "assert"),
    ("seed_sowing_template", {"n": 5, "hole_d": 9.5}, "assert"),  # holes would merge
    ("slide_drying_rack", {"block_xz": [81, 12]}, "assert"),       # drain channels would leave 0.25 mm fins
    ("slide_drying_rack", {"slot_pitch": 3.2}, "assert"),
]


def scad_value(v):
    return "[" + ", ".join(scad_value(x) for x in v) + "]" if isinstance(v, list) else str(v)


def run(path, overrides, tmp):
    stl = os.path.join(tmp, "x.stl")
    if os.path.exists(stl):
        os.remove(stl)
    cmd = [os.environ.get("OPENSCAD", "openscad"), "-o", stl]
    for k, v in overrides.items():
        cmd += ["-D", f"{k}={scad_value(v)}"]
    try:
        p = subprocess.run(cmd + [path], capture_output=True, text=True, timeout=300)
    except FileNotFoundError:
        raise SystemExit("OpenSCAD not found - put it on PATH or set $OPENSCAD")
    except (subprocess.TimeoutExpired, PermissionError) as e:  # one bad case must not hide the others
        return "error", f"{type(e).__name__}: {e}"
    log = p.stdout + p.stderr
    if "Assertion" in log:
        return "assert", next(line for line in log.splitlines() if "Assertion" in line).strip()
    if p.returncode != 0 or not os.path.exists(stl):
        return "error", log.strip().splitlines()[-1] if log.strip() else "no output"
    warnings = [line for line in log.splitlines() if line.startswith("WARNING")]
    mesh = load_mesh(stl)
    bodies = len(mesh.split(only_watertight=False))
    name = os.path.basename(path)[:-5]
    if warnings:
        return "warning", warnings[0]
    if not mesh.is_watertight or bodies != BODIES.get(name, 1):
        return "bad solid", f"watertight={mesh.is_watertight}, {bodies} bodies"
    for z in HOLES.get(name, []):
        section = mesh.section(plane_origin=[0, 0, z], plane_normal=[0, 0, 1])
        holes = sum(len(p.interiors) for p in section.to_2D()[0].polygons_full) if section is not None else 0
        if not holes:
            return "filled in", f"no hole in the slice at z = {z} mm"
    return "ok", f"{bodies} bod{'y' if bodies == 1 else 'ies'}, {mesh.volume:,.0f} mm3"


def main():
    paths = {os.path.basename(p)[:-5]: p for p in glob.glob(os.path.join(ROOT, "designs", "*", "*.scad"))}
    cases = [(name, {}, "ok") for name in sorted(paths)] + CASES
    fails = 0
    with tempfile.TemporaryDirectory() as tmp:
        for name, overrides, expected in cases:
            got, detail = run(paths[name], overrides, tmp)
            ok = got == expected
            fails += not ok
            label = ", ".join(f"{k}={scad_value(v)}" for k, v in overrides.items()) or "defaults"
            print(f"{'PASS' if ok else 'FAIL'} {name:24s} {label:34s} {got:9s} {detail}")
    print("ALL PASS" if not fails else f"{fails} FAILED")
    sys.exit(1 if fails else 0)


if __name__ == "__main__":
    main()
