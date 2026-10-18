// Two-part enclosure for electronics board.
// Part 1: Box (left) - 70x50x30mm outer, 2mm walls/floor, open top.
// Part 2: Lid (right) - 70x50x2mm plate with 4mm tall lip (1.5mm wall), 65.6x45.6mm outer lip.
// Parts are side-by-side with a 10mm gap. Lid is printed upside down (lip facing down) to slide in.

// Dimensions
BOX_X  = 70;
BOX_Y  = 50;
BOX_Z  = 30;
WALL   = 2;
FLOOR  = 2;

LID_PLATE_X = 70;
LID_PLATE_Y = 50;
LID_PLATE_Z = 2;

LIP_WALL_THICKNESS = 1.5;
LIP_HEIGHT = 4;
LIP_OUT_X = 65.6;
LIP_OUT_Y = 45.6;

// Gap between parts
GAP = 10;

// Derived dimensions for the box
BOX_IN_X = BOX_X - 2 * WALL;
BOX_IN_Y = BOX_Y - 2 * WALL;
BOX_IN_Z = BOX_Z - FLOOR; // Open top, so height is just wall + floor

// Derived dimensions for the lid lip
// Lip outer size is 65.6 x 45.6. Plate is 70 x 50.
// Clearance = (70 - 65.6) / 2 = 2.2 mm total, 1.1 mm each side.
// Clearance = (50 - 45.6) / 2 = 2.2 mm total, 1.1 mm each side.
// The prompt asks for 0.2mm clearance. Let's re-read carefully.
// "whose outer size is 65.6 x 45.6 mm... so it slides into the box opening with 0.2 mm clearance on each side."
// Box opening is 66 x 46 (70-2*2, 50-2*2).
// Lip outer is 65.6 x 45.6.
// Gap between Lip Outer and Box Inner = (66 - 65.6) / 2 = 0.2 mm. Correct.

$fn = 64;

// --- Part 1: The Box ---
// Constructed by extruding a 2D profile.
// Profile: Bottom wall (FLOOR), Side walls (WALL), Top opening.
// We build the solid block and subtract the empty space inside.

difference() {
    // Main block
    translate([0, 0, 0]) 
        cube([BOX_X, BOX_Y, BOX_Z]);
    
    // Cut out the empty interior
    // Interior dimensions:
    // X: from WALL to BOX_X - WALL
    // Y: from WALL to BOX_Y - WALL
    // Z: from FLOOR to BOX_Z - WALL (since top is open)
    
    translate([WALL, WALL, FLOOR]) 
        cube([BOX_IN_X, BOX_IN_Y, BOX_IN_Z - WALL]);
}

// --- Part 2: The Lid ---
// Constructed as a plate with a lip.
// The lid is printed upside down relative to the box opening, meaning the lip faces the box.
// However, the prompt says "Place the lid on the +X side of the box".
// If the lid is printed "upside down" (lip facing down), and placed on +X, it will sit next to the box.
// To slide it in, the user would flip it over after printing, or the design implies the lip is the bottom surface.
// Given "printed upside down: a plate ... with a rectangular lip on top of it", this phrasing is slightly ambiguous.
// Usually, "printed upside down" means the part is inverted in Z.
// Let's interpret: The physical part has a plate and a lip. The lip is 4mm tall.
// If printed normally, lip is up. If printed upside down, lip is down.
// To slide into the box (which has an open top), the lip must be the bottom surface of the lid assembly.
// So we model the lid with the lip extending downwards from the plate.

module lid() {
    // Plate base
    translate([0, 0, 0]) 
        cube([LID_PLATE_X, LID_PLATE_Y, LID_PLATE_Z]);
    
    // Lip
    // The lip is on the plate. If printed upside down, the lip extends in -Z direction.
    // Lip outer size: 65.6 x 45.6.
    // Lip thickness: 1.5.
    // Lip height: 4.
    // Centered on the plate.
    
    translate([
        (LID_PLATE_X - LIP_OUT_X) / 2,
        (LID_PLATE_Y - LIP_OUT_Y) / 2,
        -LIP_HEIGHT // Extend downwards
    ]) 
        cube([LIP_OUT_X, LIP_OUT_Y, LIP_WALL_THICKNESS]);
}

// --- Assembly ---
// Place Box at origin.
// Place Lid on +X side with GAP.
// Lid is placed such that its lip faces the box (downwards in Z relative to the lid's local frame if we consider the plate as top, but here we built the lip down).
// Since we built the lip down from the plate, and we place the lid next to the box, the lip will be adjacent to the box opening.

translate([0, 0, 0])
    difference() {
        // Box
        translate([0, 0, 0]) 
            cube([BOX_X, BOX_Y, BOX_Z]);
        
        // Interior of box
        translate([WALL, WALL, FLOOR]) 
            cube([BOX_IN_X, BOX_IN_Y, BOX_IN_Z - WALL]);
    }

translate([BOX_X + GAP, 0, 0])
    lid();