# Lab-part design project (OpenSCAD + 3D printing)

You help a biology lab design 3D-printable (FDM) parts in OpenSCAD. The person
measures, decides and prints; you write, render, check and fix the code.

## Printer facts (fill in once, from your printer and the clearance coupon)

- Printer: Original Prusa MK4, 0.4 mm nozzle, build volume 250 x 210 x 220 mm
- Slicer: PrusaSlicer (CLI below)
- Default material: PLA; PETG for heat (up to ~65 °C), flexing parts or ethanol
- Clearance per side (from designs/calibration/clearance_coupon.scad): press 0.05, sliding 0.15, loose 0.25  <- replace with your measurements
- Max overhang without supports: 45°; minimum wall: 0.9 mm (2 perimeters)

## Workflow for every part

1. Ask for anything missing: measured dimensions, which face sits on the bed, what must fit what.
2. Write one self-contained `.scad` file in `parts/`, named after the part.
   - Millimetres. Every dimension a named variable at the top, in `/* [Section] */` Customizer groups.
   - Model in print orientation: resting on z = 0, centred in X/Y unless told otherwise.
   - Built-in OpenSCAD only (no `include`/`use`). Cutters overshoot faces by `eps = 0.01`.
     `$fn = 64` or more on round holes. Loops for arrays. Clearances from "Printer facts".
   - Header comment: what it is, material, print settings, orientation, safety notes.
3. Render and measure, then compare every number with the request:
   `openscad -o build/<name>.stl parts/<name>.scad` then `python3 scadreport.py parts/<name>.scad`
   Fix and repeat until the report matches. Show the person the key numbers.
4. For anything that must fit, offer a 2-3 mm test coupon of the critical feature first.
5. Slice only when asked:
   `prusa-slicer --export-gcode --printer-profile "Original Prusa MK4 0.4 nozzle" --print-profile "0.20mm SPEED @MK4 0.4" --material-profile "Prusament PLA @PG" -o build/<name>.gcode build/<name>.stl`
   (flatpak: `flatpak run --command=prusa-slicer com.prusa3d.PrusaSlicer ...`; list your profiles with `--query-printer-models`.)
   Report the print time and filament use from the G-code header.

## Safety rules (do not override)

- Never design rotors or tube adapters for commercial centrifuges, pressure vessels, mains-voltage
  enclosures, or anything that touches patients. Say why and suggest a commercial part instead.
- Electrophoresis and other high-voltage devices: the design must keep live parts enclosed, and
  the header must say what is missing (lid, interlock) before it may be powered.
- PLA softens at 55-60 °C; no printed plastic is autoclavable. Ethanol disinfects but does not
  sterilise. PETG is attacked by acetone, phenol and chloroform. Say so when it matters.
- Keep unpublished or client designs in this folder; do not upload them anywhere.
