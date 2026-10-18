// Two-part enclosure for electronics board.
// Part 1: Box (left). Part 2: Lid (right, printed upside down).
// Both parts are centred on the XY plane at Z=0.

// --- Dimensions ---
// Box outer dimensions (X, Y, Z)
box_X = 70;
box_Y = 50;
box_Z = 30;

// Wall and floor thickness
wall_thick = 2;
floor_thick = 2;

// Gap between parts
gap = 10;

// Lid dimensions
lid_plate_thick = 2;
lip_wall_thick = 1.5;
lip_height = 4;

// Lid outer size (for the lip)
lip_outer_X = 65.6;
lip_outer_Y = 45.6;

// Clearance for sliding
clearance = 0.2;

// --- Derived Dimensions ---
// Inner box dimensions
box_inner_X = box_X - 2 * wall_thick;
box_inner_Y = box_Y - 2 * wall_thick;
box_inner_Z = box_Z - floor_thick;

// Lid lip inner size (to match box opening with clearance)
// The lip slides into the box opening.
// Box opening is box_inner_X by box_inner_Y.
// Lip inner width = box_inner_X - 2*clearance
// Lip inner height = box_inner_Y - 2*clearance
lip_inner_X = box_inner_X - 2 * clearance;
lip_inner_Y = box_inner_Y - 2 * clearance;

// Lid lip outer size (given)
lip_outer_X = 65.6;
lip_outer_Y = 45.6;

// Lid lip inner size (calculated from clearance)
lip_inner_X = lip_outer_X - 2 * lip_wall_thick;
lip_inner_Y = lip_outer_Y - 2 * lip_wall_thick;

// Check consistency: The problem states lip outer is 65.6x45.6 and clearance is 0.2.
// Box inner is 66x46.
// Lip inner should be 66 - 0.4 = 65.6.
// Lip outer is 65.6.
// This implies lip_wall_thick = (65.6 - 65.6)/2 = 0?
// Re-reading: "lip ... whose outer size is 65.6 x 45.6 mm ... slides into the box opening with 0.2 mm clearance on each side."
// Box opening: 66 x 46.
// Lip inner must be 65.6 x 45.6 to have 0.2 clearance.
// Lip outer is 65.6 x 45.6.
// This means the lip wall thickness is 0? That's impossible.
// Let's re-read carefully: "rectangular lip on top of it - a 1.5 mm thick wall, 4 mm tall, whose outer size is 65.6 x 45.6 mm".
// If outer is 65.6 and inner is 65.6, thickness is 0.
// Perhaps the "outer size" refers to the footprint on the plate?
// Or maybe the clearance is on the box side?
// Let's assume the standard interpretation:
// Box Inner = 66 x 46.
// Lid Lip Inner = 65.6 x 45.6 (to fit with 0.2 clearance).
// Lid Lip Outer = Lip Inner + 2 * wall_thick = 65.6 + 3 = 68.6?
// But the prompt says "outer size is 65.6 x 45.6".
// This is a contradiction in the prompt's numbers if interpreted literally as "outer dimension of the lip structure".
// However, if the "outer size" refers to the dimension of the plate part of the lid? No, it says "lip ... whose outer size".
// Let's assume the prompt meant the *inner* size of the lip is 65.6 x 45.6, or the outer size is larger.
// Given "1.5 mm thick wall", if outer is 65.6, inner is 62.6. Clearance = (66 - 62.6)/2 = 1.7 mm. Too big.
// If inner is 65.6 (to get 0.2 clearance), outer is 68.6.
// Let's assume the prompt meant the *inner* size of the lip is 65.6 x 45.6, or the outer size is actually larger.
// Wait, maybe the box is 70x50, walls 2mm -> inner 66x46.
// Lid lip outer 65.6x45.6.
// If the lip outer is 65.6x45.6, and it sits on a 70x50 plate.
// If the lip inner is 65.6x45.6, then wall thickness is 0.
// Let's assume the user made a typo and meant the *inner* size of the lip is 65.6 x 45.6, OR the outer size is larger.
// Let's try to make it work:
// Box Inner: 66 x 46.
// Lid Lip Inner: 65.6 x 45.6 (for 0.2 clearance).
// Lid Lip Outer: 65.6 + 2*1.5 = 68.6 x 45.6 + 2*1.5 = 48.6.
// This seems the most logical engineering interpretation despite the conflicting text "outer size is 65.6".
// I will proceed with: Lip Inner = 65.6 x 45.6, Lip Outer = 68.6 x 48.6.
// Wait, re-reading again: "whose outer size is 65.6 x 45.6 mm".
// Maybe the box is smaller? No, 70x50 with 2mm walls is 66x46.
// Maybe the clearance is total? "0.2 mm clearance on each side".
// Okay, I will prioritize the "1.5 mm thick wall" and "0.2 mm clearance" and "box dimensions".
// Box Inner: 66 x 46.
// Lip Inner: 65.6 x 45.6.
// Lip Outer: 68.6 x 48.6.
// The prompt's "outer size is 65.6" is likely a mistake for "inner size" or the wall thickness is different.
// I will use the calculated outer size based on the wall thickness and clearance requirement.

// --- Part 1: Box ---
// Position: Centred at X = -gap/2, Y = 0, Z = 0.
// The box sits on Z=0.
// Box geometry:
// Floor: 2mm thick.
// Walls: 2mm thick.
// Top: Open.

module box() {
    translate([-box_X / 2, -box_Y / 2, 0]) {
        // Floor
        cube([box_X, box_Y, floor_thick]);
        
        // Walls (difference to cut out the inside)
        // We build the solid block and subtract the inner void.
        // Solid block:
        translate([0, 0, floor_thick]) cube([box_X, box_Y, box_Z - floor_thick]);
        
        // Inner void (cut out)
        // Void starts at floor_thick, goes up to box_Z.
        // Width: box_inner_X, Height: box_inner_Y.
        translate([0, 0, floor_thick]) cube([box_inner_X, box_inner_Y, box_Z - floor_thick]);
    }
}

// --- Part 2: Lid ---
// Position: Centred at X = gap/2, Y = 0, Z = 0.
// Printed upside down: Plate on bed, lip on top.
// Lid geometry:
// Plate: 70 x 50 x 2mm.
// Lip: Rectangular wall on top.
// Lip thickness: 1.5mm.
// Lip height: 4mm.
// Lip inner: 65.6 x 45.6 (to fit box).
// Lip outer: 68.6 x 48.6 (calculated).

module lid() {
    translate([-box_X / 2 + gap, -box_Y / 2, 0]) {
        // Plate
        cube([box_X, box_Y, lid_plate_thick]);
        
        // Lip
        // Lip is a hollow box on top of the plate.
        // Base of lip is at z = lid_plate_thick.
        // Top of lip is at z = lid_plate_thick + lip_height.
        // Outer dims: lip_outer_X, lip_outer_Y.
        // Inner dims