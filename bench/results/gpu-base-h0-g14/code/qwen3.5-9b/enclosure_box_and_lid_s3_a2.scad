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

// --- Layout ---
// Gap between parts
PART_GAP = 10;

// --- Part 1: The Box ---
// Position: Centered on origin in X, Y, Z=0.
// We build the floor and walls.
// We use difference to subtract the empty interior starting above the floor.

translate([0, 0, 0])
difference() {
    // 1. The solid block representing the outer volume
    cube([BOX_OUT_X, BOX_OUT_Y, BOX_OUT_Z], center = false);
    
    // 2. The empty interior to subtract
    // Inner dimensions:
    // X: 70 - 2*2 = 66
    // Y: 50 - 2*2 = 46
    // Z: Starts at BOX_FLOOR_THICK (2mm) and goes up to the top.
    translate([
        BOX_WALL_THICK, 
        BOX_WALL_THICK, 
        BOX_FLOOR_THICK // Start subtraction 2mm up from bed to leave the floor
    ])
    cube([
        BOX_OUT_X - (2 * BOX_WALL_THICK),
        BOX_OUT_Y - (2 * BOX_WALL_THICK),
        BOX_OUT_Z - BOX_FLOOR_THICK // Height of the empty space
    ]);
}

// --- Part 2: The Lid ---
// Position: On the +X side of the box.
// Box center X = 35. Box right edge = 70.
// Lid left edge = 70 + 10 = 80.
// Lid center X = 80 + (70/2) = 115.
// Lid is printed upside down: Plate on bed (Z=0), Lip on top.

translate([
    BOX_OUT_X + PART_GAP, 
    0, 
    0
])
difference() {
    // 1. The solid block representing the outer volume (Plate + Lip)
    // Total height = Plate(2) + Lip(4) = 6mm
    // We construct the union of the plate and the lip as one solid block first.
    // Outer envelope: 70 x 50 x 6
    cube([LID_PLATE_X, LID_PLATE_Y, LID_PLATE_THICK + LIP_HEIGHT], center = false);
    
    // 2. Subtract the voids to create the lip shape
    
    // Void 1: The inner cavity of the lip (Z=2 to Z=6)
    // Inner X = 65.6 - 2*1.5 = 62.6
    // Inner Y = 45.6 - 2*1.5 = 42.6
    translate([
        (LID_PLATE_X - LIP_OUT_X)/2, 
        (LID_PLATE_Y - LIP_OUT_Y)/2, 
        LID_PLATE_THICK // Start at top of plate
    ])
    cube([
        LIP_OUT_X - (2 * LIP_THICK),
        LIP_OUT_Y - (2 * LIP_THICK),
        LIP_HEIGHT
    ]);
    
    // Void 2: The space between the lip and the plate edges (Z=0 to Z=2)
    // This is the area of the plate that is outside the lip's footprint.
    // We need to subtract the corners of the plate that are not under the lip.
    // Lip footprint: 65.6 x 45.6. Plate: 70 x 50.
    // We create 4 corner blocks to subtract.
    
    // Calculate offsets for the corners
    // Plate half-size: 35 x 25
    // Lip half-size: 32.8 x 22.8
    // Corner width X = (35 - 32.8) = 2.2
    // Corner width Y = (25 - 22.8) = 2.2
    
    corner_x = (LID_PLATE_X - LIP_OUT_X) / 2;
    corner_y = (LID_PLATE_Y - LIP_OUT_Y) / 2;
    
    // Subtract the 4 corner regions of the plate (height 2mm)
    for (i = [0:1]) {
        for (j = [0:1]) {
            translate([
                j * (LID_PLATE_X - LIP_OUT_X),
                i * (LID_PLATE_Y - LIP_OUT_Y),
                0
            ])
            cube([
                LID_PLATE_X - LIP_OUT_X,
                LID_PLATE_Y - LIP_OUT_Y,
                LID_PLATE_THICK
            ]);
        }
    }
}