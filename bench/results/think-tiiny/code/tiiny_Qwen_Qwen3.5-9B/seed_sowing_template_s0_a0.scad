$fn = 64;

// Dimensions in millimetres
DISC_DIAMETER = 85;
DISC_RADIUS = DISC_DIAMETER / 2;
DISC_THICKNESS = 2;
HOLE_COUNT = 7;
HOLE_DIA = 3;
HOLE_PITCH = 9;
NOTCH_WIDTH = 10;
NOTCH_DEPTH = 4;
TOLERANCE = 0.05;

// Derived dimensions
GRID_HALF = (HOLE_COUNT - 1) / 2;
NOTCH_Y_POS = DISC_RADIUS - NOTCH_DEPTH / 2;

difference() {
    // Main Disc
    translate([0, 0, 0])
        cylinder(d = DISC_DIAMETER, h = DISC_THICKNESS, $fn = 64);

    // Holes
    for (i = -GRID_HALF : 1 : GRID_HALF) {
        translate([i * HOLE_PITCH, i * HOLE_PITCH, -TOLERANCE])
            cylinder(d = HOLE_DIA, h = DISC_THICKNESS + 2 * TOLERANCE, $fn = 64);
    }

    // Notch
    translate([0, NOTCH_Y_POS, -TOLERANCE])
        cube([NOTCH_WIDTH, NOTCH_DEPTH, DISC_THICKNESS + 2 * TOLERANCE]);
}