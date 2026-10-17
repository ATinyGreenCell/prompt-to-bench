Thinking Process:

1.  **Analyze the Request:**
    *   **Goal:** Design a two-part enclosure for a small electronics board (Arduino-based temp logger).
    *   **Output:** One complete, self-contained OpenSCAD file.
    *   **Rules:**
        *   Units: mm.
        *   Dimensions: Use user's exact dimensions in named variables at the top.
        *   Orientation: Rest on XY plane at Z=0, build upward (+Z). Center on origin in X and Y (unless specified otherwise for placement).
        *   Libraries: Only built-in OpenSCAD functions.
        *   Difference: Cutting shapes must extend 0.01-1 mm past faces.
        *   Curvature: Set `$fn = 64` (or more) on curved shapes.
        *   Loops: Use `for` loops for repeated features.
        *   Validity: Must render to a valid solid.
        *   Specific Geometry:
            *   Part 1 (Box): Outer 70 x 50 x 30 mm (X x Y x Z). 2 mm walls, 2 mm floor, open top.
            *   Part 2 (Lid): Printed upside down (plate 70 x 50 x 2 mm lying on bed). Rectangular lip on top (1.5 mm thick wall, 4 mm tall). Lip outer size 65.6 x 45.6 mm, centred on plate. Slides into box opening with 0.2 mm clearance on each side.
            *   Placement: Place lid on the +X side of the box.
            *   Gap: 10 mm gap between them.
            *   Printing: Both parts in the same file, side by side on the bed.

2.  **Deconstruct Geometry & Dimensions:**

    *   **Part 1 (Box):**
        *   Outer Dimensions: $X_{out} = 70$, $Y_{out} = 50$, $Z_{out} = 30$.
        *   Wall Thickness: $T_{wall} = 2$.
        *   Floor Thickness: $T_{floor} = 2$.
        *   Top: Open.
        *   Inner Dimensions:
            *   $X_{in} = 70 - 2 \times 2 = 66$.
            *   $Y_{in} = 50 - 2 \times 2 = 46$.
            *   $Z_{in} = 30 - 2 = 28$.
        *   Placement: Centered on origin? The prompt says "Centre it on the origin in X and Y" generally, but then says "Place the lid on the +X side of the box". I need to decide the absolute position. Usually, for FDM printing, centering the assembly on the bed is good, but the prompt says "Model the part in the print orientation the user gives... Unless told otherwise, centre it on the origin in X and Y."
        *   Wait, the prompt says "Put both parts in the same file, side by side on the bed with a 10 mm gap between them".
        *   If I center Part 1 at (0,0), Part 2 needs to be at X = (70/2) + 10 + (70/2) = 70? No.
        *   Let's interpret "Centre it on the origin in X and Y" as applying to the *individual parts* before assembly, or the *assembly*?
        *   Rule 3: "Model the part in the print orientation the user gives: it rests on the XY plane at z = 0 and builds upward (+Z). Unless told otherwise, centre it on the origin in X and Y."
        *   However, the user instruction says "Put both parts in the same file, side by side on the bed with a 10 mm gap between them".
        *   If I model Part 1 centered at (0,0), its X range is -35 to +35.
        *   If I model Part 2 centered at (0,0), its X range is -35 to +35.
        *   To put them side by side with a 10mm gap:
            *   Part 1 Center X = -35 - 5 = -40?
            *   Part 2 Center X = 35 + 5 = 40?
            *   Gap = 40 - 35 = 5? No.
            *   Distance between centers = Width1 + Gap + Width2 / 2?
            *   Let's define positions explicitly.
            *   Part 1 (Box): Centered at X = -35 (Left side).
            *   Part 2 (Lid): Centered at X = +35 (Right side).
            *   Gap = 10mm.
            *   Total Width = 70 + 70 + 10 = 150mm.
            *   If Part 1 is centered at -35, it spans -70 to 0.
            *   If Part 2 is centered at +35, it spans 0 to 70.
            *   Gap is at 0? No, that's touching.
            *   Let's center the *assembly* at 0,0.
            *   Part 1 X-center: $-(70 + 10 + 70)/2 + 70/2 = -75 + 35 = -40$.
            *   Part 2 X-center: $+(70 + 10 + 70)/2 - 70/2 = 75 - 35 = 40$.
            *   Wait, simpler:
            *   Part 1 Box: $X_{pos} = -40$. Spans -70 to 0.
            *   Part 2 Lid: $X_{pos} = 40$. Spans 0 to 70.
            *   Gap between 0 and 0? No.
            *   Let's calculate gap.
            *   Part 1 Right Edge = $X_{pos1} + 35$.
            *   Part 2 Left Edge = $X_{pos2} - 35$.
            *   Gap = $(X_{pos2} - 35) - (X_{pos1} + 35) = X_{pos2} - X_{pos1} - 70$.
            *   We want Gap = 10.
            *   $10 = X_{pos2} - X_{pos1} - 70 \Rightarrow X_{pos2} - X_{pos1} = 80$.
            *   If Center of Assembly = 0.
            *   $X_{pos1} = -40$, $X_{pos2} = 40$.
            *   Part 1 Right Edge = -40 + 35 = -5.
            *   Part 2 Left Edge = 40 - 35 = 5.
            *   Gap = 5 - (-5) = 10. Correct.
            *   So Part 1 is at X = -40, Part 2 is at X = 40.
            *   Y position: Centered at 0 for both.

    *   **Part 2 (Lid) Geometry:**
        *   Base Plate: 70 x 50 x 2 mm.
        *   Lip:
            *   Wall thickness: 1.5 mm.
            *   Height: 4 mm.
            *   Outer Size: 65.6 x 45.6 mm.
            *   Clearance: 0.2 mm on each side.
            *   Check math:
                *   Box Inner X = 66 mm.
                *   Lid Lip Outer X = 65.6 mm.
                *   Clearance = (66 - 65.6) / 2 = 0.2 mm. Correct.
                *   Box Inner Y = 46 mm.
                *   Lid Lip Outer Y = 45.6 mm.
                *   Clearance = (46 - 45.6) / 2 = 0.2 mm. Correct.
            *   Lip Position: Centred on the plate.
            *   Lip Thickness (Z): 1.5 mm.
            *   Lip Height (Z): 4 mm.
            *   Wait, "printed upside down: a plate 70 x 50 x 2 mm lying on the bed, with a rectangular lip on top of it".
            *   So the plate is at Z=0 to Z=2.
            *   The lip is on top of the plate. So Lip Z range is Z=2 to Z=6 (2 + 4).
            *   Lip Wall Thickness: 1.5 mm.
            *   Lip Height: 4 mm.
            *   Wait, "rectangular lip on top of it - a 1.5 mm thick wall, 4 mm tall".
            *   Does "1.5 mm thick wall" mean the wall thickness of the lip structure?
            *   Usually, a lip is a raised rim.
            *   If the outer size is 65.6 x 45.6, and the plate is 70 x 50.
            *   The lip sits on the plate.
            *   So the lip is a hollow box shape sitting on the plate? Or a solid block with a hole?
            *   "rectangular lip on top of it... whose outer size is 65.6 x 45.6 mm".
            *   This implies the lip is a frame.
            *   Plate: 70x50x2.
            *   Lip: Outer 65.6x45.6. Inner hole?
            *   If it slides into the box opening (66x46), the lip must be smaller than the opening.
            *   Lip Outer: 65.6 x 45.6.
            *   Lip Inner (hole): Outer - 2 * Wall Thickness.
            *   Wall Thickness = 1.5 mm.
            *   Lip Inner = 65.6 - 3 = 62.6 mm.
            *   Lip Inner = 45.6 - 3 = 42.6 mm.
            *   Wait, the box opening is 66 x 46.
            *   Lip Outer is 65.6 x 45.6.
            *   Clearance = (66 - 65.6) / 2 = 0.2 mm.
            *   So the Lip Outer fits into the Box Inner.
            *   The Lip Inner (hole) must be large enough to cover the board.
            *   The prompt doesn't specify the board size, just that it's an enclosure.
            *   I need to model the Lip as a solid block with a hole, or a frame.
            *   "rectangular lip on top of it - a 1.5 mm thick wall".
            *   This implies the lip is a frame.
            *   So the Lid consists of:
                1.  Base Plate (70x50x2).
                2.  Lip Frame (Outer 65.6x45.6, Inner Hole, Height 4, Wall 1.5).
            *   Wait, if the Lip is printed on top of the plate, does it have a bottom?
            *   Usually, a lid has a base plate and a rim.
            *   If the rim is 4mm tall and 1.5mm thick.
            *   The "Lip" is the raised part.
            *   So the Lid is a solid block 70x50x2 (base) + a frame on top.
            *   Wait, if I print them together, I should model them as separate parts in the script, but placed in the same scene.
            *   The prompt asks for "two-part enclosure... Put both parts in the same file, side by side on the bed".
            *   This implies I should model Part 1 and Part 2 separately in the code, then translate them to their positions.
            *   I should not merge them into one solid object (difference/union) unless necessary for the geometry, but they are separate physical parts.
            *   However, for the Lid geometry itself: "a plate 70 x 50 x 2 mm lying on the bed, with a rectangular lip on top of it".
            *   So the Lid is one object.
            *   The Box is one object.
            *   I will define `part1()` and `part2()` functions or just translate blocks.
            *   Given the rules ("Model the part..."), I should probably define the geometry of each part clearly.
            *   I will use `module box()` and `module lid()` to keep it clean, then translate them.
            *   Wait, Rule 3 says "Model the part...". It implies the file builds the part.
            *   I will write the code to generate both parts in the scene.

    *   **Lid Geometry Details:**
        *   Base: 70 x 50 x 2.
        *   Lip:
            *   Outer: 65.6 x 45.6.
            *   Height: 4.
            *   Wall: 1.5.
            *   This means the Lip is a hollow rectangular prism sitting on the Base.
            *   Lip Inner Dimensions:
                *   $X_{lip\_in} = 65.6 - 2 \times 1.5 = 62.6$.
                *   $Y_{lip\_in} = 45.6 - 2 \times 1.5 = 42.6$.
            *   Lip Position: Centered on the plate.
            *   Lip Z-Start: 2 (top of base).
            *   Lip Z-End: 2 + 4 = 6.
        *   Wait, "printed upside down".
        *   This means the Lid is oriented such that the plate is on the bed (Z=0).
        *   So the Lip is on top of the plate (Z=2 to Z=6).
        *   The Box is also on the bed (Z=0).
        *   The Box has an open top.
        *   The Lid slides into the Box.
        *   Wait, if the Lid is printed upside down (plate on bed), and the Box is printed upright (floor on bed).
        *   The Lid's lip goes *into* the Box.
        *   So the Lid's lip height (4mm) + Lid's base thickness (2mm) = 6mm total height.
        *   The Box height is 30mm.
        *   So the Lid fits inside the Box.
        *   Wait, "Place the lid on the +X side of the box".
        *   This refers to the printing position on the bed, not the assembly position.
        *   "Put both parts in the same file, side by side on the bed with a 10 mm gap between them".
        *   So I am printing them together as a single print job (two separate parts).
        *   The geometry of the Lid must be correct for it to fit the Box.
        *   The Lid's lip outer size (65.6 x 45.6) fits the Box's inner size (66 x 46).
        *   So the Lid is a flat plate with a raised rim.
        *   Wait, if the Lid is printed upside down (plate on bed), the rim is on top.
        *   When I put it in the Box, I flip it over.
        *   The rim slides into the box.
        *   Okay, geometry is consistent.

    *   **Variables:**
        *   Need to define all dimensions at the top.
        *   $X_{box\_out} = 70$
        *   $Y_{box\_out} = 50$
        *   $Z_{box\_out} = 30$
        *   $T_{box\_wall} = 2$
        *   $T_{box\_floor} = 2$
        *   $X_{lid\_plate} = 70$
        *   $Y_{lid\_plate} = 50$
        *   $T_{lid\_plate} = 2$
        *   $X_{lip\_out} = 65.6$
        *   $Y_{lip\_out} = 45.6$
        *   $T_{lip\_wall} = 1.5$
        *   $H_{lip} = 4$
        *   $Gap = 10$
        *   $Fn = 64$ (or more)

    *   **Difference Rule:**
        *   "In difference(), make every cutting shape extend 0.01-1 mm past the faces it cuts".
        *   For the Box:
            *   I need to subtract the inner volume.
            *   Box Outer: 70 x 50 x 30.
            *   Box Inner: 66 x 46 x 28.
            *   Floor is 2mm thick.
            *   So I can model the Box as a solid block 70x50x30, then subtract a block 66x46x28 starting at Z=2.
            *   Wait, the walls are 2mm.
            *   Outer X: 70. Inner X: 66.
            *   Outer Y: 50. Inner Y: 46.
            *   Outer Z: 30. Inner Z: 28 (Floor is 2mm).
            *   So I subtract a block: $X \in [-33, 33]$, $Y \in [-23, 23]$, $Z \in [2, 30]$.
            *   Wait, centering.
            *   Box Center: (0,0).
            *   Outer: $X \in [-35, 35]$, $Y \in [-25, 25]$, $Z \in [0, 30]$.
            *   Inner Void: $X \in [-33, 33]$, $Y \in [-23, 23]$, $Z \in [2, 30]$.
            *   Wait, Inner X = 66. Half = 33.
            *   Inner Y = 46. Half = 23.
            *   Inner Z = 28. Start = 2.
            *   So I subtract a block of size 66 x 46 x 28.
            *   To ensure clean cuts, I should extend the subtraction slightly.
            *   Rule 5: "extend 0.01-1 mm past the faces it cuts".
            *   So subtract block size: 66.02 x 46.02 x 28.01?
            *   Or just translate it slightly?
            *   Better to extend the dimensions of the cutting block.
            *   Cutting Block X: 66 + 0.02 = 66.02.
            *   Cutting Block Y: 46 + 0.02 = 46.02.
            *   Cutting Block Z: 28 + 0.01 = 28.01.
            *   Wait, if I extend the dimensions, I might cut into the walls too much.
            *   "extend ... past the faces it cuts".
            *   If I cut the top face (Z=30), I need to extend past Z=30.
            *   If I cut the inner vertical faces, I need to extend past X=33 and X=-33.
            *   So the cutting block should be slightly larger than the void.
            *   Void: X: -33 to 33. Y: -23 to 23. Z: 2 to 30.
            *   Cut Block: X: -33.01 to 33.01. Y: -23.01 to 23.01. Z: 2 to 30.01.
            *   This ensures the walls are slightly undercut or the cut is clean.
            *   Actually, usually for walls, you want the cut to be slightly larger than the void to ensure the walls are not exactly coplanar with the cut surface.
            *   So yes, extend the cutting block dimensions.

    *   **Lid Geometry:**
        *   Base: 70 x 50 x 2.
        *   Lip:
            *   Outer: 65.6 x 45.6.
            *   Height: 4.
            *   Wall: 1.5.
            *   Inner Hole: 62.6 x 42.6.
            *   Lip Z: 2 to 6.
            *   Lip X: -32.8 to 32.8.
            *   Lip Y: -22.8 to 22.8.
            *   Lip Inner X: -31.3 to 31.3.
            *   Lip Inner Y: -21.3 to 21.3.
            *   I need to create the Lip as a solid block with a hole.
            *   Or a frame.
            *   Since it's a "lip", it's a frame.
            *   I can model it as a solid block 65.6 x 45.6 x 4, then subtract the inner hole 62.6 x 42.6 x 4.
            *   Wait, the Lip sits on the Plate.
            *   So the Lid is the Union of (Plate) and (Lip).
            *   Plate: 70 x 50 x 2.
            *   Lip: 65.6 x 45.6 x 4 (at Z=2).
            *   Lip Hole: 62.6 x 42.6 x 4 (at Z=2).
            *   Wait, the Lip Wall is 1.5mm.
            *   Outer 65.6. Inner 62.6. Diff = 3. Wall = 1.5. Correct.
            *   Outer 45.6. Inner 42.6. Diff = 3. Wall = 1.5. Correct.
            *   So I will model the Lip as a block with a hole.
            *   Difference rule applies to the hole creation.
            *   Hole Block: 62.6 x 42.6 x 4.
            *   Extend hole block: 62.61 x 42.61 x 4.01.
            *   Wait, the Lip is on top of the Plate.
            *   So the Lid is one object.
            *   I will define `module lid()` which creates this object.
            *   Then translate it to X=40, Y=0, Z=0.
            *   Wait, the prompt says "Place the lid on the +X side of the box".
            *   So in the final scene, Lid is at X=40.
            *   Box is at X=-40.
            *   Wait, I need to check the Z position.
            *   Both rest on the bed (Z=0).
            *   So Lid Z=0. Box Z=0.

    *   **Refining Placement:**
        *   Box Center X = -40.
        *   Lid Center X = 40.
        *   Both Y = 0.
        *   Both Z = 0.
        *   This puts the gap at X=0.
        *   Box Right Edge = -40 + 35 = -5.
        *   Lid Left Edge = 40 - 35 = 5.
        *   Gap = 10.
        *   This works.

    *   **Refining Lid Orientation:**
        *   "Part 2, the lid, printed upside down: a plate 70 x 50 x 2 mm lying on the bed".
        *   This means the flat face of the plate is on Z=0.
        *   The lip is on top (Z=2 to Z=6).
        *   This matches my plan.

    *   **Refining Box Orientation:**
        *   "Part 1, the box: outer size 70 x 50 x 30 mm... open top".
        *   Floor on bed (Z=0).
        *   Walls up to Z=30.
        *   This matches my plan.

    *   **Code Structure:**
        *   Variables at top.
        *   $fn = 64$ (or higher for holes).
        *   Module `box()`:
            *   Translate to X=-40.
            *   Cube (70, 50, 30).
            *   Difference:
                *   Translate to inner void.
                *   Cube (66.02, 46.02, 28.01). (Extended dimensions).
        *   Module `lid()`:
            *   Translate to X=40.
            *   Union:
                *   Plate: Cube (70, 50, 2).
                *   Lip:
                    *   Translate to Z=2.
                    *   Cube (65.6, 45.6, 4).
                    *   Difference:
                        *   Translate to inner hole.
                        *   Cube (62.61, 42.61, 4.01). (Extended dimensions).
        *   Wait, I need to make sure the Lid Lip doesn't merge with the Plate in a way that creates non-manifold geometry if I don't separate them.
        *   Actually, `union` of Plate and Lip is fine.
        *   Wait, the Lip sits *on* the Plate.
        *   So the Lip Z range is 2 to 6.
        *   Plate Z range is 0 to 2.
        *   They touch at Z=2.
        *   This is fine.
        *   Wait, the Lip is a frame.
        *   So I need to subtract the hole from the Lip block.
        *   Lip Block: 65.6 x 45.6 x 4.
        *   Lip Hole: 62.6 x 42.6 x 4.
        *   Wait, the Lip is centered on the Plate.
        *   Plate Center: 0,0.
        *   Lip Center: 0,0.
        *   So Lip X: -32.8 to 32.8.
        *   Lip Y: -22.8 to 22.8.
        *   Lip Hole X: -31.3 to 31.3.
        *   Lip Hole Y: -21.3 to 21.3.
        *   Wait, I need to check the clearance again.
        *   Box Inner: 66 x 46.
        *   Lip Outer: 65.6 x 45.6.
        *   Clearance: 0.2 mm.
        *   This is correct.
        *   Wait, the Lip is printed on the bed.
        *   So the Lid is a single object.
        *   I will use `module lid()` to encapsulate the geometry.

    *   **Wait, one detail:**
        *   "Put both parts in the same file, side by side on the bed with a 10 mm gap between them, so they print together."
        *   This implies I should not use `module` calls that hide the translation logic, or I should just call the modules at the end.
        *   I will define modules for clarity and call them at the end.
        *   Wait, Rule 3: "Model the part in the print orientation the user gives... Unless told otherwise, centre it on the origin in X and Y."
        *   This rule applies to the *part* modeling.
        *   But the user instruction overrides this for the *assembly* ("Place the lid on the +X side of the box").
        *   So I will model the parts centered at (0,0) internally, then translate them to their assembly positions.
        *   Or I can model them directly at their assembly positions.
        *   Usually, it's cleaner to model the part geometry centered, then translate.
        *   I'll do that.

    *   **Wait, another detail:**
        *   "In difference(), make every cutting shape extend 0.01-1 mm past the faces it cuts".
        *   For the Box:
            *   Outer: 70 x 50 x 30.
            *   Inner Void: 66 x 46 x 28.
            *   Cut Block: 66.02 x 46.02 x 28.01.
            *   Position: Z=2.
            *   Wait, if I extend Z to 28.01, it cuts past the top face (Z=30)?
            *   No, the void starts at Z=2 and goes to Z=30.
            *   The cut block should go from Z=2 to Z=30.01.
            *   Wait, the Box Top is at Z=30.
            *   The Void Top is at Z=30.
            *   So the cut block should extend past Z=30.
            *   So Z range: 2 to 30.01.
            *   X range: -33 to 33.
            *   Cut X range: -33.01 to 33.01.
            *   Y range: -23 to 23.
            *   Cut Y range: -23.01 to 23.01.
        *   For the Lid Lip Hole:
            *   Lip Block: 65.6 x 45.6 x 4.
            *   Lip Hole: 62.6 x 42.6 x 4.
            *   Cut Block: 62.61 x 42.61 x 4.01.
            *   Position: Z=2.
            *   Wait, the Lip is on top of the Plate.
            *   So the Lip Block is at Z=2 to Z=6.
            *   The Hole is at Z=2 to Z=6.
            *   So the Cut Block Z range: 2 to 6.01.
            *   X range: -32.8 to 32.8.
            *   Cut X range: -32.81 to 32.81.
            *   Y range: -22.8 to 22.8.
            *   Cut Y range: -22.81 to 22.81.

    *   **Wait, one more check:**
        *   "Part 2, the lid, printed upside down: a plate 70 x 50 x 2 mm lying on the bed".
        *   This means the Plate is the bottom part of the Lid.
        *   So the Lid is a single object.
        *   I will model the Lid as a Union of Plate and Lip.
        *   Lip is a Difference of Block and Hole.
        *   Plate is a Cube.
        *   Union them.
        *   Translate to X=40.

    *   **Wait, one more check on Box:**
        *   "2 mm walls, 2 mm floor, open top".
        *   Outer: 70 x 50 x 30.
        *   Floor: 2mm.
        *   Walls: 2mm.
        *   So Inner Height = 30 - 2 = 28.
        *   Inner Width = 70 - 4 = 66.
        *   Inner Depth = 50 - 4 = 46.
        *   Correct.

    *   **Wait, one more check on Lid Lip:**
        *   "rectangular lip on top of it - a 1.5 mm thick wall, 4 mm tall".
        *   "whose outer size is 65.6 x 45.6 mm".
        *   "centred on the plate".
        *   So Lip Outer: 65.6 x 45.6.
        *   Lip Height: 4.
        *   Lip Wall: 1.5.
        *   Lip Inner: 65.6 - 3 = 62.6.
        *   Lip Inner: 45.6 - 3 = 42.6.
        *   Correct.

    *   **Wait, one more check on Placement:**
        *   "Place the lid on the +X side of the box".
        *   "Put both parts in the same file, side by side on the bed with a 10 mm gap between them".
        *   Box Center X = -40.
        *   Lid Center X = 40.
        *   Gap = 10.
        *   This puts the gap at X=0.
        *   Box Right Edge = -5.
        *   Lid Left Edge = 5.
        *   Gap = 10.
        *   Correct.

    *   **Wait, one more check on Variables:**
        *   "Put every dimension in a named variable at the top of the file, with a short comment."
        *   I need to list all dimensions used.
        *   $X_{box\_out}$, $Y_{box\_out}$, $Z_{box\_out}$.
        *   $T_{box\_wall}$, $T_{box\_floor}$.
        *   $X_{lid\_plate}$, $Y_{lid\_plate}$, $T_{lid\_plate}$.
        *   $X_{lip\_out}$, $Y_{lip\_out}$, $T_{lip\_wall}$, $H_{lip}$.
        *   $Gap$.
        *   $Fn$.
        *   I should also calculate derived dimensions (Inner sizes) in variables for clarity, or just use expressions.
        *   Rule 2: "Put every dimension in a named variable".
        *   I should probably define the inner dimensions as variables too to be safe.
        *   $X_{box\_in}$, $Y_{box\_in}$, $Z_{box\_in}$.
        *   $X_{lip\_in}$, $Y_{lip\_in}$.
        *   $X_{box\_pos}$, $X_{lid\_pos}$.

    *   **Wait, one more check on $fn$:**
        *   "Set $fn = 64 (or more) on curved shapes".
        *   There are no curved shapes in this design (all rectangular).
        *   However, holes should be round?
        *   "so holes come out round and to size".
        *   Wait, the holes are rectangular (slots/voids).
        *   "holes come out round" usually implies circular holes.
        *   But here the holes are rectangular.
        *   Maybe the user implies that if there were curves, set $fn$.
        *   But for rectangular holes, $fn$ doesn't matter much unless there are fillets.
        *   I