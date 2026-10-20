// Dimensions
DISC_DIAMETER = 85;
DISC_THICKNESS = 2;
HOLE_DIAMETER = 3;
GRID_SPACING = 9;
GRID_COLS = 7;
GRID_ROWS = 7;
NOTCH_WIDTH = 10;
NOTCH_DEPTH = 4;

// Derived dimensions
DISC_RADIUS = DISC_DIAMETER / 2;
HOLE_RADIUS = HOLE_DIAMETER / 2;

// Grid hole positions
// Centered at 0,0. Indices from -(N-1)/2 to +(N-1)/2
grid_x = [for (i = [0 : GRID_COLS - 1]) (i - (GRID_COLS - 1) / 2) * GRID_SPACING];
grid_y = [for (i = [0 : GRID_ROWS - 1]) (i - (GRID_ROWS - 1) / 2) * GRID_SPACING];

// Notch dimensions
// Width in X, Depth in Y (from rim inwards)
NOTCH_HALF_W = NOTCH_WIDTH / 2;
NOTCH_Y_OUTER = DISC_RADIUS;
NOTCH_Y_INNER = DISC_RADIUS - NOTCH_DEPTH;

// Helper to ensure clean boolean cuts by extending slightly
EXT = 0.05;

module sowing_template() {
    difference() {
        // Main Disc
        cylinder(r = DISC_RADIUS, h = DISC_THICKNESS, center = false, $fn = 64);

        // Grid Holes
        for (x = grid_x) {
            for (y = grid_y) {
                translate([x, y, 0]) {
                    $fn = 64;
                    cylinder(r = HOLE_RADIUS, h = DISC_THICKNESS + 0.01, center = false);
                }
            }
        }

        // Orientation Notch
        // Cut a rectangle from the rim on the +Y side.
        // X: -5 to 5. Y: 38.5 to 42.5.
        // Extend slightly to ensure clean boolean.
        translate([0, 0, 0]) {
            cube([
                NOTCH_WIDTH + EXT * 2, 
                (NOTCH_Y_OUTER - NOTCH_Y_INNER) + EXT * 2, 
                DISC_THICKNESS + 0.01
            ], center = false);
        }
    }
}

sowing_template();