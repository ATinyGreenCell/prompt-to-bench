// Dimensions
OUTER_W = 90;          // Outer width (X)
OUTER_H = 90;          // Outer depth (Y)
TOP_THICK = 2;         // Top plate thickness
WALL_THICK = 2.5;      // Wall thickness
WALL_H = 38;           // Wall height from z=2 to z=40
INNER_W = OUTER_W - 2 * WALL_THICK; // Inner width/depth
HOLE_PAT = 71.5;       // Screw hole pattern spacing
HOLE_R = 4.5 / 2;      // Screw hole radius
NOTCH_W = 12;          // Cable notch width
NOTCH_Z = 8;           // Cable notch depth (Z)

// Top plate with screw holes
top_plate = difference() {
    translate([0, 0, 1]) {
        cube([OUTER_W, OUTER_H, TOP_THICK], center=[true, true, false]);
    }
    union() {
        for (i = [-1, 1], j = [-1, 1]) {
            translate([i * HOLE_PAT / 2, j * HOLE_PAT / 2, -0.1]) {
                cylinder(r=HOLE_R, h=TOP_THICK + 0.2, $fn=64);
            }
        }
    }
};

// Walls with inner void and cable notch
walls = difference() {
    // Outer shell
    translate([0, 0, 2]) {
        cube([OUTER_W, OUTER_H, WALL_H], center=[true, true, false]);
    }
    // Inner void
    translate([0, 0, 2]) {
        cube([INNER_W, INNER_W, WALL_H + 0.1], center=[true, true, false]);
    }
    // Cable notch
    translate([0, OUTER_H/2 - WALL_THICK/2, 36]) {
        cube([NOTCH_W + 0.1, WALL_THICK + 0.1, NOTCH_Z + 0.1], center=[true, true, false]);
    }
};

// Combine parts
union() {
    top_plate;
    walls;
}