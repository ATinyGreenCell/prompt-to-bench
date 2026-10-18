// Sowing template for 90 mm Petri dish
// Flat disc with grid of holes and orientation notch.

$fn = 64;

// Dimensions
DISH_DIA = 90;
DISC_DIA = 85;
THICKNESS = 2;
HOLE_COUNT = 7;
HOLE_DIA = 3;
HOLE_SPACING = 9;
NOTCH_WIDTH = 10;
NOTCH_DEPTH = 4;

// Calculate grid positions
// n features spaced p apart and centred on the origin sit at (i - (n - 1) / 2) * p
grid_offset = (HOLE_COUNT - 1) / 2 * HOLE_SPACING;

difference() {
    // Main disc body
    translate([-DISC_DIA / 2, -DISC_DIA / 2, 0])
        cube([DISC_DIA, DISC_DIA, THICKNESS]);

    // Grid of holes
    for (i = [0 : HOLE_COUNT - 1]) {
        x_pos = (i - grid_offset) * HOLE_SPACING;
        translate([x_pos, 0, -1])
            cylinder(h = THICKNESS + 2, d = HOLE_DIA);
    }

    // Orientation notch on the +Y side
    // Not