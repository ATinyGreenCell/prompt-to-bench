// Sowing template for 90mm Petri dish: flat disc with grid of holes and orientation notch.

// Dimensions
DISH_DIA = 90;
DISC_DIA = 85;
THICKNESS = 2;
HOLE_COUNT = 7;
HOLE_DIA = 3;
HOLE_SPACING = 9;
NOTCH_WIDTH = 10;
NOTCH_DEPTH = 4;

$fn = 64;

// Calculate grid offsets to centre the grid on the origin
// For 7 holes, indices are 0..6. Centre index is 3.
// Offset = (index - 3) * spacing
grid_offset = (HOLE_COUNT - 1) / 2 * HOLE_SPACING;

difference() {
    // Main disc body
    translate([-DISC_DIA / 2, -DISC_DIA / 2, 0])
        cube([DISC_DIA, DISC_DIA, THICKNESS]);

    // Grid of holes
    for (i = [0 : HOLE_COUNT - 1]) {
        x_pos = (i - (HOLE_COUNT - 1) / 2) * HOLE_SPACING;
        translate([x_pos, 0, 0])
            cylinder(h = THICKNESS + 0.1, d = HOLE_DIA);
    }

    // Orientation notch on the +Y side
    // Notch is 10mm wide (X) and 4mm deep (Y)
    // Centred on Y axis, so it spans from -5 to +5 in X
    // It cuts into the rim from the outside inwards
    translate([0, DISC_DIA / 2 - NOTCH_DEPTH, 0]) {
        // Cut a rectangle that extends slightly past the rim to ensure clean cut
        translate([0, 0, -0.1])
            cube([NOTCH_WIDTH, NOTCH_DEPTH + 0.1, THICKNESS + 0.1]);
    }
}