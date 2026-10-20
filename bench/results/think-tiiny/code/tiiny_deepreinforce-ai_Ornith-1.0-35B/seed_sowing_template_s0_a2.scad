$fn = 64;

// Disc dimensions
DISC_DIA = 85;
DISC_THICK = 2;

// Grid hole dimensions
HOLE_DIA = 3;
GRID_SPACING = 9;
GRID_COUNT = 7;

// Orientation notch dimensions
NOTCH_WIDE = 10;
NOTCH_DEEP = 4;

half_span = (GRID_COUNT - 1) * GRID_SPACING / 2;

difference() {
    // Base disc resting on XY plane
    cylinder(d = DISC_DIA, h = DISC_THICK);

    // 7x7 grid of through-holes
    for (i = [0 : GRID_COUNT - 1]) {
        for (j = [0 : GRID_COUNT - 1]) {
            x = -half_span + i * GRID_SPACING;
            y = -half_span + j * GRID_SPACING;
            translate([x, y, 0]) {
                cylinder(d = HOLE_DIA, h = DISC_THICK + 0.1);
            }
        }
    }

    // Rectangular orientation notch on the +Y rim
    // Cut 4mm deep from the rim, centered on Y axis
    translate([-NOTCH_WIDE / 2, DISC_DIA / 2 - NOTCH_DEEP, 0]) {
        cube([NOTCH_WIDE, NOTCH_DEEP + 0.01, DISC_THICK + 0.01], center = false);
    }
}