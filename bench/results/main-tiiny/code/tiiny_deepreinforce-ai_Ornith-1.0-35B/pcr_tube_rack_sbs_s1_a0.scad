// --- Dimensions ---
BLOCK_L = 127.76;        // Length (X)
BLOCK_W = 85.48;         // Width (Y)
BLOCK_H = 20.0;          // Height (Z)

HOLE_DIA = 6.2;          // Hole diameter
HOLE_R = HOLE_DIA / 2;

COLS = 12;               // Columns along X
ROWS = 8;                // Rows along Y
SPACING = 9.0;         // Centre-to-centre spacing

ORIGIN_X = 14.38;        // Distance from left edge to A1 hole centre
ORIGIN_Y = 11.24;        // Distance from back edge to A1 hole centre

CHAMFER_LEN = 5.0;       // Chamfer leg length
CHAMFER_ANGLE = 45;    // Chamfer angle

// --- Derived ---
GRID_W = (COLS - 1) * SPACING;  // Total grid width (X)
GRID_D = (ROWS - 1) * SPACING;// Total grid depth (Y)

// --- Main body ---
difference() {
    // Solid block
    cube([BLOCK_L, BLOCK_W, BLOCK_H], center = false);

    // 96 holes
    for (x = [0 : COLS - 1]) {
        for (y = [0 : ROWS - 1]) {
            hx = ORIGIN_X + x * SPACING;
            hy = ORIGIN_Y + y * SPACING;
            translate([hx, hy, 0])
                cylinder(h = BLOCK_H + 0.1, d = HOLE_DIA, $fn = 64);
        }
    }

    // 45-degree chamfer at A1 corner (front-left)
    translate([-0.1, -0.1, 0])
        rotate([0, 0, 45])
            cube([CHAMFER_LEN * 1.5, BLOCK_W + 0.2, BLOCK_H + 0.1], center = false);
}