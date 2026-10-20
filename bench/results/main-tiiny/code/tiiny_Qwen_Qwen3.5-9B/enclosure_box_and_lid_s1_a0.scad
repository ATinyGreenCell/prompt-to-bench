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

// Verify clearance math:
// Plate width 70. Lip outer 65.6. Gap = 70 - 65.6 = 4.4.
// Half gap = 2.2.
// Lip inner width = 65.6 - (2 * 1.5) = 62.6.
// Clearance = (70 - 62.6) / 2 = 3.7. 
// Wait, the prompt says "0.2 mm clearance on each side".
// Let's re-read: "outer size is 65.6 x 45.6 mm, centred on the plate, so it slides into the box opening with 0.2 mm clearance on each side."
// This implies the clearance is between the LID LIP INNER and the BOX INNER.
// Box Inner Width = 70 - 4 = 66 mm.
// Lid Lip Outer Width = 65.6 mm.
// Lid Lip Inner Width = 65.6 - 3 = 62.6 mm.
// Gap between Lid Lip Inner and Box Inner = 66 - 62.6 = 3.4 mm.
// Clearance per side = 1.7 mm.
// 
// There is a contradiction in the prompt's numbers vs the "0.2mm clearance" statement if we assume standard box construction.
// However, the prompt explicitly gives the dimensions: "outer size is 65.6 x 45.6 mm".
// And explicitly states: "slides into the box opening with 0.2 mm clearance on each side".
// If the box inner is 66mm, and clearance is 0.2mm, the lip inner must be 65.6mm.
// If lip inner is 65.6mm and lip wall is 1.5mm, lip outer must be 65.6 + 3 = 68.6mm.
// But the prompt says lip outer is 65.6mm.
// 
// Interpretation: The user likely calculated the 65.6mm based on the 0.2mm clearance requirement relative to the box inner, but forgot to account for the wall thickness in the "outer size" description, OR the box inner is different.
// Let's look at the Box Outer: 70. Wall: 2. Box Inner = 66.
// If Lip Outer is 65.6, and it sits on a 70 plate, the gap between plate and lip is (70-65.6)/2 = 2.2mm.
// If the user wants 0.2mm clearance between the lip and the box walls, the lip inner needs to be 66 - 0.4 = 65.6mm.
// If Lip Inner is 65.6 and Wall is 1.5, Lip Outer must be 68.6.
// 
// Given the explicit instruction "outer size is 65.6 x 45.6 mm", I will use 65.6 as the outer dimension of the lip.
// The resulting fit might be tight or loose depending on the exact box inner, but I must follow the explicit dimension "65.6".
// Actually, re-reading carefully: "outer size is 65.6... centred on the plate... slides into the box opening".
// Maybe the user considers the "outer size" of the lip to be the dimension that matches the box inner minus clearance?
// No, "outer size" usually means the outside of the lip.
// Let's stick to the explicit numbers provided for the Lid geometry, as they are specific measurements.
// Lid Plate: 70x50x2.
// Lip: Outer 65.6x45.6, Wall 1.5, Height 4.
// Position: +X side, 10mm gap.

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
    rotate([0, 0, 0]) // Ensure correct orientation
    box_part;

translate([box_outer_w + 10, 0, 0])
    rotate([180, 0, 0]) // Rotate lid 180 deg around X to be "upside down" relative to its natural build, 
                        // effectively putting the 2mm face on the bed and the lip pointing UP.
                        // Wait, if I build the lid as Base + Lip (Lip up), and rotate 180 X, 
                        // the Base (which was on Z=0) flips to Z=0? 
                        // No. 
                        // Original Lid: Base at Z=0..2. Lip at Z=2..6.
                        // Rotate 180 X: 
                        // Point (x, y, z) -> (-x, y, -z).
                        // Base (0,0,0) -> (0,0,0). Base (0,0,2) -> (0,0,-2).
                        // This flips the lid upside down so the lip points DOWN into the box.
                        // BUT the prompt says: "Part 2, the lid, printed upside down: a plate ... lying on the bed".
                        // This implies