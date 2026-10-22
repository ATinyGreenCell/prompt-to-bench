$fn = 64;

// --- Box Dimensions ---
BOX_OUT_X = 70;   // Outer length (X)
BOX_OUT_Y = 50;   // Outer width (Y)
BOX_OUT_Z = 30;   // Outer height (Z)
WALL_THK  = 2;    // Wall thickness
FLOOR_THK = 2;    // Floor thickness
BOX_IN_X  = BOX_OUT_X - 2 * WALL_THK; // Inner length
BOX_IN_Y  = BOX_OUT_Y - 2 * WALL_THK; // Inner width
BOX_IN_Z  = BOX_OUT_Z - FLOOR_THK;    // Inner height

// --- Lid Dimensions ---
LID_PLATE_X = 70;   // Plate length (X)
LID_PLATE_Y = 50;   // Plate width (Y)
LID_PLATE_Z = 2;    // Plate thickness (Z)
LIP_OUT_X   = 65.6; // Lip outer length (X)
LIP_OUT_Y   = 45.6; // Lip outer width (Y)
LIP_THK     = 1.5;  // Lip wall thickness
LIP_H       = 4;    // Lip height
LIP_IN_X    = LIP_OUT_X - 2 * LIP_THK; // Lip inner length
LIP_IN_Y    = LIP_OUT_Y - 2 * LIP_THK; // Lip inner width

// --- Part 1: Box ---
translate([-40, 0, 0]) {
    difference() {
        // Solid block before hollowing
        cube([BOX_OUT_X, BOX_OUT_Y, BOX_OUT_Z]);
        // Hollow cutout: leaves 2mm walls and floor. Extends 0.02mm past top face.
        translate([WALL_THK, WALL_THK, FLOOR_THK])
            cube([BOX_IN_X, BOX_IN_Y, BOX_IN_Z + 0.02]);
    }
}

// --- Part 2: Lid ---
translate([40, 0, 0]) {
    union() {
        // Base plate
        cube([LID_PLATE_X, LID_PLATE_Y, LID_PLATE_Z]);
        
        // Lip (printed upside down, so it sits on top of the plate)
        difference() {
            // Outer lip block
            translate([-LIP_OUT_X/2, -LIP_OUT_Y/2, LID_PLATE_Z])
                cube([LIP_OUT_X, LIP_OUT_Y, LIP_H]);
            // Inner cutout: extends 0.02mm past the top face of the lip
            translate([-LIP_IN_X/2, -LIP_IN_Y/2, LID_PLATE_Z + 0.005])
                cube([LIP_IN_X, LIP_IN_Y, LIP_H + 0.02]);
        }
    }
}