#!/usr/bin/env python3
"""Slice every reference design for an Original Prusa MK4 and tabulate print time and filament.

    python tools/slice_library.py            # writes figures/print_estimates.csv

Uses PrusaSlicer's stock Prusa Research profiles from an isolated config folder
(build/ps-datadir), so your own PrusaSlicer settings are never read.
Set PRUSASLICER to override the command (default: the Flathub flatpak).
"""
import csv
import os
import re
import shlex
import shutil
import subprocess

import yaml

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
DATADIR = os.path.join(ROOT, "build", "ps-datadir")
PRINTER = "Original Prusa MK4 0.4 nozzle"
PRINT = "0.20mm SPEED @MK4 0.4"
MATERIAL = "Prusament PLA @PG"
PLA_G_PER_CM3 = 1.24
PLA_USD_PER_KG = 25.0  # typical spool price; adjust for your market
CMD = shlex.split(os.environ.get("PRUSASLICER", "flatpak run --command=prusa-slicer com.prusa3d.PrusaSlicer"))


def setup_datadir():
    """Isolated config folder with only the stock Prusa profiles (your own presets are never read)."""
    vendor = os.path.join(DATADIR, "vendor", "PrusaResearch.ini")
    if not os.path.exists(vendor):
        os.makedirs(os.path.dirname(vendor), exist_ok=True)
        src = os.environ.get("PRUSA_PROFILES")  # e.g. /usr/share/PrusaSlicer/profiles/PrusaResearch.ini
        for cand in [src, "/usr/share/PrusaSlicer/profiles/PrusaResearch.ini",
                     "/usr/local/share/PrusaSlicer/profiles/PrusaResearch.ini"]:
            if cand and os.path.exists(cand):
                shutil.copy(cand, vendor)
                break
        else:
            if shutil.which("flatpak") is None or subprocess.run(
                    ["flatpak", "run", "--command=cp", "com.prusa3d.PrusaSlicer",
                     "/app/share/PrusaSlicer/profiles/PrusaResearch.ini", vendor]).returncode != 0:
                raise SystemExit("Could not find PrusaSlicer's PrusaResearch.ini profile bundle. "
                                 "Set PRUSA_PROFILES=/path/to/PrusaResearch.ini and PRUSASLICER=/path/to/prusa-slicer")
    with open(os.path.join(DATADIR, "PrusaSlicer.ini"), "w") as fh:
        fh.write("[vendor:PrusaResearch]\nMK4 = 0.4\n")


def hms(s):
    h = re.search(r"(\d+)h", s)
    m = re.search(r"(\d+)m", s)
    d = re.search(r"(\d+)d", s)
    return (int(d.group(1)) * 24 if d else 0) + (int(h.group(1)) if h else 0) + (int(m.group(1)) / 60 if m else 0)


def main():
    setup_datadir()
    tasks = yaml.safe_load(open(os.path.join(ROOT, "bench", "tasks.yaml")))
    out_dir = os.path.join(ROOT, "build", "slice")
    os.makedirs(out_dir, exist_ok=True)
    rows = []
    for t in tasks:
        stl = os.path.join(out_dir, t["id"] + ".stl")
        subprocess.run(["openscad", "-o", stl, "--export-format", "binstl", os.path.join(ROOT, t["reference"])],
                       check=True, capture_output=True)
        gcode = stl.replace(".stl", ".gcode")
        p = subprocess.run(CMD + ["--datadir", DATADIR, "--printer-profile", PRINTER, "--print-profile", PRINT,
                                  "--material-profile", MATERIAL, "--threads", "1", "--export-gcode",
                                  "--output", gcode, stl], capture_output=True, text=True)
        if p.returncode != 0 or not os.path.exists(gcode):
            raise SystemExit(f"PrusaSlicer failed on {t['id']}:\n{(p.stdout + p.stderr)[-800:]}")
        meta = {}
        for line in open(gcode, errors="replace"):
            m = re.match(r"; (filament used \[cm3\]|estimated printing time \(normal mode\)) = (.*)", line)
            if m:
                meta[m.group(1)] = m.group(2).strip()
        cm3 = float(meta["filament used [cm3]"])
        g = cm3 * PLA_G_PER_CM3
        rows.append({"task": t["id"], "category": t["category"], "title": t["title"],
                     "print_time": meta["estimated printing time (normal mode)"],
                     "hours": round(hms(meta["estimated printing time (normal mode)"]), 2),
                     "filament_cm3": round(cm3, 1), "filament_g": round(g, 1),
                     "cost_usd": round(g / 1000 * PLA_USD_PER_KG, 2)})
        os.remove(gcode)
        print(f"{t['id']:26s} {rows[-1]['print_time']:>12s} {g:7.1f} g")
    path = os.path.join(ROOT, "figures", "print_estimates.csv")
    with open(path, "w", newline="") as fh:
        w = csv.DictWriter(fh, fieldnames=list(rows[0]))
        w.writeheader()
        w.writerows(rows)
    print(f"total {sum(r['hours'] for r in rows):.1f} h, {sum(r['filament_g'] for r in rows):.0f} g, "
          f"US${sum(r['cost_usd'] for r in rows):.2f} -> {path}")


if __name__ == "__main__":
    main()
