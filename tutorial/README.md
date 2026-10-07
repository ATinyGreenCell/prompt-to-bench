# From prompt to bench: design your own lab hardware with AI and OpenSCAD

*A hands-on tutorial for students and lab staff. No CAD experience needed. Part of the [Prompt to Bench](../README.md) project · CC BY 4.0*

You will learn to turn "I need something that holds these tubes" into a printed part that fits, using a language model as your CAD assistant. The model writes the 3D design as a short program in **OpenSCAD**. Your job is to measure, describe, check and decide.

**Time:** about 3 hours for parts 1-4; the rest whenever you need it.
**You need:**

- a computer (Windows, macOS or Linux; 8 GB RAM is enough for most of this, 16 GB for local AI models);
- digital calipers (about US$10-20);
- access to an FDM 3D printer (your own, a shared one or a makerspace).

**You do not need:** a GPU or a permanent internet connection. A hosted chatbot is the most reliable option; see [Part 8](#part-8-working-offline-with-a-free-local-model) for the offline option and its current limits.

---

**New here? Start with [SETUP.md](SETUP.md):** our exact setup (Claude Code + Prusa MK4), the same workflow with any printer, slicer or chatbot, a setup-assistant prompt, and a 35-minute calibration print for your printer.

## Contents

1. [Install the tools](#part-1-install-the-tools)
2. [Your first part: a tube rack in 20 minutes](#part-2-your-first-part-a-tube-rack-in-20-minutes)
3. [Check the part before you print it](#part-3-check-the-part-before-you-print-it)
4. [Make it fit: coupons and clearances](#part-4-make-it-fit-coupons-and-clearances)
5. [Make it yours: parameters and the Customizer](#part-5-make-it-yours-parameters-and-the-customizer)
6. [From parts to hardware](#part-6-from-parts-to-hardware)
7. [Materials, cleaning and safety](#part-7-materials-cleaning-and-safety)
8. [Working offline with a free local model](#part-8-working-offline-with-a-free-local-model)
9. [Share what you made](#part-9-share-what-you-made)
10. [Exercises](#exercises)
11. [Cheat sheets: prompts, OpenSCAD, error messages](#cheat-sheets)

---

## Part 1. Install the tools

| Tool | What it does | Get it |
|---|---|---|
| **OpenSCAD** | turns code into a 3D model | [openscad.org/downloads](https://openscad.org/downloads.html). Use a recent **development snapshot**: its new geometry engine (Manifold) renders orders of magnitude faster than the old 2021.01 release. |
| **A slicer** | turns the model into printer instructions (G-code) | PrusaSlicer, OrcaSlicer, Cura or your printer's own slicer |
| **An AI model** | writes the OpenSCAD code | either a chatbot you already use, or a free local model (Part 8) |
| *Optional:* **Python 3 + `scadreport`** | measures what you actually built, so you or the AI can compare it with what you wanted | this repository: `pip install -r requirements.txt`, then `python tools/scadreport.py yourpart.scad` |

When OpenSCAD starts, open **Window** and make sure the **Editor**, **Console** and **Customizer** panels are visible. You need three keys:

- **F5** - quick preview
- **F6** - full render (do this before exporting)
- **F7** - export STL

## Part 2. Your first part: a tube rack in 20 minutes

### Step 1 - Measure

Take a 1.5 mL microcentrifuge tube and measure the outside diameter just below the lid hinge with your calipers. You will get about **10.8 mm**. A tube should drop into its hole, and printed holes come out a little small, so we will use **11.6 mm**: about 0.4 mm of clearance on each side (see Part 4).

> **Rule 1: measure; don't trust memory - yours or the AI's.** Models will confidently invent "standard" sizes. Give them numbers.

### Step 2 - Give the model its instructions (the starter prompt)

Paste this once at the start of a new chat. In tools that support it, paste it as the "system prompt" or "custom instructions". It is the same prompt every model saw in our benchmark ([`bench/prompts/system.md`](../bench/prompts/system.md)).

````text
You are an expert in OpenSCAD and in designing 3D-printable (FDM) parts for biology laboratories.
Write one complete, self-contained OpenSCAD file that builds exactly the part the user describes.

Rules:
1. Units are millimetres. Use the user's dimensions exactly - they were measured with calipers.
2. Put every dimension in a named variable at the top of the file, with a short comment.
3. Model the part in the print orientation the user gives: it rests on the XY plane at z = 0 and builds upward (+Z). Unless told otherwise, centre it on the origin in X and Y.
4. Use only built-in OpenSCAD: cube, cylinder, sphere, polygon, circle, square, linear_extrude, rotate_extrude, translate, rotate, mirror, union, difference, intersection, hull, for. Do not use include, use or any external library.
5. In difference(), make every cutting shape extend 0.01-1 mm past the faces it cuts, so no faces are exactly coplanar.
6. Set $fn = 64 (or more) on curved shapes so holes come out round and to size.
7. Build repeated features (hole grids, slots, teeth, grooves) with for loops.
8. The file must render to a valid solid with no errors.

Reply with only the code, in a single ```openscad code block.
````

### Step 3 - Describe the part

Write the request the way you would explain it to a careful colleague who cannot see your bench. Give every number, say which face sits on the printer bed, and say what is open and what is closed:

```text
Design a bench rack for 1.5 mL microcentrifuge tubes. It is a solid rectangular
block 106 mm long (X), 72 mm wide (Y) and 30 mm tall (Z). It has 24 vertical
holes in 4 rows (along Y) of 6 holes (along X), 16 mm centre-to-centre in both
directions, with the hole grid centred on the block. Each hole is 11.6 mm in
diameter and 25 mm deep, open at the top and closed at the bottom, leaving a
5 mm solid floor.
```

> **Rule 2: say how it sits on the bed.** "The base lies on the bed at z = 0" prevents most upside-down and floating parts.

### Step 4 - Render it

Copy the code the model returns into a new OpenSCAD file, save it as `rack.scad` and press **F6**.

- **If it fails:** the Console shows red `ERROR` or yellow `WARNING` lines. Copy them back into the chat and say "Fix this. Reply with the complete corrected file."
- **If it renders:** a good answer looks like our reference design, [`designs/benchware/tube_rack_1p5ml.scad`](../designs/benchware/tube_rack_1p5ml.scad):

```openscad
/* [Rack] */
// holes along X
cols = 6;
// holes along Y
rows = 4;
// centre-to-centre spacing [mm]
pitch = 16;
// tube body 10.8 mm + clearance (see header)
hole_d = 11.6; // 0.1
// blind holes, leaves a 5 mm floor
hole_depth = 25;
// block height [mm]
height = 30;

/* [Hidden] */
$fn = 64;
eps = 0.01;            // cutters overshoot by eps so no faces are coplanar
block = [cols * pitch + 10, rows * pitch + 8, height];  // 106 x 72 x 30 by default

difference() {
    translate([-block.x / 2, -block.y / 2, 0]) cube(block);
    for (i = [0 : cols - 1], j = [0 : rows - 1])
        translate([(i - (cols - 1) / 2) * pitch, (j - (rows - 1) / 2) * pitch, block.z - hole_depth])
            cylinder(d = hole_d, h = hole_depth + eps);
}
```

Read it once. It is a block **minus** (`difference`) 24 cylinders placed by two nested loops (`for`). The comment above each number is what the Customizer shows (Part 5), and the block size is computed from the hole grid, so changing `cols` or `pitch` keeps the walls intact. Most lab parts are boxes and cylinders, added and subtracted.

## Part 3. Check the part before you print it

Your eyes come first. Rotate the model and ask yourself:

- Is it the right way up?
- Are the holes open where they should be open, and closed where they should be closed?
- Is anything floating loose?

Then **measure**. You can do it inside OpenSCAD, but the easiest way is `scadreport`, which prints the facts about what you built:

```text
$ python tools/scadreport.py rack.scad
OPENSCAD: rendered OK in 0.5 s, no warnings.
SOLID: 1 separate body, watertight (valid solid); volume 165,652 mm3 (~205 g of PLA if printed solid).
BOUNDING BOX: X -53.00 .. 53.00 (size 106.00) | Y -36.00 .. 36.00 (size 72.00) | Z 0.00 .. 30.00 (size 30.00) mm
BED: lowest point at z = 0.00; contact area with the bed 7,632 mm2.
OVERHANGS: none steeper than 45 deg - prints without supports.
HORIZONTAL SLICES (cut through the part at height z above its lowest point):
  z=2.50: 1 solid region [outline: rectangle 106.00 x 72.00 centred (0.00, 0.00)]; 0 holes; ...
  z=17.50: 1 solid region [...]; 24 holes: 24 x circle d=11.59 [6 x 4 grid (X x Y), pitch X 16.00 / Y 16.00, ...]
```

Compare every line with your request:

- Size 106 x 72 x 30? ✓
- Floor solid at z = 2.5? ✓
- 24 holes of 11.6 mm on a 16 mm grid? ✓ (11.59: a 64-sided polygon is a hair smaller than a circle)

> **Rule 3: when something is wrong, paste the report into the chat.** A language model cannot see your part; a report like this is the next best thing. In our benchmark it helped Claude Haiku fix 3 of its 5 first-try failures. Some small local models (the Qwen2.5 family) almost always returned the same file - with them, start a new chat, simplify the request, or fix the code yourself.

**Common problems and what they mean:**

| You see | Usually means | Tell the model |
|---|---|---|
| `WARNING: Ignoring unknown function 'cube'` and `Current top level object is empty` | it wrote code like `rack = cube(...)`, treating shapes as values. That is not how OpenSCAD works. | "OpenSCAD shapes are modules, not functions. Rewrite it with `difference() { cube(...); ... }` and no variables holding shapes." |
| `Parser error: syntax error ... line N` | a typo, or a different language (`let x = ...;`, `def`, `{` in the wrong place) | paste the line number and the line |
| The holes look polygonal or come out small | `$fn` is missing | "Add `$fn = 64;` at the top." |
| Flickering or paper-thin skins over holes | cutters end exactly on a face | "Make every cutter 0.01 mm longer on both sides." |
| The part is upside down, sideways or floating | the orientation was ambiguous | restate: "the base lies on the bed at z = 0" |
| Two bodies where you expected one | parts touch but don't overlap | "Overlap the parts by 0.01 mm so they join." |
| The model keeps returning the same broken file | small models can get stuck | start a new chat with a shorter request, or ask for one feature at a time |

## Part 4. Make it fit: coupons and clearances

Printers are not perfect. Holes print slightly small, posts slightly fat, and the first layer squishes. **Never print the full part first.** Print a **coupon**: a thin slice that contains the features that must fit. In OpenSCAD, keep only the bottom 3 mm of any part with `intersection()`:

```openscad
intersection() {
    import("rack.stl");            // or paste your design here
    translate([-500, -500, 0]) cube([1000, 1000, 3]);
}
```

Or ask the model: "Make a 3 mm tall test coupon with just the first row of holes." Print it in 10 minutes, try your real tube, adjust `hole_d`, and repeat.

**Starting clearances** (per side; calibrate for your own printer and material):

| Fit | Start with | Example |
|---|---|---|
| loose (drops in) | 0.3-0.5 mm | tube in a rack hole |
| sliding | 0.2-0.3 mm | a lid lip in a box |
| press / snap | 0-0.1 mm, test it | a knob on a shaft |

Prusa suggests an Original Prusa is accurate to about 0.2 mm and that moving parts start at about 0.3 mm ([Prusa Knowledge Base](https://help.prusa3d.com/article/modeling-with-3d-printing-in-mind_164135)).

> **Rule 4: print the coupon first, then the part.**

## Part 5. Make it yours: parameters and the Customizer

Good designs put every number at the top. In OpenSCAD, open **Window → Customizer**: the variables appear as sliders and boxes. To make a 3 x 8 rack for 2 mL tubes, change `rows`, `cols` and `hole_d` and press F6. You don't need the AI any more for that part.

From a terminal you can also do `openscad -D cols=8 -D rows=3 -o rack.stl rack.scad`.

> **Rule 5: once a design works, change its numbers - don't regenerate it.** Every working `.scad` file is a template for the next lab. Our [design library](../designs/) has 16 of them.

## Part 6. From parts to hardware

Devices such as stirrers, pumps, rotators and microscopes are many parts plus electronics. Don't ask a model for "a magnetic stirrer". Instead:

1. **Pick off-the-shelf parts first.** A PC fan, a stepper motor, magnets, screws. Their dimensions are your interfaces: write them down from the datasheet or your calipers. For example, an 80 mm fan has mounting holes 71.5 mm apart, and a NEMA 17 motor has a 31 mm bolt square and a 22 mm boss.
2. **Design one part at a time**, each with its interface numbers in the request. Our [stirrer housing](../designs/hardware/stirrer_fan_housing.scad) and [motor bracket](../designs/hardware/nema17_motor_bracket.scad) show how.
3. **Print it upside down if that removes supports.** The stirrer housing is modelled with its top plate on the bed.
4. **Assemble, test and write down what you changed.**

Keep electronics low-voltage. Use certified power supplies. Never improvise mains wiring.

## Part 7. Materials, cleaning and safety

| Material | Heat limit (approx.) | Good for | Avoid |
|---|---|---|---|
| **PLA** | softens at 55-60 °C | racks, templates, organisers, most benchware | autoclaves, hot water baths, heat blocks, agarose hotter than 60 °C, acetone, cars in summer |
| **PETG** | HDT about 68 °C | combs, funnels, clips, parts that flex or see ethanol | autoclaves (it deforms at 121 °C), long soaks in alcohols, phenol and chloroform (TRIzol), acetone |
| **ASA / PC blends** | HDT about 86-113 °C ([Prusament data sheets](https://prusament.com/)) | warm environments | autoclaves (printed PC deformed too in tests); they need an enclosed printer |

- **Cleaning.** Wiping with 70% ethanol, isopropanol or dilute bleach is fine; long soaks weaken parts. Ethanol *disinfects* but does not *sterilise* - it does not kill spores - and layer lines trap dirt and biofilm. For anything that touches media or cultures: soak at least 10 minutes in 70% ethanol, dry it in the flow hood and use it once, or keep it outside the dish (the seed template works from under the plate).
- **Never print:**
  - rotors or tube adapters for a commercial centrifuge (our tube adapter is for racks only - never spin it);
  - pressure vessels;
  - anything that holds mains voltage;
  - anything that touches patients.
- **Printing safely.** Ventilate the room (ABS emits far more ultrafine particles and fumes than PLA). Never leave a running printer unattended overnight unless your institution allows it.

The [paper's safety section](../README.md#8-safety-and-responsibility) has the references.

## Part 8. Working offline with a free local model

You can run a model on your own laptop, with no account and no internet once it is downloaded. Be aware that **none of the 14 small models we tested (up to 6.6 GB, on a laptop CPU) produced a correct part in our benchmark**, so for now treat local models as an experiment: check everything, and expect to fix the code yourself. We use [Ollama](https://ollama.com):

1. Install Ollama from [ollama.com/download](https://ollama.com/download). It is available for Windows, macOS and Linux.
2. Download a model **once**. If your connection is slow or metered, ask someone to copy it to you on a USB stick: on Linux the models live in `/usr/share/ollama/.ollama/models`, and in `~/.ollama/models` on macOS and Windows.
   ```bash
   ollama pull <model>          # e.g. gemma4:e4b-it-q4_K_M, the closest in our tests
   ```
3. Chat with it in a terminal (`ollama run <model>`), or connect any OpenAI-compatible chat app or OpenSCAD's experimental AI assistant to `http://localhost:11434`.

**Which model?** We tested 14 free models on a 2022 laptop without a GPU ([paper, §6](../README.md#6-results)). None passed a task. The code models (Qwen2.5-Coder) mostly wrote OpenSCAD as if it were another language; the reasoning models (Qwen3.5, Granite, LFM2.5) ran out of tokens; the Gemma 4 models (E2B, E4B) came closest, rendering most parts but rarely at the right size. If you have internet access, use a hosted chatbot. If you don't, a Gemma 4 model plus the starter prompt can draft code that you then fix by hand - which is also a fine way to learn OpenSCAD.

**Things to try with small models** (we have not measured whether they help):

- Use the starter prompt from Part 2, and one part per chat.
- Give every number. Small models cannot fill gaps sensibly.
- Ask for one feature at a time ("first the block with holes; then we add the chamfer").
- Always paste the error messages or the `scadreport` back. If the model returns the same broken file twice, start a fresh chat.
- Writing in your own language is fine for hosted models: our test (one hosted model) found no clear difference between English, Spanish, Hindi and Swahili requests. We have not tested whether mixing in English geometry words helps small models.

## Part 9. Share what you made

Share the **`.scad` file**, not just the STL. The `.scad` file is the editable "source" of your hardware. Include:

- a photo;
- your printer, material and slicer settings;
- what it is for;
- what you checked (calipers, fit test).

Say which AI model and prompt you used. A permissive open-hardware licence, such as CERN-OHL-P, lets other labs reuse your work. This repository welcomes new designs and benchmark tasks: see [CONTRIBUTING](../CONTRIBUTING.md).

## Exercises

1. **Warm-up.** Change the tube rack for 0.5 mL tubes. Measure them first! Print a one-row coupon and adjust the hole size until the tubes drop in without wobbling.
2. **Benchware.** Design a stand for the pipettes on your bench. Measure where the pipette rests and how far apart they need to be. Include the print orientation in your request.
3. **Quick fix.** Find a broken or missing knob, foot or clip in your lab. Measure the shaft or mounting, write a request, check it with `scadreport`, print a coupon of the critical fit, then print the part.
4. **Tool.** Design a seed-sowing or colony-picking template for the plates your lab uses. Make sure the corner holes stay inside the rim: use `scadreport` to check.
5. **Team project.** Build a magnetic stirrer from a PC fan, two magnets and a 12 V supply, starting from [`stirrer_fan_housing.scad`](../designs/hardware/stirrer_fan_housing.scad). Leave spacers so the magnets clear the top plate (the design has standoffs), glue the magnets with opposite poles facing up, and keep loose neodymium magnets away from children and pacemakers. Write a one-page safety note before switching it on.
6. **Compare models.** Give the same request to a hosted chatbot and to a local model. Count the rounds of feedback each needs. What does this tell you about which model to use for which part?

## Cheat sheets

### Prompt templates

- **New part:** "Design a [what] for [purpose]. Print orientation: [which face] lies on the bed at z = 0. Overall size [X x Y x Z] mm. Features: [each feature with its numbers and position]. [What is open / closed / through]."
- **Fix an error:** "OpenSCAD says: [paste the error lines]. Fix it and reply with the complete corrected file."
- **Fix the geometry:** "Here is a measurement report of the part your file produces: [paste the scadreport output]. Compare it with my specification, find what doesn't match and fix it."
- **Change a parameter:** do it yourself in the Customizer.
- **Explain:** "Explain what each line of this file does, as if to a biology student."

### OpenSCAD in 15 lines

```openscad
cube([x, y, z]);                       // box from the origin; cube(s, center=true) to centre it
cylinder(d = 10, h = 5, $fn = 64);     // d1 = / d2 = for a cone
sphere(d = 3, $fn = 48);
translate([x, y, z]) child();          // move
rotate([ax, ay, az]) child();          // rotate in degrees around X, Y, Z
mirror([1, 0, 0]) child();
union() { a(); b(); }                  // join (also the default)
difference() { a(); b(); c(); }        // a minus b minus c
intersection() { a(); b(); }           // keep the overlap
hull() { a(); b(); }                   // shrink-wrap around both
for (i = [0 : n - 1]) translate([i * pitch, 0, 0]) child();
linear_extrude(height = 2) polygon([[0,0], [10,0], [0,10]]);   // 2-D shape -> 3-D slab
rotate_extrude() polygon(profile);     // spin a 2-D (r, z) profile around Z: funnels, barbs
module my_part(size = 10) { cube(size); }  // define your own; call it with my_part(5);
/* [Section] */                        // Customizer tab; the comment line above a
// hole diameter [mm]                   //   parameter is its description, and a
hole_d = 11.6; // 0.1                  //   trailing number its step (// [1:10] = slider)
```

### Glossary

- **FDM:** printing by melting a plastic filament layer by layer.
- **Slicer:** software that turns a 3D model into G-code for the printer.
- **STL:** the triangle-mesh file you print.
- **`.scad`:** the editable source.
- **Perimeter:** an outline wall of extruded plastic, about 0.45 mm thick with a 0.4 mm nozzle.
- **Infill:** the internal lattice.
- **Overhang:** a surface printed over air. Up to about 45° is safe.
- **Bridge:** a flat span printed between two supports.
- **Clearance:** the gap you design between parts that must fit together.
- **Watertight / manifold:** a closed, valid solid, which is what a slicer needs.
- **Coupon:** a small test print of the critical feature.
