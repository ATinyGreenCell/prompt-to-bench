$fn = 64;

// --- Part 1: The Box ---
// Outer dimensions: 70 x 50 x 30 mm (X x Y x Z)
// Wall thickness: 2 mm
// Floor thickness: 2 mm
// Position: Left side, resting on XY plane (Z=0)

box_outer_w = 70;
box_outer_d = 50;
box_outer_h = 30;
wall_thickness = 2;
floor_thickness = 2;

// Calculate inner dimensions for the box
box_inner_w = box_outer_w - (2 * wall_thickness);
box_inner_d = box_outer_d - (2 * wall_thickness);
box_inner_h = box_outer_h - floor_thickness;

// The box is a hollow prism. We create the outer block and subtract the inner void.
// The void starts at Z = floor_thickness and goes up to Z = box_outer_h.
box_part = difference() {
    // Outer block
    translate([0, 0, 0]) 
        cube([box_outer_w, box_outer_d, box_outer_h]);
    
    // Inner void (hole)
    translate([wall_thickness, wall_thickness, floor_thickness])
        cube([box_inner_w, box_inner_d, box_inner_h]);
};

// --- Part 2: The Lid ---
// Printed upside down (resting on its "top" surface initially, then flipped)
// Base plate: 70 x 50 x 2 mm
// Lip: 1.5 mm thick wall, 4 mm tall
// Lip outer size: 65.6 x 45.6 mm (centred on plate)
// Clearance: 0.2 mm on each side (Total gap = 0.4mm)
// Position: Right side, 10 mm gap from box, resting on XY plane (Z=0)

lid_plate_w = 70;
lid_plate_d = 50;
lid_plate_h = 2;

lip_wall_thickness = 1.5;
lip_height = 4;
lip_outer_w = 65.6;
lip_outer_d = 45.6;
clearance = 0.2;

// Create the Lid geometry
// Since the lid is printed upside down, we model it as a plate with a lip sticking UP, then rotate it 180 around X.
// Or, model it as a plate, add a lip, then rotate. The final orientation must be "resting on the bed".
// "Printed upside down: a plate ... lying on the bed". This means the 2mm thick face is on the bed.
// The lip sticks UP from that plate.

lid_base = cube([lid_plate_w, lid_plate_d, lid_plate_h]);

// The lip is a rectangular block sitting on top of the base.
// Outer dims: 65.6 x 45.6.
// Inner dims (hole): 65.6 - 3 = 62.6.
// Height: 4.
// Position: Centred on the plate.
lip_block = cube([lip_outer_w, lip_outer_d, lip_height]);
lip_hole = cube([lip_outer_w - (2*lip_wall_thickness), lip_outer_d - (2*lip_wall_thickness), lip_height]);

lid_part = union() {
    translate([0, 0, 0]) lid_base;
    translate([0, 0, lip_plate_h]) lip_block;
    translate([lip_outer_w/2 - (lip_outer_w - (2*lip_wall_thickness))/2, 
                 lip_outer_d/2 - (lip_outer_d - (2*lip_wall_thickness))/2, 
                 lip_plate_h]) 
        lip_hole;
};

// --- Assembly ---
// Place Box at origin.
// Place Lid on +X side with 10mm gap.
// Box width is 70. Lid starts at 70 + 10 = 80.

translate([0, 0, 0])
    box_part;

// The lid needs to be placed on the +X side.
// The prompt says "Part 2, the lid, printed upside down".
// If we build the lid as Base (on bed) + Lip (up), and then rotate it 180 degrees around X,
// the Base (which was on Z=0) will flip to Z=0 (since it's a flat plate on the axis of rotation? No).
// Let's trace coordinates:
// Base: Z from 0 to 2. Center Y=25. Center X=35.
// Rotate 180 X: (x, y, z) -> (-x, y, -z).
// Base Z=0 -> Z=0. Base Z=2 -> Z=-2.
// This flips the lid upside down so the lip points DOWN into the box.
// BUT the prompt says: "Part 2, the lid, printed upside down: a plate ... lying on the bed".
// This implies the plate is on the bed.
// If the plate is on the bed, and the lip is on the plate, the lip must point UP (away from the bed) to fit over the box.
// Wait, "printed upside down" usually means the part is inverted relative to its design orientation.
// If the design is "Plate on bottom, Lip on top", printing it "upside down" means "Plate on top, Lip on bottom".
// But the prompt says "a plate ... lying on the bed". This contradicts "upside down" if the lip is to go over the box.
// Unless... the "lip" is actually a recess? No, "slides into the box opening".
// Let's re-read carefully: "Part 2, the lid, printed upside down: a plate 70 x 50 x 2 mm lying on the bed, with a rectangular lip on top of it".
// This is physically impossible if "upside down" means inverted.
// If the plate is on the bed, and the lip is on top of it, the lip points UP.
// If the lip points UP, it cannot slide into the box (which is below it) unless the box is inverted too.
// But the box is "open top".
// 
// Alternative interpretation: The user wants the LID to be the part that covers the box.
// The LID has a plate and a lip.
// If the LID is printed "upside down", maybe the "plate" is the top surface and the "lip" is the bottom edge?
// No, "with a rectangular lip on top of it".
// 
// Let's assume the user made a slight confusion in terminology and simply wants:
// 1. Box: 70x50x30, open top.
// 2. Lid: A part that fits over the box.
// 3. The Lid is composed of a 70x50x2 plate and a 4mm tall lip.
// 4. The Lid is placed on the +X side.
// 5. The Lid must fit over the box.
// 
// If the Lid is a "plate with a lip on top", and it sits on the bed, the lip points UP.
// The Box is on the bed, open top.
// The Lid cannot fit over the Box if the Lip points UP and the Box is below.
// UNLESS the Lid is placed *inside* the box? No, "enclosure".
// 
// Maybe the "lip" is actually a *flange* that goes *under* the box rim?
// If the lip is 4mm tall and the box wall is 2mm, the lip must go under the rim.
// So the Lid must be inverted: Plate on top, Lip pointing DOWN.
// But the prompt says "plate ... lying on the bed".
// 
// Let's try this: The user wants two separate parts printed together.
// Part 1: Box.
// Part 2: Lid.
// The Lid is described as "printed upside down".
// Maybe the user means the *orientation* of the print is inverted compared to the box?
// If I print the Lid as: Plate (70x50x2) on the bed, and Lip (4mm tall) sticking UP.
// And I place it next to the Box.
// Then I rotate the whole assembly? No, "rests on the bed".
// 
// Let's reconsider the "upside down" instruction.
// If I print a part "upside down", I usually mean I rotate the model 180 degrees before printing.
// If the model is "Plate bottom, Lip top", printing it upside down gives "Plate top, Lip bottom".
// If the Lid is "Plate top, Lip bottom", and it rests on the bed, the Plate is in the air.
// This contradicts "plate ... lying on the bed".
// 
// Is it possible the user means the Lid is a *bottom* part? No, "enclosure", "lid".
// Is it possible the "lip" is actually a *hole*? No, "rectangular lip".
// 
// Let's assume the user's description of the Lid geometry