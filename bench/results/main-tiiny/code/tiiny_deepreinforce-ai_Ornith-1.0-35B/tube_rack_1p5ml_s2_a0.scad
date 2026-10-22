// --- Dimensions ---
BLOCK_L = 106;          // Block length (X)
BLOCK_W = 72;           // Block width (Y)
BLOCK_H = 30;           // Block height (Z)
TUBE_OD = 11.2;         // Tube outer diameter (hole diameter)
TUBE_DEPTH = 25;      // Hole depth (open at top)
FLOOR_THICK = 5;        // Solid floor remaining at bottom
GRID_NX = 6;            // Holes along X per row
GRID_NY = 4;            // Number of rows along Y
SPACING_X = 16;         // Centre-to-centre spacing along X
SPACING_Y = 16;        // Centre-to-centre spacing along Y

// Derived
TOTAL_HOLE_DEPTH = BLOCK_H - FLOOR_THICK;  // Should equal TUBE_DEPTH

// --- Hole grid origin (bottom-left of grid) ---
GRID_X0 = (BLOCK_L - (GRID_NX - 1) * SPACING_X) / 2;
GRID_Y0 = (BLOCK_W - (GRID_NY - 1) * SPACING_Y) / 2;

// --- Build ---
$fn = 64;

difference() {
    // Solid block
    cube([BLOCK_L, BLOCK_W, BLOCK_H], center = false);

    // Cut holes
    for (ix = [0 : GRID_NX - 1]) {
        for (iy = [0 : GRID_NY - 1]) {
            hx = GRID_X0 + ix * SPACING_X;
            hy = GRID_Y0 + iy * SPACING_Y;

            // Hole extends slightly past the bottom so no coplanar face
            cylinder(d = TUBE_OD, h = TOTAL_HOLE_DEPTH + 0.01,
                   center = false,
                   pos = [hx, hy, 0]);
        }
    }
}