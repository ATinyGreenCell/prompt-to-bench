// Dimensions for 1.5 mL microcentrifuge tube rack
// Block size
BLOCK_X = 106;
BLOCK_Y = 72;
BLOCK_Z = 30;

// Hole grid parameters
GRID_ROWS = 4;      // Along Y
GRID_COLS = 6;      // Along X
SPACING_X = 16;     // Centre-to-centre along X
SPACING_Y = 16;     // Centre-to-centre along Y
HOLE_DIAM = 11.2;   // Hole diameter
HOLE_DEPTH = 25;    // Depth of hole from top
FLOOR_THICK = 5;    // Solid floor thickness (BLOCK_Z - HOLE_DEPTH = 30 - 25 = 5)

// Calculate grid offset to centre the grid on the block
// The block is placed at origin [0,0,0] with size [BLOCK_X, BLOCK_Y, BLOCK_Z].
// Block centre is at (BLOCK_X/2, BLOCK_Y/2).
BLOCK_CX = BLOCK_X / 2;
BLOCK_CY = BLOCK_Y / 2;

// Grid dimensions
GRID_W = (GRID_COLS - 1) * SPACING_X;
GRID_D = (GRID_ROWS - 1) * SPACING_Y;

// Grid centre relative to block centre
// We want the grid centre to align with the block centre.
// Grid centre is at (0,0) in grid-local coords.
// First hole in X: -GRID_W / 2
// First hole in Y: -GRID_D / 2

// Hole radius
HOLE_R = HOLE_DIAM / 2;

// Clearance for difference operation
CLEARANCE = 0.01;

// Main block
difference() {
    // Base block
    cube([BLOCK_X, BLOCK_Y, BLOCK_Z], center = false);
    
    // Holes
    for (i = [0 : GRID_COLS - 1]) {
        for (j = [0 : GRID_ROWS - 1]) {
            // Calculate hole position relative to block origin (0,0)
            // X: Start from BLOCK_CX - GRID_W/2, step by SPACING_X
            hx = BLOCK_CX - GRID_W / 2 + i * SPACING_X;
            // Y: Start from BLOCK_CY - GRID_D/2, step by SPACING_Y
            hy = BLOCK_CY - GRID_D / 2 + j * SPACING_Y;
            
            // Cut hole
            // Hole is open at top (z=0), depth 25mm.
            // Cylinder extends from z=0 to z=HOLE_DEPTH + CLEARANCE
            translate([hx, hy, 0]) {
                $fn = 64;
                cylinder(h = HOLE_DEPTH + CLEARANCE, d = HOLE_DIAM, center = false);
            }
        }
    }
}