// Two-part enclosure for small electronics board
// Part 1: Box (left)
// Part 2: Lid (right, printed upside down)
// Prints together with a 10 mm gap.

$fn = 64;

// --- Dimensions ---

// Part 1: Box
// Outer dimensions (X x Y x Z)
BOX_OUT_X = 70;
BOX_OUT_Y = 50;
BOX_OUT_Z = 30;
// Wall thicknesses
BOX_WALL_THICK = 2;
BOX_FLOOR_THICK = 2;

// Part 2: Lid
// Base plate dimensions
LID_PLATE_X = 70;
LID_PLATE_Y = 50;
LID_PLATE_THICK = 2;
// Lip dimensions (outer size of the lip)
LIP_OUT_X = 65.6;
LIP_OUT_Y = 45.6;
LIP_THICK = 1.5;
LIP_HEIGHT = 4;

// Layout
// 10 mm gap between parts
GAP = 10;

// --- Part 1: The Box ---
// Rests on XY plane, centered on origin.
// Dimensions: 70 x 50 x 30
// Walls: 2mm, Floor: 2mm, Open top.

translate([0, 0, 0])
difference() {
    // Outer block
    cube([BOX_OUT_X, BOX_OUT_Y, BOX_OUT_Z], center = false);
    
    // Cut out the inside (hollow)
    // Inner X = 70 - 2*2 = 66
    // Inner Y = 50 - 2*2 = 46
    // Inner Z = 30 - 2 (floor) = 28
    translate([BOX_WALL_THICK, BOX_WALL_THICK, BOX_FLOOR_THICK])
    cube([
        BOX_OUT_X - (2 * BOX_WALL_THICK),
        BOX_OUT_Y - (2 * BOX_WALL_THICK),
        BOX_OUT_Z - BOX_FLOOR_THICK
    ], center = false);
    
    // Extend cut slightly to ensure clean separation from walls
    translate([BOX_WALL_THICK, BOX_WALL_THICK, BOX_FLOOR_THICK])
    cube([
        BOX_OUT_X - (2 * BOX_WALL_THICK) + 0.1,
        BOX_OUT_Y - (2 * BOX_WALL_THICK) + 0.1,
        BOX_OUT_Z - BOX_FLOOR_THICK + 0.1
    ], center = false);
}

// --- Part 2: The Lid ---
// Printed upside down.
// Base plate: 70 x 50 x 2 mm.
// Lip: 1.5 mm thick wall, 4 mm tall.
// Lip outer size: 65.6 x 45.6 mm.
// Position: On the +X side of the box (centered vertically on the bed).
// Since the box is centered at X=0, and the gap is 10mm, the box occupies X=-35 to X=35.
// The gap is X=35 to X=45.
// The lid should start at X=45.
// Lid width = 70. Center of lid = 45 + 35 = 80.
// So translate X by 80.

translate([80, 0, 0])
difference() {
    // 1. The Base Plate
    // Dimensions: 70 x 50 x 2
    cube([LID_PLATE_X, LID_PLATE_Y, LID_PLATE_THICK], center = false);
    
    // 2. The Lip (printed upside down, so it hangs "down" from the top face of the plate)
    // The lip is a rectangular wall.
    // Outer size: 65.6 x 45.6
    // Thickness: 1.5
    // Height: 4
    // It sits on top of the plate (Z=2 relative to plate start).
    
    // Calculate inner dimensions of the lip hole
    LIP_IN_X = LIP_OUT_X - LIP_THICK;
    LIP_IN_Y = LIP_OUT_Y - LIP_THICK;
    
    // Position of the lip relative to the plate center
    // Plate is centered at 0,0 relative to itself.
    // Lip is centered on the plate.
    translate([0, 0, LID_PLATE_THICK])
    // The lip is a hollow box shape (a frame)
    difference() {
        // Outer volume of the lip
        cube([LIP_OUT_X, LIP_OUT_Y, LIP_HEIGHT], center = false);
        
        // Inner void of the lip
        // Extend slightly past the face to ensure clean cut
        translate([LIP_THICK/2, LIP_THICK/2, 0])
        cube([
            LIP_IN_X - 0.05,
            LIP_IN_Y - 0.05,
            LIP_HEIGHT + 0.05
        ], center = false);
    }
}