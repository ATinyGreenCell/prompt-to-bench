// Dimensions
DISC_DIAMETER = 85;
DISC_THICKNESS = 2;
HOLE_DIAMETER = 3;
GRID_SPACING = 9;
GRID_COLS = 7;
GRID_ROWS = 7;
NOTCH_WIDTH = 10;
NOTCH_DEPTH = 4;
PETRI_DIAMETER = 90;

// Derived dimensions
DISC_RADIUS = DISC_DIAMETER / 2;
HOLE_RADIUS = HOLE_DIAMETER / 2;

// Grid bounds
GRID_WIDTH = (GRID_COLS - 1) * GRID_SPACING;
GRID_HEIGHT = (GRID_ROWS - 1) * GRID_SPACING;

// Notch bounds
NOTCH_HALF_WIDTH = NOTCH_WIDTH / 2;
// The rim of the disc is at radius DISC_RADIUS.
// The notch is cut into the rim on the +Y side.
// The outer edge of the notch is at Y = DISC_RADIUS.
// The inner edge of the notch is at Y = DISC_RADIUS - NOTCH_DEPTH.
NOTCH_Y_INNER = DISC_RADIUS - NOTCH_DEPTH;

// Calculate grid hole positions
// Centered on the disc (0,0).
// For 7 items, indices go from -3 to +3.
grid_x_positions = [for (i = [0 : GRID_COLS - 1]) (i - (GRID_COLS - 1) / 2) * GRID_SPACING];
grid_y_positions = [for (i = [0 : GRID_ROWS - 1]) (i - (GRID_ROWS - 1) / 2) * GRID_SPACING];

module sowing_template() {
    // Main disc body
    difference() {
        // Base cylinder
        cylinder(r = DISC_RADIUS, h = DISC_THICKNESS, center = false, $fn = 64);

        // Through-holes
        for (x = grid_x_positions) {
            for (y = grid_y_positions) {
                translate([x, y, 0]) {
                    $fn = 64;
                    cylinder(r = HOLE_RADIUS, h = DISC_THICKNESS + 0.01, center = false);
                }
            }
        }

        // Orientation notch on the +Y side
        // The notch is a rectangle cut into the rim.
        // X range: [-NOTCH_HALF_WIDTH, NOTCH_HALF_WIDTH]
        // Y range: [NOTCH_Y_INNER, DISC_RADIUS] (cutting out the material)
        // Z range: [0, DISC_THICKNESS]
        translate([0, 0, 0]) {
            // Extend slightly past the faces to ensure clean boolean operations
            // X extends slightly beyond the notch width to ensure corners are cut
            // Y extends from the inner cut to slightly beyond the outer rim
            // Z extends through the thickness
            cube([
                NOTCH_WIDTH + 0.02, 
                DISC_RADIUS - NOTCH_Y_INNER + 0.02, 
                DISC_THICKNESS + 0.01
            ], center = false);
        }
    }
}

sowing_template();