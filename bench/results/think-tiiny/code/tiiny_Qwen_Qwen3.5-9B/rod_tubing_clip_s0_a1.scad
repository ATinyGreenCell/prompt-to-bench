// Snap-on Clip for Lab Stand Rod and Tubing
// Units: Millimetres
// Orientation: Flat on XY plane, builds upward (+Z), centred on origin

$fn = 64;

// --- Dimensions ---
Z_HEIGHT = 10;
ROD_ID = 12.7;
ROD_WALL = 3;
ROD_OD = 18.7;
ROD_CENTER_X = 0;
ROD_CENTER_Y = 0;
ROD_CUT_Y_LIMIT = 5;
ROD_CUT_X_LIMIT = 0; // Cut is x < 0

TUBING_ID = 6;
TUBING_WALL = 2;
TUBING_OD = 10;
TUBING_CENTER_X = 15;
TUBING_CENTER_Y = 0;
TUBING_CUT_Y_LIMIT = 2.25;
TUBING_CUT_X_LIMIT = 15; // Cut is x > 15

BRIDGE_WIDTH_Y = 6;
BRIDGE_X_START = 8;
BRIDGE_X_END = 12;

// --- Derived Dimensions ---
ROD_RADIUS_OUT = ROD_OD / 2;
ROD_RADIUS_IN = ROD_ID / 2;
TUBING_RADIUS_OUT = TUBING_OD / 2;
TUBING_RADIUS_IN = TUBING_ID / 2;
BRIDGE_X_WIDTH = BRIDGE_X_END - BRIDGE_X_START;
BRIDGE_X_CENTER = (BRIDGE_X_START + BRIDGE_X_END) / 2;
BRIDGE_Y_HALF = BRIDGE_WIDTH_Y / 2;

// --- Cut Tolerances ---
CUT_Z_TOL = 0.05;
CUT_X_TOL = 0.05;
CUT_Y_TOL = 0.05;

// --- Module: Rod Ring ---
module rod_ring() {
    translate([ROD_CENTER_X, ROD_CENTER_Y, 0])
    difference() {
        cylinder(h = Z_HEIGHT, r = ROD_RADIUS_OUT, $fn = 64);
        cylinder(h = Z_HEIGHT, r = ROD_RADIUS_IN, $fn = 64);
    }
}

// --- Module: Tubing Ring ---
module tubing_ring() {
    translate([TUBING_CENTER_X, TUBING_CENTER_Y, 0])
    difference() {
        cylinder(h = Z_HEIGHT, r = TUBING_RADIUS_OUT, $fn = 64);
        cylinder(h = Z_HEIGHT, r = TUBING_RADIUS_IN, $fn = 64);
    }
}

// --- Module: Bridge ---
module bridge() {
    translate([BRIDGE_X_CENTER, 0, 0])
    cube([BRIDGE_X_WIDTH, BRIDGE_WIDTH_Y, Z_HEIGHT]);
}

// --- Module: Rod Cut ---
module rod_cut() {
    // Cut x < 0, -5 < y < 5
    // Extend past faces: x_max = 0.05, y_max = 5.05, z_max = 10.05
    translate([-ROD_RADIUS_OUT, 0, 0])
    cube([ROD_RADIUS_OUT + CUT_X_TOL, ROD_CUT_Y_LIMIT * 2 + CUT_Y_TOL, Z_HEIGHT + CUT_Z_TOL]);
}

// --- Module: Tubing Cut ---
module tubing_cut() {
    // Cut x > 15, -2.25 < y < 2.25
    // Extend past faces: x_min = 15.05, y_max = 2.25 + 0.05, z_max = 10.05
    translate([TUBING_CENTER_X, 0, 0])
    cube([TUBING_RADIUS_OUT + CUT_X_TOL, TUBING_CUT_Y_LIMIT * 2 + CUT_Y_TOL, Z_HEIGHT + CUT_Z_TOL]);
}

// --- Main Assembly ---
difference() {
    union() {
        rod_ring();
        tubing_ring();
        bridge();
    };
    
    rod_cut();
    tubing_cut();
}