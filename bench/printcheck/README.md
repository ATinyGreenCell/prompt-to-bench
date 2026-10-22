# Print and measure: does a part that passes the checks work?

Every result in the paper is a geometry check: a part passes when it matches the request. This set tests the step
after that, on the printer. Ten parts from the held-out tasks ([`bench/heldout/`](../heldout/)), written by models in
the R4 runs, are to be printed on an Original Prusa MK4 and tried with the lab items they were designed for.

- **Group A, open-model passes.** Five parts that Gemma 4 26B wrote on the NPU box and the checker passed. Does a
  pass from an open model give a part that works?
- **Group B, hosted passes.** Two parts from tasks that no open model passed, written by Claude Haiku 4.5 and
  Claude Sonnet 5.5.
- **Group C, near-misses.** Three parts that failed by a little. Two failed on a departure that should not matter in
  use, and one on a departure that should. Do the checker's failures match what happens in use?

The predictions below were written on 2026-10-21, before anything was printed.

## The set

| Part | Task | Written by | Checker | Print time | PLA |
|---|---|---|---|---:|---:|
| A1 | magnetic bead rack for an 8-tube PCR strip | Gemma 4 26B (box), first attempt | pass | 1 h 20 min | 18 g |
| A2 | puck for eight 2 mL round-bottom tubes | Gemma 4 26B (box), first attempt | pass | 2 h 9 min | 42 g |
| A3 | balance stand for one 1.5 mL tube | Gemma 4 26B (box), second attempt | pass | 36 min | 11 g |
| A4 | open-sided rack for twelve 12.5 mm cuvettes | Gemma 4 26B (box, h4 prompt), first attempt | pass | 2 h 23 min | 36 g |
| A5 | hockey-stick cell spreader | Gemma 4 26B (box), first attempt | pass | 16 min | 4 g |
| B1 | coarse strainer insert for a 50 mL tube | Claude Haiku 4.5, first attempt | pass | 26 min | 5 g |
| B2 | wall holder for a 10 mL syringe | Claude Sonnet 5.5, first attempt | pass | 1 h 10 min | 20 g |
| C1 | balance stand for one 1.5 mL tube | Claude Haiku 4.5 | fail: window 6 x 14 mm, asked 4 x 12 | 35 min | 11 g |
| C2 | magnetic bead rack for an 8-tube PCR strip | Gemma 4 26B (box, h4 prompt) | fail: seat cones upside down | 1 h 23 min | 19 g |
| C3 | puck for eight 2 mL round-bottom tubes | Qwen3.6 27B (box) | fail: label flat 1 mm too far out | 2 h 13 min | 42 g |
| | | | | **12.5 h** | **209 g** |

Times and PLA come from PrusaSlicer's stock "0.20mm SPEED @MK4 0.4" profile with Prusament PLA, as in the paper's
Table 1. The sources are in [`scad/`](scad/), copied from the runs' saved attempts
([`estimates.csv`](estimates.csv) gives each file's origin).

## Making the files

```bash
.venv/bin/python bench/printcheck/make_printcheck.py   # copies the sources to scad/ and writes estimates.csv here; STL and G-code go to build/printcheck/
```

The PrusaSlicer flatpak sees only the home folder and removable media, so run this from a checkout under your home
folder (from elsewhere, slicing fails with a misleading "Could not find ... PrusaResearch.ini").

Each part is modelled in its print orientation, so print it as it comes, in PLA, with the stock profile. The
strainer's 1 mm holes are at the limit of a 0.4 mm nozzle. Print it once with the stock profile; if holes close, a
finer profile is a separate, labelled print.

## Predictions

- **A1-A5, B1, B2 work** (the checks passed):
  - A1: an 8-tube PCR strip drops in, all eight tubes at once, and each tube's tip rests in its cone seat.
  - A2: eight 2 mL round-bottom tubes slide in by hand and stand upright.
  - A3: a 1.5 mL tube sits upright in the seat, its lower body shows through the window, and the stand does not tip
    on a balance pan.
  - A4: twelve 12.5 mm cuvettes slide through the deck and stand on the base plate; the front and back are open.
  - A5: the foot meets the handle at 120 degrees, and the foot lies flat on the agar in a 90 mm dish.
  - B1: the cup slides into a 50 mL tube and the collar rests on the rim. Water poured in drains through the floor.
  - B2: a 10 mL syringe slides in from the front and hangs by its finger flange; M4 screws pass the holes.
- **C1 and C3 work anyway.** The window is 2 mm wider and taller than asked, and the puck's label flat is cut 1 mm
  too far out (75 mm across the flat instead of 74). Neither should matter in use. C3's seats are where the request
  puts them: they fail only because the checker centres a part on its bounding box, which the 1 mm flat moves by
  0.5 mm. If they work, the checker failed parts that would have worked: its tolerances are
  stricter than use requires there.
- **C2 does not work.** Its seats narrow upward to a 3 mm neck at z = 12 and widen again below it. Each tube should
  stop on that neck instead of reaching the bottom of the seat, so the strip sits several millimetres higher than
  in A1 (we expect about 5-7 mm).

## What to measure

Calipers to 0.1 mm; nominal values are the request's. Measure holes at the top face.

| Part | Measurements | Use test (pass if) |
|---|---|---|
| A1, C2 | block 80 x 24 x 20; seat 6.4 mm; first-to-last seat centres 63 mm; magnet pockets 60.4 x 3.3 | strip goes in without force; height of the strip's cap hinge above the block (compare A1 and C2); magnets fit, if you have 60 x 10 x 3 mm bars |
| A2, C3 | diameter 80; width across the flat 74 (C3: 75); height 26; seat 11.2 mm | all eight tubes go in by hand and stand upright |
| A3, C1 | base 50; column 22; height 33; seat 11 mm; window width 4 (C1: 6) | the tube stands upright; its lower body shows in the window; the stand is stable on the pan |
| A4 | 112 x 44 x 25; hole 13 x 13; hole pitch 18 | all twelve cuvettes go in and stand upright |
| A5 | handle 150 x 6 x 4; foot 40 x 5 x 2.5; angle 120 degrees (protractor) | the foot lies flat on agar in a 90 mm dish |
| B1 | cup 25 outside; collar 33; floor holes open, of 81 | sits on a 50 mL tube's rim; 5 mL of water drains through |
| B2 | 50 x 30 x 40; channel 16.5 wide; flange slot 34 wide, 2.6 tall | the syringe slides in and hangs by its flange; M4 screws pass |

## Results

To be filled in after printing: date, printer and filament, each measurement, each use test (pass or fail, with a
note), and a photo of each part in use.
