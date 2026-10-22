$fn = 64;

// --- Box Dimensions ---
BOX_OUT_X = 70;
BOX_OUT_Y = 50;
BOX_OUT_Z = 30;
WALL_THK  = 2;
FLOOR_THK = 2;

// Derived box inner dimensions
BOX_IN_X = BOX_OUT_X - 2 * WALL_THK;
BOX_IN_Y = BOX_OUT_Y - 2 * WALL_THK;
BOX_IN_Z = BOX_OUT_Z - FLOOR_THK;

// --- Lid Dimensions ---
LID_PLATE_X = 70;
LID_PLATE_Y = 50;
LID_PLATE_Z = 2;
LIP_OUT_X   = 65.6;
LIP_OUT_Y   = 45.6;
LIP_THK     = 1.5;
LIP_H       = 4;

LIP_IN_X = LIP_OUT_X - 2 * LIP_THK;
LIP_IN_Y = LIP_OUT_Y - 2 * LIP_THK;

// --- Part 1: Box ---
translate([-40, 0, 0]) {
    // Floor
    cube([BOX_OUT_X, BOX_OUT_Y, FLOOR_THK]);
    
    // Walls
    union() {
        // Left wall
        translate([0, WALL_THK, FLOOR_THK])
            cube([WALL_THK, BOX_IN_Y, BOX_IN_Z]);
        // Right wall
        translate([BOX_OUT_X - WALL_THK, WALL_THK, FLOOR_THK])
            cube([WALL_THK, BOX_IN_Y, BOX_IN_Z]);
        // Front wall
        translate([WALL_THK, BOX_OUT_Y - WALL_THK, FLOOR_THK])
            cube([BOX_IN_X, WALL_THK, BOX_IN_Z]);
        // Back wall
        translate([WALL_THK, 0, FLOOR_THK])
            cube([BOX_IN_X, WALL_THK, BOX_IN_Z]);
    }
}

// --- Part 2: Lid ---
translate([40, 0, 0]) {
    // Plate
    cube([LID_PLATE_X, LID_PLATE_Y, LID_PLATE_Z]);
    
    // Lip (hollow rectangle)
    difference() {
        // Outer lip block
        translate([-LIP_OUT_X/2, -LIP_OUT_Y/2, LID_PLATE_Z])
            cube([LIP_OUT_X, LIP_OUT_Y, LIP_H]);
            
        // Inner cutout (extends past top face by 0.02mm to avoid coplanar faces)
        translate([-LIP_IN_X/2, -LIP_IN_Y/2, LID_PLATE_Z + 0.005])
            cube([LIP_IN_X, LIP_IN_Y, LIP_H + 0.02]);
    }
}