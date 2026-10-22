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
    // Use a cylinder slightly larger than the diameter to ensure the hole is at least the target