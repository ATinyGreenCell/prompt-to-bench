# HO-16: a held-out task set for Prompt-to-Bench

Sixteen more biology-lab parts, built 20 October 2026 with the same schema, the same unmodified checker
(`bench/checks.py`) and the same validation discipline as the 16 benchmark tasks. They exist to test the
methods developed after the main study (prompts, harnesses, fine-tunes, small-model interventions) on parts
that nobody tuned those methods on.

**Status: unblinded on 21 October 2026.** Until then the set was blind: the assistant that develops methods
did not read this folder, `tasks.yaml`, the references or the mutants, ran the frozen harness copy in `harness/`
and saw only scores. After the pre-registered R4 tests had run, the project lead opened the per-task results
(`bench/smallmodels/PROTOCOL.md`, "Unblinding the held-out set"; paper §6.7). The set can no longer test a method
designed after that date: a new method needs a fresh blind set. The build session was a sub-agent; the repo's build-log hook skips sub-agent
transcripts, so none of this content went into `meta/BUILD_LOG.md`.

## Contents

| Path | What it is |
|---|---|
| `tasks.yaml` | the 16 prompts and their hidden checks (same schema as `bench/tasks.yaml`; `reference` paths are relative to the repo root) |
| `reference/<id>.scad` | the answer keys: exactly the part each prompt describes |
| `reference_stats.json` | reference volumes, slice areas and design-frame centres (generated with `--write`) |
| `mutants/<id>__<what is wrong>.scad` | 97 known-wrong parts; each must fail its task |
| `variants/<id>__<what differs>.scad` | 25 known-right alternatives (at least one per task); each must pass its task |
| `build_refs_heldout.py` | the validator: a copy of `bench/build_refs.py` pointed at this folder, with a wider cross-task test |
| `harness/` | a runnable copy of the harness with these tasks in place of the original 16 (see below) |
| `FROZEN.sha256` | sha256 of the task files (tasks, references, statistics, mutants, variants, validator), paths relative to the repo root |
| `harness/HARNESS.sha256` | sha256 of every file in the harness copy except run outputs (`results/`) and bytecode caches, as in the October 14 sweep harness; paths relative to the repo root |

## The 16 tasks

The parts are the project lead's list (three of them added for diversity). The five tube holders each
use a different construction and use, and none is a flat rectangular grid rack. Render times are for the
reference on this laptop (OpenSCAD 2026.10.01 nightly, Manifold), under `nice -n 15` while benchmark jobs ran.

| # | id | category | the part | construction | checks (top level / items) | mutants | variants | render |
|---|---|---|---|---|---|---|---|---|
| 1 | `pcr_strip_magnet_rack` | tools | magnetic bead rack for an 8-tube PCR strip | block, cone-bottomed blind seats, magnet pockets open at the bottom | 12 / 21 | 7 | 2 | 0.67 s |
| 2 | `cuvette_rack_2x6` | benchware | open-sided rack for 12 square cuvettes | two plates joined by 7 walls, square through-holes, open sides | 13 / 21 | 6 | 3 | 0.56 s |
| 3 | `petri_dish_rack_upright` | benchware | upright rack for ten 90 mm Petri dishes | cylindrical cradle cut + 11 thin dividers | 13 / 20 | 6 | 2 | 0.57 s |
| 4 | `syringe_holder_10ml` | hardware | wall holder for a 10 mL syringe | open-fronted U channel, flange slot from the front, holes through the side | 11 / 13 | 6 | 1 | 0.53 s |
| 5 | `eyepiece_phone_adapter` | hardware | phone adapter for a 30 mm eyepiece | plate + off-centre stepped sleeve + 3 radial holes | 13 / 28 | 6 | 1 | 0.60 s |
| 6 | `shelf_pipette_holder` | quick-fixes | shelf-edge clamp for 3 pipettes | 2-D C-clamp profile printed on its side, holes across the extrusion | 12 / 14 | 6 | 1 | 0.59 s |
| 7 | `waterbath_float_15ml` | tools | water-bath float, 6 tubes around 1 | hexagon, polar holes, thin sleeves and an inset skirt, printed inverted | 10 / 18 | 7 | 1 | 0.57 s |
| 8 | `tubing_manifold_1to3` | hardware | 1-to-3 tubing manifold | block with internal channels, sockets, closed channel end | 10 / 16 | 6 | 2 | 0.60 s |
| 9 | `microtube_balance_stand` | quick-fixes | balance stand for one 1.5 mL tube | revolved profile, conical seat, side window | 12 / 26 | 6 | 1 | 0.59 s |
| 10 | `roundbottom_tube_puck_2ml` | benchware | holder for eight 2 mL round-bottom tubes | round puck with a label flat, half-sphere seat bottoms on a circle | 11 / 19 | 5 | 2 | 0.66 s |
| 11 | `conical_15ml_incline_rack` | benchware | rack holding five 15 mL tubes at a 30-degree lean | block with tilted blind holes | 9 / 17 | 6 | 2 | 0.58 s |
| 12 | `conical_50ml_carrier` | hardware | carrier with a handle for four 50 mL tubes | two parts on one bed: base with seats and posts, separate handle bar | 13 / 23 | 6 | 1 | 0.59 s |
| 13 | `pcr_strip_ice_hanger` | quick-fixes | ice-bucket hanger for a PCR strip | extruded upside-down U over the bucket wall, ledge with holes | 12 / 21 | 6 | 2 | 0.54 s |
| 14 | `hockey_stick_spreader` | tools | L-shaped cell spreader | flat part, bar rotated 120 degrees, two thicknesses, boss | 8 / 14 | 6 | 1 | 0.57 s |
| 15 | `cell_strainer_50ml` | tools | coarse strainer insert for a 50 mL tube | thin revolved cup, 81-hole perforated floor, 45-degree collar, vents | 12 / 25 | 6 | 2 | 0.60 s |
| 16 | `tubing_pinch_clamp` | quick-fixes | pinch clamp with living hinge and latch | 2-D profile with a 0.8 mm flexure and a snap latch | 10 / 12 | 6 | 1 | 0.52 s |

"Items" counts what the checker scores: one slice check expands into several items (islands, holes, sizes, positions).
Top-level checks over all 16 tasks: 16 bbox, 16 bodies, 1 body_sizes, 82 slices, 29 probe sets, 12 lines,
2 arcs, 7 bores, 16 volumes. Every check type the checker has is used, and every part renders in under a second.

### Tube holders: five different constructions and uses

| holder | use | construction |
|---|---|---|
| 1.5 mL (`microtube_balance_stand`) | weighing one tube on a balance | revolved stand with a conical seat and a viewing window |
| 2 mL round-bottom (`roundbottom_tube_puck_2ml`) | keeping round-bottom tubes upright for bead loading | round puck, half-sphere-bottomed seats on a circle, label flat |
| 15 mL (`conical_15ml_incline_rack`) | reading volumes, pipetting supernatant | block with holes tilted 30 degrees |
| 50 mL (`conical_50ml_carrier`) | carrying tubes around the lab | two-part carrier: seats, tall posts and a separate handle bar |
| 0.2 mL (`pcr_strip_ice_hanger`) | keeping a PCR strip in ice | hook over the ice-bucket wall with a perforated ledge |

## Disjointness

* **Not a seed family** (`finetune/seeds/*.scad`) and **not a distilled family** (the `family` field in
  `finetune/rft/distill/prompts_clean*.jsonl`, 45 families; the v3 families of `gen_prompts.py` were
  avoided as well). Where a part's name came close, the construction was chosen to stay out of the family:
  * the cuvette rack is a two-plate frame, not a block with pockets (`cuvette_stand`, `box_divider`);
  * the syringe holder hangs a syringe vertically from a wall, not a pump end block (`syringe_end_block`)
    or a block with a half-round channel along its top (`groove_block`, `pipe_saddle_clamp`);
  * the Petri rack holds dishes on edge in a curved cradle, not a mat with recesses (`petri_recess_plate`)
    or a block with slots in its top (the slide rack);
  * the pipette holder is a shelf clamp, not a horizontal cradle (`pipette_cradle`);
  * the manifold has an inlet on the end face, a closed main channel and side outlets, with no straight
    through-bore (`syringe_end_block`, `tee_pipe`);
  * the 0.2 mL holder hooks over a wall; a two-step rack was rejected as too close to `stair_block`.
* **Not a variant of the 16 tasks.** The magnet rack has 8 cone-bottomed blind seats and magnet pockets,
  not the 96-hole SBS rack; the 50 mL carrier is a two-part tote, not the inverted plate rack.
* **Wording.** Token Jaccard (the measure `gen_prompts_clean.py` used to gate its training data at 0.40),
  maximum per task: against the 16 benchmark prompts 0.23-0.37, against the 2,403 distinct distillation
  prompts 0.26-0.39, against the other held-out prompts 0.25-0.35. That is the "same style, different part"
  band (0.25-0.40). No prompt shares a task's dimensions.
* **Prompt length.** 119-192 words (mean 155), within the range of the 16 tasks' prompts (76-193, mean 121); these parts
  carry more features on average.

## The tasks in detail

Coordinates below are those of the prompt (the design frame). "Edge probes" sit 0.3 mm inside and
outside a feature's edge, as in the October 14 audit; "brackets" are two slices 0.6 mm either side of a
height the prompt states.

### 1. `pcr_strip_magnet_rack` (tools)
Block 80 x 24 x 20 mm; 8 seats at 9 mm pitch on y = 0, each a 6.4 mm hole from the top down to z = 12, then
a cone to 3 mm at z = 2 (2 mm floor); two pockets 60.4 x 3.3 x 10.2 mm for 60 x 10 x 3 mm N52 bar magnets
at y = +-6, open at the bottom face.
* Checks: size; one body; seats (8, 6.4 mm, 9 mm pitch) at z = 16; at z = 7 all ten holes by shape
  (cone 4.7 mm, pockets 60.4 x 3.3) and position; the cone again low down (3.51 mm at z = 3.5); brackets for
  the seat floor (z = 2) and the pocket top (z = 10.2); vertical rays up the pockets (open at the bottom, no
  skin); edge probes on the pocket faces and ends; volume.
* Mutants: seats straight through; flat-bottomed seats; pockets cut from the top; pockets at y = +-7;
  pockets sealed by a 0.6 mm skin; pockets 8.2 mm tall; 9.5 mm pitch.
* Re-coded variant: the same part coded independently, built from a corner and moved, with revolved seats.
* Variant: cutters that end exactly at the faces (floating-point skins).

### 2. `cuvette_rack_2x6` (benchware)
Base plate 112 x 44 x 3 and deck 112 x 44 at z = 22-25, joined by two 3 mm end walls and five 2.5 mm ribs
at x = -36, -18, 0, 18, 36 (full depth, full height); front and back open; 12 square 13 mm holes in the
deck, 2 x 6 at 18 mm. The deck bridges only 15.5 mm between walls, so it prints without supports.
* Checks: size; one body; deck holes (12, square 13 x 13 by rectangle and by area, so round holes fail;
  2 x 6 grid at 18 mm); the seven walls as 44 x 3 / 44 x 2.5 rectangles at mid-height, and a line counting
  them; brackets for the base top and deck bottom; probes at rib and end-wall faces and in the open front
  and back; edge probes of one hole, which also reject squares rotated 45 degrees; volume.
* Mutants: 12.5 mm holes; round 13 mm holes; front and back closed; no ribs; 17 mm pitch; deck at z = 18.
* Re-coded variant: the same part coded independently, with one extruded side profile.
* Variants: 0.5 mm lead-in chamfers on the holes; hole cutters exactly as thick as the deck.

### 3. `petri_dish_rack_upright` (benchware)
Base 203 x 80 x 20 with a cradle cut along X (cylinder r = 46 mm, axis at y = 0, z = 52, so the bottom is
at z = 6); eleven solid 3 mm dividers, full width, z = 0-60, at x = -100 ... 100 every 20 mm (ten 17 mm
slots).
* Checks: size; one body; the 11 dividers as 80 x 3 islands and by a line; at z = 16 and z = 19 the ten
  slot sections as rectangles (cradle width x 17 mm), which fixes the cradle's radius and height, and their
  positions; brackets for the cradle bottom and base top; divider-face probes; probes showing the
  dividers fill the cradle; volume.
* Mutants: 10 dividers (9 slots); a flat floor; cradle radius 45; 2 mm dividers; cradle cut through the
  dividers; dividers 50 mm tall.
* Re-coded variant: the same part coded independently, with an extruded end profile.
* Variant: a coarser cradle cylinder ($fn = 64).

### 4. `syringe_holder_10ml` (hardware)
Block 50 x 30 x 40 (back face y = 15 on the wall); a vertical 16.5 mm U channel (half-circle r = 8.25 at the
origin, straight sides to the front face); a flange slot 34 mm wide and 2.6 mm tall (z = 30-32.6) cut in
from the front back to y = 11; two 4.5 mm M4 holes front to back at x = +-19, z = 15.
* Checks: size; one body; mid-height section area; lines across and along the channel (wall widths);
  probes for the half-circle back (a square-backed channel fails), the straight sides and the open front;
  rays up the channel; flange-slot probes (width, depth, height); the screw holes split the z = 15
  section in three (they run right through) plus edge probes; volume.
* Mutants: a closed round channel; slot cut into the top face; slot 1.6 mm tall; no screw holes; a
  14 mm channel; slot only back to y = 6.
* Re-coded variant: the same part coded independently, with a hull() channel.

### 5. `eyepiece_phone_adapter` (hardware)
Plate 80 x 60 x 3; 12 mm camera hole at (-20, 10); a sleeve 36.6 mm OD from z = 3 to 31 on that axis with
a stepped bore (22 mm from z = 3 to 11, then 30.6 mm); three radial 2.5 mm M3 holes at z = 21, 120 degrees
apart, the first toward +X.
* Checks: size; one body; camera hole size and position; sleeve outside and bore at three heights, with
  positions; brackets on the step at z = 11; the z = 21 section broken into three, an arc counting three
  gaps, and probes on the hole axes and edges (first hole at +X, then every 120 degrees); a ray up the optical axis;
  volume.
* Mutants: hole and sleeve at the plate centre; 29.6 mm bore; no stop; four radial holes; radial holes
  at z = 14; 2 mm sleeve wall.
* Re-coded variant: the same part coded independently, with two stacked tubes.

### 6. `shelf_pipette_holder` (quick-fixes)
Printed on its side: an XY profile extruded 105 mm along Z; spine x 0-5, y 0-28.4; bottom jaw x -25..5,
y 0-5; top jaw and arm x -25..65, y 23.4-28.4 (an 18.4 mm gap for an 18 mm shelf); three 20 mm holes through
the arm along Y at x = 42, z = 17.5 / 52.5 / 87.5.
* Checks: size (tolerance 0.3 mm: the clearance gap sets the overall height); one body; profile area;
  each hole splits the arm at its height; lines measuring the jaws, the bottom jaw's length and the arm's
  reach; gap edge probes; edge probes round all three holes; volume.
* Mutants: an 18 mm gap (no clearance); a 16 mm gap; 15 mm holes; two holes; no bottom jaw (a hook);
  holes at x = 32.
* Re-coded variant: the same part coded independently, with cubes instead of a 2-D profile.

### 7. `waterbath_float_15ml` (tools)
Printed upside down: a regular hexagon plate 90 mm across the flats (flats parallel to X), 3 mm thick;
seven 17.5 mm through-holes (centre plus six on a 54 mm circle, first on +X); sleeves 21.5 mm OD rising to
z = 20; a hexagonal skirt with a 2 mm wall, 84 mm across the flats outside (3 mm in from the plate edge),
to z = 20. Flipped, skirt and sleeves trap air, so it floats whatever the infill.
* Checks: size; one body; holes (7, 17.5 mm, positions) and plate area at z = 1.5; probes that tell a
  hexagon from a disc or a rectangle; at z = 12 the skirt and seven sleeves as islands and their bores as
  holes, by size and position; skirt-inset probes; plate bracket; rays through all seven holes; volume.
* Mutants: no sleeves; a round float; holes on a 60 mm circle; no centre hole; the plate left undrilled;
  hexagon 90 mm across the corners; skirt flush with the plate edge.
* Re-coded variant: the same part coded independently, with a union of extruded hexagons and cylinders.
* Design note: the first version had the skirt flush with the plate edge. Two of five natural codings of
  that (linear_extrude of circle($fn = 6) shapes, unioned) export from OpenSCAD with sliver triangles: the
  checker of that day counted 7-20 bodies and no volume, so a correct answer would fail. Insetting the skirt
  by 3 mm removes the coplanar faces; all four codings of the final design tried pass. The checker has since
  been fixed for this artefact (see the changelog), and the inset skirt is kept.

### 8. `tubing_manifold_1to3` (hardware)
Block 60 x 24 x 16; 3 mm channels in the plane z = 8; a 4.2 mm inlet socket 8 mm deep in the -X face at
y = 0; the main channel along X to x = 15, closed there; three outlets at x = -15, 0, 15 to the +Y face, each
ending in a 4.2 mm socket 6 mm deep; two vertical 3.4 mm M3 holes at (+-25, -6).
* Checks: size; one body (an outlet that does not reach the face leaves a sealed cavity); the screw holes
  at two heights; the channel network cuts the mid-plane into exactly 4 pieces; probes for the channel
  diameter, the closed end, the open inlet, both socket diameters and depths, and all three outlets; rays
  through the screw holes; volume.
* Mutants: main channel through to the +X face; blind outlets; two outlets; 2 mm channels; no sockets;
  channels at z = 6.
* Re-coded variant: the same part coded independently, with a centred cube with rotated cutters.
* Variant: the main channel ends in a drill-like hemisphere.

### 9. `microtube_balance_stand` (quick-fixes)
Revolved: base disc 50 mm (z 0-4), a cone 50 to 22 mm (z 4-14), a 22 mm column to z = 33; seat 11 mm from the
top down to z = 23, then a cone to 3 mm at z = 6, solid below; a 4 mm window through the +X wall,
z = 18-30.
* Checks: size; one body; outside diameter at four heights (disc, cone twice, column); the seat diameter
  at four heights (cone and cylinder) and the seat-bottom bracket; probes for the seat beside the window;
  window probes (width, top, bottom, and no window on the other sides); volume.
* Mutants: a flat-bottomed seat; no window; a window through both walls; a hole through the bottom; a
  40 mm base; an 8 mm window.
* Re-coded variant: the same part coded independently, with stacked scaled extrusions.

### 10. `roundbottom_tube_puck_2ml` (benchware)
Puck 80 mm across, 26 mm tall, cut flat at x = 34; eight seats on a 50 mm circle (first on +X), 11.2 mm
with half-sphere bottoms, lowest point at z = 6.
* Checks: size (the flat shows in X); one body; section area and roundness/flat probes; seats (8,
  11.2 mm, positions) at z = 20 and 12; the half-sphere at z = 8 and 6.8 (a flat or 90-degree conical
  bottom fails); bracket on the lowest point; volume.
* Mutants: flat-bottomed seats; conical seats; a 56 mm seat circle; no flat; seats 14 mm deep.
* Re-coded variant: the same part coded independently, with hull() seats.
* Variant: coarse seat spheres and cylinders ($fn = 24).

### 11. `conical_15ml_incline_rack` (benchware)
Block 130 x 60 x 45; five 17.5 mm blind holes 24 mm apart, each 40 mm deep along its axis with a flat end
square to the axis; the axes meet the top face at y = -10 and tilt 30 degrees from vertical, moving toward
+Y going down.
* Checks: size; one body; at z = 40 and z = 20 five elliptical sections 20.21 x 17.5 (which also fixes the
  diameter square to the axis) at the positions the tilt predicts, plus the positions near the top; the
  deepest point by bracket; probes on the axis just before and after the flat end of three holes; volume.
* Mutants: vertical holes; 45-degree tilt; sheared (oblique) cylinders whose horizontal sections are
  17.5 mm circles, only 15.2 mm across square to the axis; holes through the bottom; axes entering at
  y = 0; 22 mm pitch.
* Re-coded variant: the same part coded independently, with holes placed by their bottom centres.
* Variant: $fn = 48 holes.

### 12. `conical_50ml_carrier` (hardware)
Two parts. Base 90 x 90 x 35 with four 30.5 mm seats 30 mm deep at (+-21, +-24); two posts 10 x 16 flush with
the X ends, centred on y = 0, rising to z = 160, each with a square 10.4 mm hole along X at z = 150. Handle:
a 10 x 10 x 100 bar lying beside the base at y = 55-65.
* Checks: two bodies and their sizes; overall size; seat floor bracket and seat size and positions; base
  top bracket; the posts as 16 x 10 islands; post positions (flush); the square holes, including
  corner probes that fail round holes; the bar's position and height; volume.
* Mutants: handle printed in place (one body); 8 mm bar; seats through the floor; round handle holes;
  posts 5 mm in from the ends; seats on a 40 mm square.
* Re-coded variant: the same part coded independently, with centred cubes.

### 13. `pcr_strip_ice_hanger` (quick-fixes)
YZ profile extruded 84 mm along X: inner leg y 0-4, outer leg y 16.5-20.5, both z 0-50, bridge z 46-50
(12.5 mm gap for a 12 mm bucket wall); a 6 mm ledge from the inner leg's foot to y = -30; eight 6.4 mm holes
in the ledge at 9 mm pitch, y = -15.
* Checks: size; one body; holes (8, 6.4 mm, 9 mm pitch, y = -15) and the ledge and leg as rectangles at
  z = 3; the two legs at mid-height; wall-gap edge probes; the bridge; brackets for the ledge top and
  bridge bottom; rays through the holes; volume.
* Mutants: a 10 mm gap; a 12 mm gap (no clearance); 8.5 mm pitch; seven holes; the ledge at the top;
  40 mm legs.
* Re-coded variant: the same part coded independently, with a single polygon profile.
* Variant: the ledge on the other leg (the mirror image, which hangs the same way).

### 14. `hockey_stick_spreader` (tools)
Handle 150 x 6 x 4 (x 0-150, y +-3); foot 40 x 5 x 2.5 whose centre line starts at the origin at 120 degrees
from +X; a 6 mm boss 4 mm tall at the origin; a 4 mm hanging hole at x = 143.
* Checks: size; one body; lower section (area, hole size and position); upper section (only handle and boss
  reach 4 mm); lines measuring the handle and foot widths; probes along the foot's centre line, at its
  edges, its end, its thickness and the boss; volume.
* Mutants: foot at 90 degrees; at 135 degrees; foot 4 mm thick; no hanging hole; foot 30 mm long; foot
  4 mm wide.
* Re-coded variant: the same part coded independently, with a polygon foot.

### 15. `cell_strainer_50ml` (tools)
Revolved cup 25 mm OD, 1.2 mm wall, z 0-32, 1.2 mm floor; a 45-degree collar from 25 mm at z = 26 to 33 mm at
z = 30 and a 33 mm rim to z = 32; 81 holes of 1.0 mm on a 2 mm X/Y grid within 10 mm of the axis; two 3 mm
vent notches on +-X removing the collar beyond 12.5 mm from z = 25 up.
* Checks: size (the vents trim the rim's X extent); one body; floor: all 81 holes by size and position,
  round outline; floor bracket; wall (outside and bore) at three heights; collar and rim probes; an arc
  counting the two vents and vent probes (width, depth through the collar, cup wall intact); rays through
  floor holes; volume.
* Mutants: 1.5 mm holes; solid floor; a flat flange instead of the cone; a 2 mm wall; no vents; a 2.5 mm
  grid (49 holes).
* Re-coded variant: the same part coded independently, with stacked scaled extrusions.
* Variant: 1 mm holes at OpenSCAD's default resolution (pentagons). They must pass because models often
  leave $fn unset on small holes.
* Note for printing: this is a coarse (1 mm) sieve for tissue debris, not a 40-100 um cell strainer.

### 16. `tubing_pinch_clamp` (quick-fixes)
Flat profile extruded 8 mm: lower jaw x 0-50, y 0-4 with a thin tongue x 50-56, y 2.5-4; upper jaw x 0-60,
y 12-16; a 0.8 mm half-ring hinge centred at (0, 8), radii 7.2/8, on x < 0; half-round 1.5 mm ridges at
x = 27.5 on both inner faces; a latch leg x 57-60, y 4.5-12 with a nose x 54.5-57, y 4.5-5.5, 0.5 mm above
the tongue. Squeezed, the hinge flexes and the nose snaps under the tongue. Print in PETG or PP.
* Checks: size; one body; profile area; two lines measuring the hinge thickness; a line measuring both
  jaws; gap and hinge probes; ridge probes; tongue, nose (including the 0.5 mm clearance) and leg probes;
  volume.
* Mutants: a 2 mm hinge; no ridges; latch fused to the tongue; no hinge (two parts); ridges at x = 20;
  no tongue.
* Re-coded variant: the same part coded independently, with polygons and a cut ring.

## Validation

`build_refs_heldout.py` (run under `nice -n 15`, renders one at a time, meshes in a temporary folder that
is deleted afterwards):

| step | passed | failed |
|---|---:|---:|
| references pass their own checks | 16 | 0 |
| invariance (rotated 90 deg, mirrored, moved) | 16 | 0 |
| references scaled by 3 % fail | 16 | 0 |
| held-out reference vs every other held-out task: fails | 240 | 0 |
| held-out reference vs each of the 16 original tasks: fails | 256 | 0 |
| original reference (`bench/reference/`) vs each held-out task: fails | 256 | 0 |
| mutants fail | 97 | 0 |
| variants pass | 25 | 0 |

Two further checks, not part of the validator:

* **Independent re-codings.** For every task I wrote at least one more correct file in a different
  OpenSCAD style: stacked cylinders vs. linear_extrude vs. rotate_extrude, union of cubes vs. a 2-D profile,
  hull(), polygon(), corner-origin then moved, other $fn. All 26 rendered watertight and passed, and one
  per task is kept in `variants/` (`<id>__recoded_*`), so the validator re-checks them. This is how the
  float problem above was found and fixed.
* **The validator in frozen mode** (without `--write`) reproduces `reference_stats.json` within 1e-3.

## Running models on the held-out set

```bash
cd ~/printpaper
.venv/bin/python -I bench/heldout/harness/bench/run_bench.py --run <name> --models <model> [--samples 8]
.venv/bin/python -I bench/heldout/harness/bench/sample_stats.py <name>     # per-task pass statistics
```

* The copy holds `run_bench.py`, `checks.py`, `rescore.py`, `sample_stats.py`, `prompts/`, the
  method-model plugins it imports for `template:` and `features:` models (`smallmodels/plugins.py`,
  `common.py`, `templates/{backend,library}.py`, `features/{fbackend,compiler}.py`, a snapshot of the working
  tree; the template library reads `finetune/seeds/` by absolute path) and `tools/scadreport.py`, all byte-identical to the
  repo's working tree on 20 October 2026 (`HARNESS_COMMIT`). `tools/scadreport.py` was later replaced by the
  released checker with the sliver clean-up (v0.3.1, see the changelog). The held-out `tasks.yaml`,
  `reference_stats.json` and `reference/` replace the originals. `results/` holds the Opus ceiling check and the R4 runs (changelog).
* Results go to `bench/heldout/harness/bench/results/<run>/`. Method code tested later on this set should be
  copied into the harness and recorded with a fresh `HARNESS.sha256`; the task files stay frozen
  (`FROZEN.sha256`).
* The copy's `tasks.yaml` is identical to `bench/heldout/tasks.yaml`. Its `reference` fields point at
  `bench/heldout/reference/` relative to the repo root, which `run_bench.py` does not use.
* No model was called while building this set. The models run on it since are the Opus ceiling check and the
  R4 runs (changelog).

## Known limits and weaker checks

* **Volume checks are coarse (5-6 %).** They mostly catch gross extra or missing material. On the
  manifold the channels are too small to move the volume; probes check them instead.
* **Petri-rack cradle.** The radius is checked indirectly, from slot widths at two heights. A radius off by
  less than about a millimetre, with a compensating axis height, could pass.
* **Shelf-clamp clearance.** The 0.4 mm clearance is protected by a tight overall-size tolerance and edge
  probes. A part that shrinks the gap and thickens both jaws by the same total keeps the overall size and
  could pass.
* **Strainer holes.** The hole-diameter tolerance is wide relative to a 1 mm hole, to accept coarse polygons.
  Holes moderately over or under size pass; 1.5 mm holes fail.
* **Manifold channels.** Continuity is sampled by probes and by the mid-plane section's topology, not traced
  along each channel.
* **Symmetric parts.** The magnet pockets, the posts of the carrier and the hanger are mirror-symmetric, so
  the checker cannot (and need not) tell which way round they were modelled.
* **Bounding-box centring.** As in the main set, candidates are centred on their bounding box. A
  symmetric size error therefore splits between both edges, which is why clearance features use tight size
  tolerances or two-sided probes.
* **Not print-tested.** The parts are geometry-checked only. Fits (cuvette and tube clearances, the clamp
  latch, the float's buoyancy) follow common practice and the stated consumable sizes. They have not been
  printed and tried.

## Changelog

### 2026-10-20: initial build
The 16 tasks, references, 97 mutants, 25 variants, the validator and the harness copy, as described above.
Validation was clean on every step.

### 2026-10-20: checker fix, re-validation and Opus ceiling check (approved by Seb: "All 4")
1. **Checker fix in the harness copy.** `harness/tools/scadreport.py` was replaced by the repo's released
   checker (v0.3.1; sha256 `8c75e03461083a01373687b0152c981b1309a756d3ca2eb7f699dbd604afb283`). `load_mesh` now
   cleans a mesh that is not watertight: it merges vertices that round together at 1e-5 mm and drops zero-area
   faces and unreferenced vertices. A watertight mesh is never touched. Against the old copy the diff is that
   block only; a second copy took a comment change in it (pointing at `meta/audits/2026-10-20_v0.3.1.md`), with
   the code unchanged. `build_refs_heldout.py` imports `load_mesh` from the repo's `tools/scadreport.py`, the
   same function, so it was not changed.
2. **Re-validation** in frozen-statistics mode (renders one at a time under `nice -n 15`), run with the
   fixed checker and again with the released file. Every step passes with the same counts as before: own
   16 / 0, invariance 16 / 0, scaled 16 / 0, cross-task 240 / 0, 256 / 0 and 256 / 0, mutants 97 / 0, variants
   25 / 0. `reference_stats.json` is unchanged (sha256
   `723f567a49c758394144e3de86fd94ff1cb977e40e7d2974e32118150cbead00`). All references and variants are
   watertight, so the clean-up never touches them. No mutant passes; the only non-watertight one (the float's
   flush skirt) still fails on its geometry.
   * **Flush-face test.** The three correct codings of the first float design that had failed (20, 7 and 7
     sliver "bodies") now load watertight and pass that design's checks: 3 of 3. The final design's inset
     skirt is kept.
3. **Opus ceiling check** in the harness copy: `bench/run_bench.py --run ceiling-opus --models
   claude:claude-opus-5-5 --samples 1 --max-repairs 6`, the arguments of the original set's ceiling run.
   Results are in `harness/bench/results/ceiling-opus/`. Claude Opus 5.5 passed all 16 tasks on the first
   attempt (16 of 16 within all attempts too), and no file used a library.
   * No task needed review, so none was classified as a task problem (a) or a model error (b), none was
     changed, and no follow-up run (`ceiling-opus-2`) was needed.
   * The run was started with `OLLAMA_HOST` pointed at a closed local port. Its arguments were unchanged.
     `run_bench.py`'s metadata step asks the Ollama server for its version whenever `openscad` is on the PATH,
     and the server was busy with other jobs. The run's meta file therefore records no Ollama version, which is
     irrelevant for a Claude run.

   | task | first attempt | attempts | time | code lines | output tokens |
   |---|---|---:|---:|---:|---:|
   | `pcr_strip_magnet_rack` | yes | 1 | 13 s | 53 | 1126 |
   | `cuvette_rack_2x6` | yes | 1 | 13 s | 55 | 1080 |
   | `petri_dish_rack_upright` | yes | 1 | 22 s | 40 | 787 |
   | `syringe_holder_10ml` | yes | 1 | 12 s | 56 | 961 |
   | `eyepiece_phone_adapter` | yes | 1 | 18 s | 62 | 1565 |
   | `shelf_pipette_holder` | yes | 1 | 11 s | 54 | 1037 |
   | `waterbath_float_15ml` | yes | 1 | 17 s | 54 | 1073 |
   | `tubing_manifold_1to3` | yes | 1 | 11 s | 66 | 942 |
   | `microtube_balance_stand` | yes | 1 | 10 s | 47 | 904 |
   | `roundbottom_tube_puck_2ml` | yes | 1 | 9 s | 40 | 663 |
   | `conical_15ml_incline_rack` | yes | 1 | 14 s | 36 | 1151 |
   | `conical_50ml_carrier` | yes | 1 | 13 s | 63 | 1180 |
   | `pcr_strip_ice_hanger` | yes | 1 | 11 s | 47 | 881 |
   | `hockey_stick_spreader` | yes | 1 | 8 s | 44 | 646 |
   | `cell_strainer_50ml` | yes | 1 | 18 s | 72 | 1448 |
   | `tubing_pinch_clamp` | yes | 1 | 24 s | 87 | 1848 |

4. **Manifests.** `harness/HARNESS.sha256` was regenerated because the checker file changed. As in the
   October 14 sweep harness, it covers the copy's files except run outputs (`results/`) and bytecode caches.
   `FROZEN.sha256` is unchanged: none of the files it covers changed.

### 2026-10-20 to 21: the R4 runs
The pre-registered R4 test (`bench/smallmodels/PROTOCOL.md`, "R4 test plan") ran on the frozen harness copy:
Claude Sonnet 5.5 and Haiku 4.5 (`r4-claude`); Qwen2.5-Coder 7B, templates, Gemma 4 E4B and features on the
laptop (`r4-coder7b`, `r4-template`, `r4-gemma4e4b`, `r4-features`); Bonsai 2 27B (`r4-bonsai`); and on the
NPU box Gemma 4 26B with the standard and h4 prompts, Qwen3.8 27B standard and with the syntax fixer live
(three samples each) and Qwen3.6 27B (two samples). `_offline/` holds the free offline what-ifs (the syntax
fixer and the request check on the saved attempts). Results: `PROTOCOL.md`, "R4 results"; paper §6.7 and
Table 15.

### 2026-10-21: unblinded
After the R4 tests had run, Seb approved opening the per-task results ("okay lets do them all"); the analyses
are in `bench/smallmodels/heldout_unblind.py` and `PROTOCOL.md`, "Unblinding the held-out set".

### 2026-10-22: README corrections
The table above gave three top-level check counts one too many or one too few (the magnet rack 13 for 12, the
cuvette rack 14 for 13, the balance stand 11 for 12; the item counts were right), and the mean prompt length
as 154 words (154.9). The frozen files are unchanged.
