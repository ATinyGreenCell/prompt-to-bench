// --- Dimensions ---
BLOCK_L = 106;       // Block length (X)
BLOCK_W = 72;        // Block width (Y)
BLOCK_H = 30;        // Block height (Z)

HOLE_DIA = 11.2;     // Hole diameter
HOLE_DEPTH = 25;   // Hole depth (open at top, 5mm floor remains)

ROWS = 4;            // Number of rows along Y
COLS = 6;            // Number of columns along X
SPACING_X = 16;    // Hole spacing along X (centre-to-centre)
SPACING_Y = 16;    // Hole spacing along Y (centre-to-centre)

$fn = 64;

// --- Hole grid origin (bottom-left of grid) ---
grid_x0 = -(COLS - 1) * SPACING_X / 2;
grid_y0 = -(ROWS - 1) * SPACING_Y / 2;

// --- Main block (translated to sit on z=0) ---
difference() {
    // Solid rectangular block, translated up by BLOCK_H/2
    translate([0, 0, BLOCK_H / 2]) {
        cube([BLOCK_L, BLOCK_W, BLOCK_H], center = true);
    }

    // Drill holes
    for (i = [0 : COLS - 1]) {
        for (j = [0 : ROWS - 1]) {
            hx = grid_x0 + i * SPACING_X;
            hy = grid_y0 + j * SPACING_Y;

            // Hole extends past the bottom of the block to ensure clean cut
            translate([hx, hy, BLOCK_H / 2 + 0.01]) {
                cylinder(h = HOLE_DEPTH + BLOCK_H / 2 + 0.01, d = HOLE_DIA, center = false);
            }
        }
    }
}