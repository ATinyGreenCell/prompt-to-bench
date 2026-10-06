# Design library

Sixteen parametric OpenSCAD designs for biology labs. They started as the benchmark's reference solutions (frozen in [`bench/reference/`](../bench/reference/)) and were then revised for real use after an independent mechanical and biological audit ([`meta/audits/`](../meta/audits/)). They are geometry-checked and sliced; physical print-and-fit validation is in progress. Each file:

- is plain OpenSCAD with no libraries;
- keeps its parameters at the top in Customizer sections, so you can change them in **Window → Customizer** without touching the code;
- is modelled in the orientation it prints in.

Licence: [CERN-OHL-P-2.0](../LICENSES/CERN-OHL-P-2.0.txt), a permissive open-hardware licence.

![The 16 designs](../figures/design_library.png)

| Kind | File | Print notes |
|---|---|---|
| Benchware | [`benchware/tube_rack_1p5ml.scad`](benchware/tube_rack_1p5ml.scad) | 11.6 mm holes (0.4 mm per side); about 5.4 h |
| Benchware | [`benchware/conical_rack_50ml.scad`](benchware/conical_rack_50ml.scad) | prints upside down, flip after printing; 31 mm holes for 30 mm Falcon tubes |
| Benchware | [`benchware/slide_drying_rack.scad`](benchware/slide_drying_rack.scad) | edge-only contact and drain holes; check slot width with a real slide |
| Benchware | [`benchware/pcr_tube_rack_sbs.scad`](benchware/pcr_tube_rack_sbs.scad) | full ANSI/SLAS base footprint; fits plate carriers, not magnet stands or lids; about 8 h |
| Tools | [`tools/gel_comb_10well.scad`](tools/gel_comb_10well.scad) | PETG; set tooth length for your tray; pour agarose at 50-60 °C |
| Tools | [`tools/micropestle_1p5ml.scad`](tools/micropestle_1p5ml.scad) | single use; not for TRIzol/phenol; brim |
| Tools | [`tools/lab_funnel_60mm.scad`](tools/lab_funnel_60mm.scad) | true 1.6 mm wall; PETG for water, buffers, ethanol; brim |
| Tools | [`tools/seed_sowing_template.scad`](tools/seed_sowing_template.scad) | 82 mm disc; use under the dish, or soak and use once |
| Quick fixes | [`quick-fixes/dshaft_knob_6mm.scad`](quick-fixes/dshaft_knob_6mm.scad) | measure the shaft (6 mm or 1/4"); PETG near hotplates |
| Quick fixes | [`quick-fixes/pcr_tube_adapter.scad`](quick-fixes/pcr_tube_adapter.scad) | **racks only - never in a centrifuge**; not for heat blocks |
| Quick fixes | [`quick-fixes/hose_barb_reducer_8_5.scad`](quick-fixes/hose_barb_reducer_8_5.scad) | low-pressure lines only; leak-test |
| Quick fixes | [`quick-fixes/rod_tubing_clip.scad`](quick-fixes/rod_tubing_clip.scad) | measure the rod (12 or 12.7 mm) and the tubing OD; PETG |
| Full hardware | [`hardware/stirrer_fan_housing.scad`](hardware/stirrer_fan_housing.scad) | standoffs clear the magnets; 12 V fan and certified supply only |
| Full hardware | [`hardware/nema17_motor_bracket.scad`](hardware/nema17_motor_bracket.scad) | teardrop motor hole; screw the base down first |
| Full hardware | [`hardware/enclosure_box_and_lid.scad`](hardware/enclosure_box_and_lid.scad) | slip-fit lid (0.1 mm for friction); cable hole; fits an Arduino Nano build |
| Full hardware | [`hardware/mini_gel_tank.scad`](hardware/mini_gel_tank.scad) | **lid and interlock not included - do not power it until built**; leak-test |

Print times are PrusaSlicer estimates for an Original Prusa MK4 (0.20 mm SPEED profile). The full table is in the paper (Table 1) and in [`../figures/print_estimates.csv`](../figures/print_estimates.csv).

## Customising

- **In the GUI:** open the file in OpenSCAD and show **Window → Customizer**. Change values, press F6 to render, then F7 to export the STL.
- **From the command line:**

  ```bash
  openscad -D pitch=18 -D hole_d=11.6 -o rack.stl designs/benchware/tube_rack_1p5ml.scad
  ```

- **Check the result** before printing:

  ```bash
  python tools/scadreport.py designs/benchware/tube_rack_1p5ml.scad
  ```

## Safety

Read §8 of the [paper](../README.md#8-safety-and-responsibility) before using printed parts with heat, chemicals, organisms, spinning machinery or electricity. These designs are provided as-is, without warranty, under the terms of the licence.
