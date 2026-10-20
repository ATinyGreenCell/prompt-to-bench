$fn = 64;

// Block dimensions
BLK_X = 106;      // Length in X (mm)
BLK_Y = 72;       // Width in Y (mm)
BLK_Z = 30;       // Height in Z (mm)

// Hole grid parameters
COLS = 6;         // Number of holes along X
ROWS = 4;         // Number of holes along Y
SPACING_X = 16;   // Centre-to-centre spacing in X (mm)
SPACING_Y = 16;   // Centre-to-centre spacing in Y (mm)
HOLE_DIA = 11.2;  // Diameter of each hole (mm)
HOLE_DEPTH = 25;  // Depth of each hole from top (mm)
FLOOR_THICK = 5;  // Solid floor thickness at bottom (mm)

// Derived dimensions
HOLE_R = HOLE_DIA / 2;
GRID_W_X = (COLS - 1) * SPACING_X;
GRID_W_Y = (ROWS - 1) * SPACING_Y;

difference() {
    // Main solid block, centred in X and Y
    cube([BLK_X, BLK_Y, BLK_Z], center=[true, true, false]);
    
    // Cut holes
    for (i = [0:COLS-1]) {
        for (j = [0:ROWS-1]) {
            translate([i * SPACING_X - GRID_W_X / 2, j * SPACING_Y - GRID_W_Y / 2, -0.01])
                cylinder(r=HOLE_R, h=HOLE_DEPTH + 0.02, center=false);
        }
    }
}