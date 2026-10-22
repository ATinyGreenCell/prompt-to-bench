#!/usr/bin/env python3
"""Build the print-and-measure set (bench/printcheck/README.md): copy each chosen model file into scad/, render it
to STL and slice it for an Original Prusa MK4 with the stock profiles, as tools/slice_library.py does.

    python bench/printcheck/make_printcheck.py            # STL + G-code in build/printcheck/, estimates.csv here
    python bench/printcheck/make_printcheck.py --no-slice # copy and render only (estimates.csv is left as it is)

The G-code is plain text, which the MK4 accepts; it and the STLs stay out of git (.gitignore).
"""
import argparse
import csv
import os
import shutil
import subprocess
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.dirname(os.path.dirname(HERE))
sys.path.insert(0, os.path.join(ROOT, "tools"))
import slice_library as SL  # noqa: E402

HO = "bench/heldout/harness/bench/results"
GEMMA = "tiiny_google_gemma-4-26B-A4B-it"
# id, source file (repo-relative), task, checker verdict, what the print tests
PARTS = [
    ("A1_magnet_rack_gemma", f"{HO}/r4-gemma26b-std/code/{GEMMA}/pcr_strip_magnet_rack_s2_a0.scad",
     "pcr_strip_magnet_rack", "pass", "Gemma 4 26B (box), first attempt"),
    ("A2_puck_gemma", f"{HO}/r4-gemma26b-std/code/{GEMMA}/roundbottom_tube_puck_2ml_s2_a0.scad",
     "roundbottom_tube_puck_2ml", "pass", "Gemma 4 26B (box), first attempt"),
    ("A3_balance_stand_gemma", f"{HO}/r4-gemma26b-std/code/{GEMMA}/microtube_balance_stand_s1_a1.scad",
     "microtube_balance_stand", "pass", "Gemma 4 26B (box), second attempt"),
    ("A4_cuvette_rack_gemma", f"{HO}/r4-gemma26b-h4/code/{GEMMA}/cuvette_rack_2x6_s1_checklist_a0.scad",
     "cuvette_rack_2x6", "pass", "Gemma 4 26B (box, h4 prompt), first attempt"),
    ("A5_spreader_gemma", f"{HO}/r4-gemma26b-std/code/{GEMMA}/hockey_stick_spreader_s1_a0.scad",
     "hockey_stick_spreader", "pass", "Gemma 4 26B (box), first attempt"),
    ("B1_strainer_haiku", f"{HO}/r4-claude/code/claude_claude-haiku-4-5/cell_strainer_50ml_s0_a0.scad",
     "cell_strainer_50ml", "pass", "Claude Haiku 4.5, first attempt"),
    ("B2_syringe_holder_sonnet", f"{HO}/r4-claude/code/claude_claude-sonnet-5-5/syringe_holder_10ml_s0_a0.scad",
     "syringe_holder_10ml", "pass", "Claude Sonnet 5.5, first attempt"),
    ("C1_balance_stand_haiku_fail", f"{HO}/r4-claude/code/claude_claude-haiku-4-5/microtube_balance_stand_s0_a1.scad",
     "microtube_balance_stand", "fail (window 6 x 14 mm, asked 4 x 12)", "Claude Haiku 4.5, best attempt"),
    ("C2_magnet_rack_gemma_fail", f"{HO}/r4-gemma26b-h4/code/{GEMMA}/pcr_strip_magnet_rack_s2_checklist_a1.scad",
     "pcr_strip_magnet_rack", "fail (seat cones upside down)", "Gemma 4 26B (box, h4 prompt), best attempt"),
    ("C3_puck_qwen36_fail", f"{HO}/r4-qwen36-std/code/tiiny_Qwen_Qwen3.6-27B/roundbottom_tube_puck_2ml_s0_a0.scad",
     "roundbottom_tube_puck_2ml", "fail (label flat 1 mm too far out)", "Qwen3.6 27B (box), best attempt"),
]


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--no-slice", action="store_true")
    args = ap.parse_args()
    scad_dir = os.path.join(HERE, "scad")
    out_dir = os.path.join(ROOT, "build", "printcheck")
    if shutil.which(SL.OPENSCAD) is None and not os.path.exists(SL.OPENSCAD):
        raise SystemExit(f"OpenSCAD not found ({SL.OPENSCAD!r}) - install it (openscad.org) or set OPENSCAD=/path/to/openscad")
    os.makedirs(scad_dir, exist_ok=True)
    os.makedirs(out_dir, exist_ok=True)
    if not args.no_slice:
        if not SL.CMD or shutil.which(SL.CMD[0]) is None:
            raise SystemExit("PrusaSlicer not found; set PRUSASLICER or use --no-slice")
        SL.setup_datadir()
    rows = []
    for pid, src, task, verdict, source in PARTS:
        dst = os.path.join(scad_dir, pid + ".scad")
        shutil.copyfile(os.path.join(ROOT, src), dst)
        stl = os.path.join(out_dir, pid + ".stl")
        p = subprocess.run([SL.OPENSCAD, "-o", stl, "--export-format", "binstl", dst], capture_output=True, text=True,
                           errors="replace")
        if p.returncode != 0 or not os.path.exists(stl):
            raise SystemExit(f"OpenSCAD failed on {pid}:\n{(p.stdout + p.stderr)[-800:]}")
        row = {"part": pid, "task": task, "checker": verdict, "source": source, "file": src}
        if not args.no_slice:
            gcode = os.path.join(out_dir, pid + ".gcode")
            p = subprocess.run(SL.CMD + ["--datadir", SL.DATADIR, "--printer-profile", SL.PRINTER, "--print-profile",
                                         SL.PRINT, "--material-profile", SL.MATERIAL, "--threads", "1",
                                         "--export-gcode", "--output", gcode, stl], capture_output=True, text=True)
            if p.returncode != 0 or not os.path.exists(gcode):
                raise SystemExit(f"PrusaSlicer failed on {pid}:\n{(p.stdout + p.stderr)[-800:]}")
            meta = {}
            for line in open(gcode, errors="replace"):
                if line.startswith("; filament used [cm3] = "):
                    meta["cm3"] = float(line.split("=")[1])
                elif line.startswith("; estimated printing time (normal mode) = "):
                    meta["time"] = line.split("=")[1].strip()
            if "cm3" not in meta or "time" not in meta:
                raise SystemExit(f"{gcode}: no filament or time estimate in the G-code (another PrusaSlicer version?)")
            g = meta["cm3"] * SL.PLA_G_PER_CM3
            row.update({"print_time": meta["time"], "hours": round(SL.hms(meta["time"]), 2),
                        "filament_g": round(g, 1)})
        rows.append(row)
        print(f"{pid:30s} {row.get('print_time', '-'):>12s} {row.get('filament_g', 0):7.1f} g")
    if args.no_slice:  # without slicing there are no estimates: never overwrite the published ones with fewer columns
        print(f"rendered {len(rows)} parts -> {out_dir}; estimates.csv not changed")
        return
    with open(os.path.join(HERE, "estimates.csv"), "w", newline="") as fh:
        w = csv.DictWriter(fh, fieldnames=list(rows[0]))
        w.writeheader()
        w.writerows(rows)
    print(f"total {sum(r['hours'] for r in rows):.1f} h, {sum(r['filament_g'] for r in rows):.0f} g -> {out_dir}")


if __name__ == "__main__":
    main()
