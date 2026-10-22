// Dimensions
BLOCK_X = 106;
BLOCK_Y = 72;
BLOCK_Z = 30;

// Hole grid parameters
NUM_ROWS = 4; // Along Y
NUM_COLS = 6; // Along X
HOLE_PITCH_X = 16;
HOLE_PITCH_Y = 16;
HOLE_DIAM = 11.2;
HOLE_DEPTH = 25;

// Derived dimensions
BLOCK_HALF_X = BLOCK_X / 2;
BLOCK_HALF_Y = BLOCK_Y / 2;

// Calculate grid bounds to center on the block
// Total width of grid = (N-1) * pitch
GRID_W_X = (NUM_COLS - 1) * HOLE_PITCH_X;
GRID_W_Y = (NUM_ROWS - 1) * HOLE_PITCH_Y;

// Start positions for the grid relative to center (0,0)
GRID_START_X = -GRID_W_X / 2;
GRID_START_Y = -GRID_W_Y / 2;

// Hole geometry
// The block rests on Z=0 and is BLOCK_Z tall.
// Holes are 25 mm deep, open at the top (Z=30).
// They end at Z = 30 - 25 = 5 mm.
// We cut from Z=30 down to Z=5.
// To ensure clean boolean operations, we extend the cut slightly past the bottom.
HOLE_CUT_Z_BOTTOM = 5 - 0.01; 
HOLE_CUT_HEIGHT = 30 - HOLE_CUT_Z_BOTTOM;

// Hole radius
HOLE_R = HOLE_DIAM / 2;

module Hole() {
    // Use a cylinder slightly larger than the diameter to ensure the hole is at least the target size
    // and to avoid faceting issues with low $fn.
    // Extending past the bottom face by 0.01mm as per rules.
    // The cylinder is centered=false, so it builds from z=0 upwards.
    // We position it so its top is at Z=30 and bottom extends past Z=5.
    cylinder(h = HOLE_CUT_HEIGHT + 0.01, r = HOLE_R + 0.01, center = false, $fn = 64);
}

module Block() {
    // Centered in X and Y, resting on Z=0
    cube([BLOCK_X, BLOCK_Y, BLOCK_Z], center = false);
}

module Rack() {
    // Base block
    difference() {
        Block();
        
        // Drill holes
        for (i = [0 : NUM_COLS - 1]) {
            for (j = [0 : NUM_ROWS - 1]) {
                x_pos = GRID_START_X + i * HOLE_PITCH_X;
                y_pos = GRID_START_Y + j * HOLE_PITCH_Y;
                
                translate([x_pos, y_pos, 0]) {
                    // Position the hole cylinder so its top is at Z=30 (top of block)
                    // The cylinder height is HOLE_CUT_HEIGHT + 0.01
                    // We want the top of the cylinder to be at Z=30.
                    // So the bottom of the cylinder (local z=0) should be at Z = 30 - (HOLE_CUT_HEIGHT + 0.01)
                    // However, simpler: Place the cylinder such that it covers the range [5-0.01, 30].
                    // Cylinder height is HOLE_CUT_HEIGHT + 0.01.
                    // If we place the base at Z = 30 - (HOLE_CUT_HEIGHT + 0.01), the top will be at Z=30.
                    // Let's calculate the base Z position.
                    base_z = 30 - (HOLE_CUT_HEIGHT + 0.01);
                    
                    translate([0, 0, base_z]) {
                        Hole();
                    }
                }
            }
        }
    }
}

Rack();