# Mechanical and biological audit of the 16 printpaper designs

Scope: `designs/**/*.scad`, `bench/tasks.yaml`, `designs/README.md`, `tutorial/README.md`, and the safety and material statements in `README.md` (§2, §4, §8). No files were edited. Geometry was checked by reading each file and running `tools/scadreport.py` on all 16 (single renders). Facts were checked against manufacturer data where I could reach it.

Tags: **[ERROR]** means factually wrong, won't fit, or unsafe as written. **[RISK]** means a likely problem that deserves a parameter or note change. **[OK]** is used only where a claim needed checking and held up.

> **Read this before changing any parameter.** Each `.scad` file is also a benchmark reference solution. If you change a dimension, you must also change the matching prompt text and the hidden `checks` in `bench/tasks.yaml`, then rebuild the reference values (`build_refs.py`). Otherwise benchmark scores already computed will no longer match the reference. Note-only fixes (header comments, READMEs, tutorial) are safe to make at any time. Given the benchmark that is running, a reasonable plan is to fix the notes and safety text now, and save the dimension changes for a versioned "v2" design set.

## Key reference data used

| Item | Value | Source |
|---|---|---|
| Eppendorf Safe-Lock 1.5 mL tube | body Ø 10.8 / 10.7 mm, inner Ø 8.7 mm, cylinder ~20 mm, total length 37.8 mm below rim (38.9 mm overall), conical section ≈ 17.8 mm, wall 0.45 mm | [Eppendorf technical drawing](https://www.eppendorf.com/product-media/doc/en/140027_Technical-Data/Eppendorf_Consumables_Technical-data_Safe-Lock-Tube-15-mL_Safe-Lock-15-mL-technical-drawing.pdf) |
| Falcon 50 mL tube (352070) | O.D. 30 mm, length 115 mm | [Corning eCatalog 352070](https://ecatalog.corning.com/life-sciences/b2c/US/en/Liquid-Handling/Tubes,-Liquid-Handling/Centrifuge-Tubes/Falcon%C2%AE-Conical-Centrifuge-Tubes/p/352070) |
| 0.2 mL PCR tube | overall height 20.8 mm, inner Ø at top 5.40 mm, wall 0.29 mm (so OD ≈ 6.0 mm) | [i-labpro PC0201 spec](https://www.i-labpro.com/product/pc0201-f-n/) |
| Microscope slide (ISO 8037-1) | 76 × 26 mm, thickness 1.0 ± 0.05 mm | [Marienfeld](https://www.marienfeld-superior.com/microscope-slides-thickness-approx-1-mm.html), [Semadeni](https://eshop.semadeni.com/en/PRODUCTS/Life-science_-sampling-and-analysis/Microscopy-Accessories/DURAN_-microscope-slides_26x76_mm-1193.html) |
| 90 mm Petri dish | SPL 90 × 15 mm: internal Ø 85.90 mm. Some "90 mm" dishes have an 86 mm *base* OD (lid 90 mm). Glass 90 mm OD dishes: ID 85 mm | [SPL via ProLab](https://prolabcorp.com/spl-petri-dish-90-x-15mm-with-3-vents-lids-crystal-grade-polystyrene-sterile-sleeve-10-case-of-500/), [The Consumables Company](https://www.theconsumablescompany.com/90mm-petri-dish-single-vent-with-lid-polystyrene-ps-aseptic/), [Labnique](https://labnique.com/products/90mm-od-glass-petri-dish-with-lid-pack-of-10) |
| 6 mm D-shaft | Ø 6.0 mm, 4.5 mm flat-to-round, flat 12 mm long (Bourns PDB24 "F" shaft) | [Bourns PDB24](https://www.bourns.com/docs/product-datasheets/PDB24.pdf) |
| Lab stand rods | 12 mm (e.g. Eisco/LABZIO) and 12.7 mm (1/2") are both common | [Eisco rods](https://www.eiscolabs.com/collections/metal-bases-rods), [CP Lab Safety 12.7 mm](https://www.cplabsafety.com/lab-stand-base-with-59cm-long-rod-12-7mm-diameter-22cm/eis-abse12spl) |
| Barb stretch for silicone | 18-34 % over nominal ID | [Nordson Medical barb styles](https://fluid-components.nordsonmedical.com/files/fluid-components-nordsonmedical-com/Technical%20Information/Barb%20Information/barb-styles.pdf) |
| 80 mm fan | 71.5 mm hole pattern (paper cites SUNON); 4.3 mm holes; stock fan screws are 5 mm self-tapping | [Sanyo Denki tapping note](https://products.sanyodenki.com/info/sanace/en/technical_material/tapping.html), [Wikipedia: computer case screws](https://en.wikipedia.org/wiki/Computer_case_screws) |
| Mini agarose gel practice (Bio-Rad Mini-Sub Cell GT manual) | 7 × 7 / 7 × 10 cm gels; Mini-Sub combs 5.54 mm (8-well) or 2.59 mm (15-well) wide, 0.75-1.5 mm thick; pour agarose at 50-60 °C ("Hot agarose (>60 °C) may cause the tray to warp"); comb teeth 1-2 mm above the running surface; gel under 2-6 mm of buffer; Pt electrodes 0.25 mm; lid interlock; max buffer 40 °C | [Bio-Rad Sub-Cell GT manual](https://www.ubi.se/wp-content/uploads/2023/10/Wide-Mini-Sub-Cell-GT-Cell-BioRad.pdf) |
| ANSI/SLAS 1-2004 | 127.76 ± 0.25 × 85.48 ± 0.25 mm within 12.7 mm of the corners; "footprint must be continuous and uninterrupted"; corner radius 3.18 ± 1.6 mm. No chamfer is specified. | [ANSI SLAS 1-2004](https://www.slas.org/SLAS/assets/File/public/standards/ANSI_SLAS_1-2004_FootprintDimensions.pdf) |
| Prusa design guidance | accuracy "to at least 0.2 mm"; moving parts "at least 0.3 mm" | [Prusa KB](https://help.prusa3d.com/article/modeling-with-3d-printing-in-mind_164135) |
| PETG chemical resistance | good with ethanol; poor with acetone, phenol and chlorinated solvents (chloroform) | [chemicalresistance.org PETG](https://chemicalresistance.org/materials/petg/), [Plaskolite PETG](https://plaskolite.com/docs/default-source/tec/tec409_psk_chem_res_petg.pdf) |
| Alcohol disinfection | alcohols "lack sporicidal action" | [CDC disinfection guideline](https://www.cdc.gov/infection-control/hcp/disinfection-sterilization/chemical-disinfectants.html) |
| PETG HDT | 68 °C (ISO 75) | [Prusament PETG TDS](https://prusament.com/wp-content/uploads/2022/10/PETG_Prusament_TDS_2021_10_EN.pdf) |

---

## Benchware

### 1. `tube_rack_1p5ml.scad` (24 × 1.5 mL)
- **[OK] Tube diameter.** The 10.8 mm body figure matches Eppendorf (Ø 10.8 / 10.7 mm). The 25 mm blind hole leaves about 13 mm of tube plus the lid above the block. Tubes rest on their tips; that is fine.
- **[RISK] 11.2 mm holes leave only 0.2 mm per side, and the tutorial itself recommends more.** Vertical FDM holes usually print 0.1-0.2 mm undersize, so the real clearance will be about 0-0.1 mm per side. That is tight with 11.0 mm tubes from other brands, or with a little elephant's foot. The tutorial's own clearance table (Part 4) says a "tube in a rack hole" needs **0.3-0.5 mm per side**, and `designs/README.md` already uses `-D hole_d=11.6` as its CLI example.
  - *Fix:* `hole_d = 11.6`. Update the comment to "~0.4 mm clearance per side", and update the prompt and checks to match. If 11.2 is kept, change the tutorial's table row instead (see the internal-consistency section).
- **[OK] Printability.** Prints without supports; the web between holes is 4.8 mm.

### 2. `conical_rack_50ml.scad` (6 × 50 mL)
- **[RISK] The hole is barely larger than the tube.** Corning lists the Falcon 352070 at **O.D. 30 mm × 115 mm**. A 30.5 mm hole leaves 0.25 mm per side before FDM shrinkage. The header comment "~29-30 mm across" understates the fit risk.
  - *Fix:* `hole_d = 31.0` (0.5 mm per side). Change the comment to "50 mL Falcon is 30 mm O.D. (Corning 352070)".
- **[OK] Height.** With a 115 mm tube on its tip, the 66-70 mm plate leaves about 45 mm of tube and the cap above it. Tilt in the hole is under 1°.
- **[OK] Print orientation.** "No bridges, no supports" holds; scadreport finds no overhangs. Elephant's foot only affects the bed face (the top in use), which the clearance above absorbs.

### 3. `slide_drying_rack.scad`
- **[RISK] Slide size in the prompt and header.** Both say slides are "75 × 25 × 1 mm", but ISO 8037-1 is 76 × 26 mm and US 3"×1" slides are 76.2 × 25.4 mm. A blind 77 mm slot leaves only 0.4 mm per end, and slot ends print short.
  - *Fix:* `slot_len = 79`. Change the comment to "ISO 8037-1 slides are 76 × 26 × 1.0 mm".
- **[RISK] 1.6 mm slots print narrower.** At 0.45 mm extrusion width, a 1.6 mm slot often comes out about 1.3-1.4 mm, which leaves very little room for a 1.0-1.05 mm slide. The header's "check slot width with a real slide" is good advice.
  - *Fix:* `slot_w = 1.8`. The walls stay 1.7 mm thick (about 4 perimeters).
- **[RISK] Poor drying function for stained or smeared slides.** Each slide stands on its long edge with 10 mm of its 26 mm width inside a *blind* slot. That has three effects:
  - about 40 % of the face, including smear or section area, rubs on the slot walls;
  - liquid draining off the slide pools in the closed slot and wicks back up the ~0.3 mm gaps, so slides stay wet;
  - the 3.5 mm pitch leaves only 2.5 mm of air between slides.

  Commercial drying racks touch only the slide edges and let liquid drain.
  - *Fix:* `slot_depth = 4`, `slot_pitch = 5`, block Y = 60. Also make the slots drain, either through the block (cut to z = -eps) or with a 2 mm drain hole at each slot end. Add to the header: "Contact is edge-only; keep smears and sections above the block."
- **[OK] Printability.** Walls between slots are 1.9 mm (4 perimeters). No supports needed.

### 4. `pcr_tube_rack_sbs.scad` (96 × 0.2 mL, SBS)
- **[OK] Grid and footprint.** 127.76 × 85.48 mm, A1 at 14.38 / 11.24 mm and 9 mm pitch all match ANSI/SLAS 1-2004 and 4-2004.
- **[RISK] Hole size.** The tube OD is about 6.0 mm (5.40 mm ID + 2 × 0.29 mm wall). A 6.2 mm hole leaves 0.1 mm per side, so after FDM shrinkage, 96 holes will bind.
  - *Fix:* `hole_d = 6.4`. Change the comment to "0.2 mL tube OD ≈ 6.0 mm".
- **[ERROR] Claim: "Fits plate holders, plate magnets and plate lids."**
  - *Magnets:* a solid 20 mm block surrounds each tube's lower half, so the tubes cannot reach the posts or rings of a 96-well magnet stand.
  - *Lids:* the tubes (20.8 mm tall, plus caps) are as tall as the 20 mm rack, which is already higher than a standard plate (ANSI/SLAS 2: 14.35 mm). A plate lid cannot sit on it.
  - *Fix:* change the header to "Fits SBS plate carriers and holders. Not for magnet stands; plate lids will not fit over capped tubes."
- **[RISK] The chamfer and sharp corners break the footprint the header claims to follow.** ANSI/SLAS 1-2004 requires the base footprint to be "continuous and uninterrupted" and the corners to have a radius of 3.18 ± 1.6 mm. The 5 mm chamfer runs down to the bed, and the other three corners are sharp, so the part may not seat in a nest with radiused pockets. Real plates put the orientation chamfer on the upper skirt, not on the base flange.
  - *Fix:* start the chamfer at z = 6 mm, so the base stays a full rectangle, and round the four vertical edges with r = 3.18 mm. Alternatively, mark A1 by engraving it.
- **[RISK] The tubes may not hang in the holes.** A straight 6.0 mm tube in a 6.2-6.4 mm through-hole is held only if its cap or rim is wider than the hole. Otherwise it rests on the bench, flush with the top of the rack. That works, but say so: "Tubes rest on the bench through the holes."

## Tools

### 5. `gel_comb_10well.scad`
- **[OK] Material temperature.** PETG HDT is 68 °C, PLA's is about 55 °C, and Bio-Rad pours agarose at 50-60 °C. "PETG survives hot agarose better than PLA" is correct.
- **[RISK] The pouring temperature is not stated.** Students often pour agarose straight from the microwave at more than 80 °C, which will warp a 1.5 mm PETG comb. Bio-Rad itself warns: "Hot agarose (>60 °C) may cause the tray to warp."
  - *Fix:* add to the header: "Let the agarose cool to 50-60 °C before pouring (hand-warm flask)."
- **[RISK] Nothing sets how high the teeth sit, so wells may form through the gel.**
  - The comb is a flat 70 × 12 mm spine with 12 mm teeth and no shoulders.
  - Bio-Rad: "Comb should be placed 1 to 2 mm above the base of the running surface." Otherwise "sample wells cast through the gel" and the sample leaks out underneath.
  - A 70 mm spine also drops *inside* a 7 cm tray unless the tray has comb slots.
  - *Fix:* add a parameter note: `tooth_len` = (height of the spine's support above the tray floor) − 1.5 mm. Add two end tabs (for example 5 mm × 12 mm, spine 80 mm long) that rest on the tray walls.
- **[OK] Well dimensions.** 5.0 mm × 1.5 mm wells with 1.5 mm gaps are in line with Bio-Rad combs (5.54 mm 8-well, 2.59 mm 15-well; 0.75-1.5 mm thick).
- **[RISK] Smooth bed side.** The bed side is smooth only on a smooth PEI sheet; MK4s often ship with a satin or textured sheet. *Fix:* say "smoothest on a smooth PEI sheet".
- **[RISK] The comb does not fit the library's own gel tank.** The 10 teeth span 63.5 mm (spine 70 mm), but `mini_gel_tank.scad` is only 64 mm wide inside (see #16).

### 6. `micropestle_1p5ml.scad`
- **[OK] Geometry.**
  - The Eppendorf 1.5 mL tube is 8.7 mm inside at the top and has a conical section about 17.8 mm long.
  - The 8 mm handle clears it by 0.35 mm per side.
  - The pestle cone has a half-angle of 8.4°, a little narrower than the tube's cone (about 10-11°), so the rounded 3 mm tip reaches the bottom of the tube. "Matches the conical bottom" is a reasonable approximation.
- **[RISK] Tall, thin print.** It stands 63.5 mm tall on 50 mm² of bed contact, and the cone narrows to a 3 mm tip, so it may detach or wobble. *Fix:* add "use a 5 mm brim; print several at once so each layer has time to cool".
- **[RISK] Biological and chemical limits are missing.**
  - Commercial micropestles are polypropylene, autoclavable and certified RNase/DNase-free. A printed PLA or PETG pestle is none of these.
  - Its layer ridges hold tissue, so carry-over between samples is likely.
  - PETG resists phenol and chloroform poorly (TRIzol contains phenol).
  - PLA and PETG turn brittle in liquid nitrogen, so the 3 mm tip can snap off into the sample.
  - *Fix:* add to the header: "Single use. Not RNase-free or autoclavable. Do not use with phenol/chloroform (TRIzol) or acetone. If grinding under liquid nitrogen, expect brittle tips; grind gently."

### 7. `lab_funnel_60mm.scad`
- **[OK] Overhang.** The cone is 39.8° from vertical (25 mm of radius over 30 mm of height), so "below 45°" holds.
- **[RISK] "1.6 mm thick everywhere" is wrong for the cone.** The offset is horizontal, so the true wall thickness normal to the cone is 1.6 × cos 39.8° = **1.23 mm**. The prompt (`bench/tasks.yaml`) and the comment both say "1.6 mm thick everywhere".
  - *Fix:* reword to "1.6 mm wall measured horizontally (≈1.2 mm normal to the cone)". Alternatively, offset the inner cone by `wall / cos(atan(25/30))`, but that changes the checks.
- **[RISK] Unstable while printing.** The whole 60 mm funnel stands on the 10 mm spout ring (42 mm² of bed contact), so it can tip or detach late in the print. Printed rim-down instead, it is still support-free (the inside surface is 39.8° from vertical), and the bed contact rises to about 290 mm².
  - *Fix:* "Use a brim, or print it upside down (rim on the bed)."
- **[RISK] Chemical advice is too broad.** "PETG or PP for chemical resistance" will mislead: PETG is attacked by acetone, phenol and chloroform. Printing PP on an MK4 needs PP tape or a PP sheet.
  - *Fix:* "PETG: water, buffers, ethanol. Not for acetone, phenol or chloroform. PP needs a PP-tape bed."

### 8. `seed_sowing_template.scad`
- **[ERROR] "Fits inside a 90 mm dish" fails for common dishes.**
  - SPL 90 mm dishes are 85.90 mm inside (0.45 mm per side). Glass 90 mm dishes are 85 mm inside (zero clearance). Some 90 mm plastic dishes have an 86 mm base OD, so roughly 84.5 mm inside (interference).
  - Dish walls also have draft, so the opening narrows towards the floor, where the agar surface is.
  - *Fix:* `disc_d = 82`. The corner holes still stay inside, at 39.7 mm against a 41 mm rim. Update the prompt bbox and probes, and add "measure your dish's inside diameter at agar height".
- **[RISK] Placing it on the agar is an aseptic-technique problem.**
  - The template "lies on the agar", but the only disinfection given is "70 % ethanol". Alcohols "lack sporicidal action" (CDC).
  - Layer lines hold fungal and bacterial spores, and Arabidopsis plates on sucrose-MS medium are incubated for weeks, so spores will grow.
  - Lifting a 2 mm disc off soft agar also disturbs the seeds, and the disc has no tab to grip.
  - *Fix:* recommend using it **under** the dish as a sowing guide, seen through the clear base, which is standard practice. If it must touch agar, require "immerse in 70 % ethanol ≥ 10 min, air-dry in the flow hood, optionally UV both sides; single use". Add a 10 × 6 mm lift tab.
- **[OK] Hole layout.** A 9 mm grid with 3 mm holes is suitable for 49 Arabidopsis seeds (about 0.5 mm each).

## Quick fixes

### 9. `dshaft_knob_6mm.scad`
- **[OK] Shaft dimensions.** Bourns' 6 mm flatted shaft is Ø 6.0 with a 4.5 mm flat, so `shaft_d = 6.2` and `shaft_flat = 4.7` give about 0.1 mm per side. The D faces +X and the pointer groove also points to +X, consistent with the prompt.
- **[RISK] The flat may be shorter than the bore.** The bore is a D shape for its full 12 mm depth. Bourns flats are 12 mm long, but many pots and instruments have shorter flats (about 7-10 mm). The shaft's round section then meets the bore's flat near the mouth, and the knob cannot slide on fully.
  - *Fix:* make the bore round (Ø 6.2) for the bottom 5 mm and D-shaped above that. Note: "measure the length of the flat".
- **[RISK] Elephant's foot closes the bore mouth.** The bore opens on the bed face, where the first layer squishes inward, so the shaft won't start.
  - *Fix:* add a 0.5 mm × 45° chamfer at the bore mouth, or "enable elephant-foot compensation".
- **[RISK] Not every stirrer shaft is 6 mm.** Many US instruments use 1/4" (6.35 mm) shafts. The header says "hotplates, stirrers, power supplies" without asking the user to measure.
  - *Fix:* "Measure the shaft: 6.0 mm metric or 6.35 mm (1/4") imperial; set `shaft_d` = measured + 0.2."
- **[OK] Printability.** The bore ceiling is a trivial 6.2 mm bridge.

### 10. `pcr_tube_adapter.scad`
- **[ERROR] Its geometry is that of a microcentrifuge adapter, but nothing says not to spin it.** The name "0.2 mL-in-1.5 mL tube adapter" and its 10.8 mm OD sleeve match exactly what a student would drop into a 1.5 mL rotor bore. That contradicts the paper's §8 and the tutorial ("never print ... tube adapters for a commercial centrifuge").
  - *Fix:* add to the header and to `designs/README.md`: "For racks only. NEVER use in a centrifuge rotor."
- **[RISK] The tube may fall through.** The bore is a straight 6.2 mm through-hole and the tube OD is about 6.0 mm. Unless the cap rim catches, the 20.8 mm tube slides to the floor of the 25 mm rack hole and sits about 4 mm below the collar, where it is hard to retrieve.
  - *Fix:* make the bore blind, 15 mm deep, with a 1.5 mm floor. Printed collar-down, the floor is a trivial 6 mm bridge.
- **[RISK] The heat-block advice misleads.** "Not for heat blocks unless printed in a high-temperature material" implies that some FDM material would be fine. PCR blocks reach 95 °C, which is above the HDT of PETG (68 °C) and close to that of ASA/PC. A plastic sleeve also insulates the tube, so it would not reach the set temperature.
  - *Fix:* "Not for heat blocks or thermal cyclers in any printed material: plastic insulates the tube and softens."
- **[OK] Fit and printability.** A 10.8 mm body in an 11.2 mm hole fits; the wall is 2.3 mm; no overhangs.

### 11. `hose_barb_reducer_8_5.scad`
- **[OK] Barb sizing.** Stretch is 9.5/8 = 19 % and 6.5/5 = 30 %, both within the 18-34 % Nordson recommends for silicone. Barbs face the right way on both ends, and both lead-in diameters (7.5 and 5.0 mm) are no larger than the tubing ID.
- **[RISK] Weak where it is most loaded.**
  - Printed upright, the layer lines run across the axis, so bending or pulling the tubing breaks the part at the sharp steps beside the collar (z = 20 and z = 25).
  - The tip of the 5 mm side is only 1.0 mm thick (5.0 OD, 3.0 bore), so it gets just two perimeters.
  - The part is 41 mm tall on 37 mm² of bed contact.
  - *Fix:* `bore_d = 2.5` (1.25 mm tip wall). Add a small fillet or 45° cone where the barbs meet the collar, and "use a brim". Add to the header: "Not for lines under tension or bending; not for pressurised or biohazard lines."
- **[OK] Flow and overhangs.** The 3 mm bore limits flow to about 36 % of a 5 mm bore. That is acceptable for the stated use and worth one line in the header. The flat overhangs scadreport flags at z = 20 and z = 33 are 0.75-1.25 mm ledges and print fine.

### 12. `rod_tubing_clip.scad`
- **[RISK] Rod size.** Twelve millimetres is at least as common for stands as 12.7 mm (Eisco and LABZIO rods are 12 mm). On a 12 mm rod, a 12.7 mm ring has 0.35 mm per side of play and slides down the rod. Even on a 12.7 mm rod, a ring with zero clearance holds only by friction.
  - *Fix:* add a comment: "rod_id = measured rod Ø − 0.2 mm for grip (12 mm and 12.7 mm rods are both common)".
- **[OK] Snap fit.** A 10 mm opening on a 12.7 mm rod means each arm moves 1.35 mm. That is about 2 % strain in a 3 mm wall, fine in PETG and marginal in PLA, so the header's choice of PETG is right. The ring is printed flat, so the bending is within layers.
- **[RISK] The tubing size is unstated.** The 6 mm ring fits only 6 mm OD tubing (for example 4 × 6 mm or 1/8" × 1/4"). The library's own 8 mm and 5 mm ID silicone tubing (about 11 mm and 8 mm OD) will not fit.
  - *Fix:* change the comment to "tube_id = tubing OD".

## Full hardware

### 13. `stirrer_fan_housing.scad`
- **[OK] Fan holes.** The 71.5 mm pattern is correct for 80 mm fans. 4.5 mm holes take M4 screws with nuts. Stock fan screws (about 5 mm self-tapping) will not pass, which is acceptable because the header says M4.
- **[ERROR] The magnets will hit the top plate.** The header says to glue the magnets to the hub and screw the fan *directly* under the top plate. The hub is roughly flush with the fan frame, so magnets (usually 2-5 mm thick) stick up and rub on the 2 mm plate. Every DIY build guide uses spacers "higher than the profile of the fan with the magnets glued on".
  - *Fix:* add four standoffs of magnet height + 1 mm at the hole positions, for example cylinders d = 8 mm, h = 4 mm around each hole. Or state: "use 4 mm spacers or nuts on M4 × 35 screws". Also add: "glue the two magnets with opposite poles facing up, symmetric about the hub".
- **[RISK] Screw heads stand on the stirring surface.** The M4 heads sit proud of the top plate, where the beaker stands.
  - *Fix:* countersink the holes from the bed face (90°, Ø 8.4 mm). Printed bed-down, a 45° countersink is printable.
- **[OK] Plate stiffness.** A 2 mm plate spanning 71.5 mm sags about 0.4 mm under a 1 kg point load, which is acceptable.

### 14. `nema17_motor_bracket.scad`
- **[OK] Motor interface.** The 31 mm M3 pattern and 22 mm pilot are correct (Oriental Motor). 3.4 and 4.5 mm are the ISO 273 medium clearances for M3 and M4. All screw heads clear the gussets and base.
- **[RISK] "Prints without supports" is optimistic for the 23 mm horizontal hole.** scadreport reports 144 mm² steeper than 45° and a flat area at z = 39.5. That is the crown of the hole, a bridge about 16 mm wide. The crown typically sags 0.3-0.5 mm, which uses up most of the 0.5 mm radial clearance around the 22 mm pilot.
  - *Fix:* use a teardrop or flat-topped hole (flat at z = boss_z + 11.5, 45° sides), or set `boss_d = 23.5`. Add "check that the pilot fits" to the header.
- **[RISK] It must be screwed down.** The motor (about 0.3 kg) hangs behind the plate (−Y), outside the base footprint, so an unscrewed bracket tips backwards. *Fix:* add "screw the base down before mounting the motor".

### 15. `enclosure_box_and_lid.scad`
- **[OK] Lip fit.** 65.6 mm against a 66 mm opening is 0.2 mm per side, as stated.
- **[RISK] "Push fit" or "sliding"?** The tutorial classes 0.2-0.3 mm per side as a *sliding* fit ("a lid lip in a box"), not a push fit. Depending on the printer, the lid may simply fall off.
  - *Fix:* call it a "slip-fit lid". Suggest `clearance = 0.1` for friction, or tape.
- **[RISK] The example board does not fit.** The prompt suggests an "Arduino-based temperature logger", but an Arduino Uno is 68.6 × 53.4 mm and the box is 66 × 46 mm inside. There are also no cable, USB or vent openings.
  - *Fix:* change the prompt and header to "Arduino Nano-based". Add the note "add a cable hole (e.g. 6 mm) before printing".

### 16. `mini_gel_tank.scad`
- **[ERROR] The electrodes sit above a normal buffer level.**
  - The platform top is at z = 13. A typical 5 mm gel (on a tray) has its top at about z = 18-21.
  - Bio-Rad specifies 2-6 mm of buffer over the gel, so the buffer level is about z = 20-27. The wire holes are at **z = 30**, so the electrodes would not be submerged.
  - Filling to cover them means about 10 mm of buffer over the gel: more current, more heat, slower runs.
  - The wire also enters along X at a single point (y = 0), so it is not a wire spanning the chamber width. That gives a non-uniform field and curved ("smiling") bands.
  - *Fix:* electrodes must run across each buffer chamber along Y, near the floor. Do one of the following:
    1. move the holes into the side walls, along Y, at x = ±52, `wire_z = 5`, and seal them with silicone or epoxy; or
    2 (safer against leaks). remove the holes, run the wires over the rim into floor grooves, and bring them to shrouded 4 mm sockets.

    Make `wire_d` match the wire: Bio-Rad uses 0.25 mm Pt, so a 2 mm hole is a leak path.
- **[ERROR] A live conductor would be exposed outside the tank.** As designed, the bare electrode wire leaves through the end walls at 50-150 V DC, with no insulation and no shroud. The header and README rightly demand "a closed lid with an interlock", but the design includes neither lid nor interlock. Under IEC 61010-1, more than 35 V DC in wet locations counts as hazardous live (clause 6.3, from memory).
  - *Fix:* add to the header: "Lid and interlock are NOT included in this file. Do not connect a power supply until a lid that carries the shrouded connectors (so removing it breaks the circuit) is built." Keep electrode wire inside the tank and out of reach.
- **[RISK] Gel width.** Inside, the tank is 114 × 64 mm. Standard mini-gel trays are 7 cm wide (Bio-Rad 7 × 7 or 7 × 10 cm) and do not fit, and neither does the library's own 70 mm comb (#5).
  - *Fix:* `outer = [130, 90, 40]` (84 mm inside), `platform_len = 75`.
- **[RISK] Electrode material.** Stainless steel works as a cathode, but as an anode it corrodes. It browns the buffer, and the released metal ions damage DNA and RNA ([diybio thread](https://groups.google.com/g/diybio/c/GWTrmC6vMfc), [ResearchGate orthodontic-wire study](https://www.researchgate.net/publication/391423051_Using_Orthodontic_Wire_electrodes_in_Gel_Electrophoresis_Device)).
  - *Fix:* "platinum (or graphite) for the anode; stainless steel only as the cathode, and replace it if the buffer discolours".
- **[OK] Print settings.** PETG with 4+ perimeters and a water leak test is good advice. Bio-Rad limits buffer to 40 °C, and PETG is fine there.

---

## Cross-cutting and internal-consistency findings

- **[RISK] The tutorial's clearance table contradicts its first exercise.** Part 4 says "loose (drops in) 0.3-0.5 mm per side, e.g. tube in a rack hole". Parts 2-3 use 11.2 mm for a 10.8 mm tube (0.2 mm per side) and call it "a little extra room". Choose one; I recommend `hole_d = 11.6` everywhere. Changing this alters the tutorial prompt *and* the benchmark task, so it is a v2 change. The safe interim note is: "0.2 mm per side is the minimum; if tubes stick, go to 11.6 mm."
- **[RISK] Table 1 print times use different settings from the headers.** The estimates come from the stock 0.20 mm SPEED PLA profile (`tools/slice_library.py`). Several headers prescribe slower settings: hose barb 0.12 mm and 100 % infill; pestle 0.12-0.15 mm and 100 %; comb 0.15 mm and 100 %; clip 100 %; bracket 5 perimeters and 30 % infill; knob 0.15 mm and 4 perimeters. Several also recommend PETG.
  - *Fix:* add to the Table 1 caption: "Default profile, not the per-part settings in the file headers; parts with 100 % infill or finer layers take longer."
  - The totals check out: 31.64 h and 482.9 g.
- **[RISK] "Each ... prints without supports" (README §2).** This holds except for the bracket's 16 mm-wide crown bridge (#14) and the 0.75-1.25 mm ledges on the barb collar. Say "without supports (the bracket's motor hole bridges its crown)".
- **[RISK] README §8: "PETG, PP and PC deform at 121 °C."** This is true of *printed* parts in the cited studies, but molded PP labware is routinely autoclaved: Corning lists Falcon PP tubes as "stable from -80 °C to +121 °C", and Eppendorf PP PCR tubes are autoclavable at 121 °C. Readers may conclude that PP tubes cannot be autoclaved. *Fix:* "Printed PETG, PP and PC parts deformed at 121 °C in tests (...)."
- **[OK] Tutorial dimensions.** 10.8 mm for a 1.5 mL tube, 71.5 mm for 80 mm fans, 31 mm and 22 mm for NEMA 17, Prusa's 0.2 mm accuracy and 0.3 mm for moving parts, PETG HDT 68 °C, PLA softening at 55-60 °C, 0.45 mm perimeters and the 45° overhang rule are all consistent with sources.

## Tutorial and paper statements on biology and safety

- **[RISK] Tutorial Part 7, cleaning.** "Wiping with 70 % ethanol ... is fine" is correct as *disinfection*. Nowhere does the tutorial say this is not sterilisation, and alcohols are not sporicidal (CDC). That matters for anything that touches agar or cultures, such as the seed template.
  - *Fix:* add "Ethanol disinfects but does not sterilise (it does not kill spores). For anything that touches media or cultures: soak ≥ 10 min in 70 % ethanol, dry in the hood, single use, or use the part outside the dish."
- **[RISK] Tutorial Part 7, materials table.** The table omits two lab-relevant limits:
  - agarose should be cooled to 50-60 °C before it touches PLA or PETG combs and trays;
  - PETG and PLA are attacked by phenol, chloroform (TRIzol and phenol-chloroform extractions) and acetone.
  - *Fix:* add both to the "Avoid" column.
- **[RISK] Tutorial "Never print" list vs. the library.** The list says "tube adapters for a commercial centrifuge", yet the library ships a sleeve sized exactly for a 1.5 mL rotor bore (#10). Add "for racks only, never in a centrifuge" to that design and to `designs/README.md`.
- **[RISK] Tutorial Exercise 5 (fan stirrer).** It never mentions magnet clearance or polarity, or that neodymium magnets are dangerous if swallowed or pinched.
  - *Fix:* "Leave spacers so the magnets clear the top plate; glue them with opposite poles up; keep loose neodymium magnets away from children and pacemakers."
- **[OK] Paper §8 and tutorial Part 6 on electricity.** "Keep electronics low-voltage, certified supplies, no mains" is appropriate. The gel-tank voltage range of 50-150 V DC is realistic: Bio-Rad runs mini gels at 75 V. But see #16: the shipped tank design itself exposes live wire and has no lid, so the warning needs "lid not included" next to it.
- **[OK] Paper §4 and §8 on materials.** No autoclaving of PLA (Neijhoft), PETG HDT 68 °C, brief ethanol, isopropanol or hypochlorite wipes, ventilation, and the centrifuge exclusion are all accurate.
