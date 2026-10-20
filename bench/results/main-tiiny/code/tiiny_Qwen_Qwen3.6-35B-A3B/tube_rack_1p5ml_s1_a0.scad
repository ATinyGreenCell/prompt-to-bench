// --- Dimensions ---
BLOCK_L = 106;       // Length (X)
BLOCK_W = 72;        // Width ( Y)
BLOCK_H = 30;        // Height (Z)

// Hole Grid Parameters
NUM_ROWS = 4;        // Along Y
NUM_COLS = 6;        // Along X
HOLE_CENTRE_X = 16;  // Centre-to-centre distance in X
HOLE_CENTRE_Y = 16;  // Centre-to-centre distance in Y
HOLE_DIAM = 11.2;    // Diameter of the tube holes
HOLE_DEPTH = 25;     // Depth of the holes from the top surface
// Floor thickness is implicitly BLOCK_H - HOLE_DEPTH = 5 mm

// Derived Parameters
// Calculate total width of the hole grid to centre it on the block
GRID_W_X = (NUM_COLS - 1) * HOLE_CENTRE_X;
GRID_W_Y = (NUM_ROWS - 1) * HOLE_CENTRE_Y;

// Starting X and Y coordinates for the grid (bottom-left corner of the grid area)
START_X = (BLOCK_L - GRID_W_X) / 2;
START_Y = (BLOCK_W - GRID_W_Y) / 2;

// Hole geometry
// The holes are open at the top (z = BLOCK_H) and closed at the bottom.
// We model them as cylinders extending slightly past the bottom to ensure a clean cut.
// Top surface is at z = BLOCK_H.
// Bottom of the hole is at z = BLOCK_H - HOLE_DEPTH.
// We extend the cutting cylinder down to z = BLOCK_H - HOLE_DEPTH - 0.01 to avoid coplanar faces.
CUT_HOLE_H = HOLE_DEPTH + 0.01;
CUT_HOLE_Z = BLOCK_H - CUT_HOLE_H; // Bottom Z position of the cutting cylinder

// Main Module
module tube_rack() {
    // 1. Create the solid base block
    // Centered on X and Y, resting on Z=0
    base = translate([BLOCK_L / 2, BLOCK_W / 2, 0]) 
           cube([BLOCK_L, BLOCK_W, BLOCK_H], center = false);

    // 2. Create the hole grid using a difference operation
    // We iterate over rows and columns to place each hole
    holes = for (r = [0 : NUM_ROWS - 1]) 
            for (c = [0 : NUM_COLS - 1]) {
                // Calculate the center of the current hole
                hx = START_X + c * HOLE_CENTRE_X;
                hy = START_Y + r * HOLE_CENTRE_Y;
                
                // Create the cutting cylinder for this hole
                // $fn is set locally to ensure round holes
                $fn = 64;
                translate([hx, hy, CUT_HOLE_Z])
                cylinder(h = CUT_HOLE_H, d = HOLE_DIAM, center = false);
            };

    // 3. Subtract the holes from the base
    difference() {
        base;
        for (h = holes) {
            h;
        }
    }
}

// Execute the model
tube_rack();