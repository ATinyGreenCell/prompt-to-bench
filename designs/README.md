# Design library

Sixteen parametric OpenSCAD designs for biology labs, which are also the reference solutions of the benchmark. Each file:

- is plain OpenSCAD with no libraries;
- keeps its parameters at the top in Customizer sections, so you can change them in **Window → Customizer** without touching the code;
- is modelled in the orientation it prints in.

Licence: [CERN-OHL-P-2.0](../LICENSES/CERN-OHL-P-2.0.txt), a permissive open-hardware licence.

![The 16 designs](../figures/design_library.png)

| Kind | File | Print notes |
|---|---|---|
| Benchware | [`benchware/tube_rack_1p5ml.scad`](benchware/tube_rack_1p5ml.scad) | PLA/PETG, 15% infill; about 5.4 h |
| Benchware | [`benchware/conical_rack_50ml.scad`](benchware/conical_rack_50ml.scad) | prints upside down, flip after printing; about 4.2 h |
| Benchware | [`benchware/slide_drying_rack.scad`](benchware/slide_drying_rack.scad) | check the slot width with a real slide first |
| Benchware | [`benchware/pcr_tube_rack_sbs.scad`](benchware/pcr_tube_rack_sbs.scad) | ANSI/SLAS microplate footprint; about 8 h |
| Tools | [`tools/gel_comb_10well.scad`](tools/gel_comb_10well.scad) | PETG, 100% infill; the bed side is smoothest |
| Tools | [`tools/micropestle_1p5ml.scad`](tools/micropestle_1p5ml.scad) | print upright, fine layers |
| Tools | [`tools/lab_funnel_60mm.scad`](tools/lab_funnel_60mm.scad) | PETG/PP for chemicals; walls under 45° so no supports |
| Tools | [`tools/seed_sowing_template.scad`](tools/seed_sowing_template.scad) | wipe with 70% ethanol before use |
| Quick fixes | [`quick-fixes/dshaft_knob_6mm.scad`](quick-fixes/dshaft_knob_6mm.scad) | PETG near hotplates; print a coupon of the bore first |
| Quick fixes | [`quick-fixes/pcr_tube_adapter.scad`](quick-fixes/pcr_tube_adapter.scad) | collar on the bed; not for heat blocks in PLA |
| Quick fixes | [`quick-fixes/hose_barb_reducer_8_5.scad`](quick-fixes/hose_barb_reducer_8_5.scad) | low-pressure lines only; leak-test |
| Quick fixes | [`quick-fixes/rod_tubing_clip.scad`](quick-fixes/rod_tubing_clip.scad) | PETG is springier than PLA |
| Full hardware | [`hardware/stirrer_fan_housing.scad`](hardware/stirrer_fan_housing.scad) | 12 V fan and PWM controller only; prints upside down |
| Full hardware | [`hardware/nema17_motor_bracket.scad`](hardware/nema17_motor_bracket.scad) | PETG, 5 perimeters |
| Full hardware | [`hardware/enclosure_box_and_lid.scad`](hardware/enclosure_box_and_lid.scad) | print the lid first to check the 0.2 mm fit |
| Full hardware | [`hardware/mini_gel_tank.scad`](hardware/mini_gel_tank.scad) | **hazardous voltage in use**: closed lid with interlock; leak-test |

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
