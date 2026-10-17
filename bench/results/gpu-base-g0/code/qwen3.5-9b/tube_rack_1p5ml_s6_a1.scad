// Bench Rack for 1.5 mL Microcentrifuge Tubes
// Dimensions based on user specifications

// Block Dimensions
BLOCK_LENGTH_X = 106; // mm
BLOCK_WIDTH_Y = 72;   // mm
BLOCK_HEIGHT_Z = 30;  // mm

// Grid Configuration
NUM_ROWS_Y = 4;       // Rows along Y
NUM_COLS_X = 6;       // Columns along X
GRID_SPACING_X = 16;  // mm centre-to-centre
GRID_SPACING_Y = 16;  // mm centre-to-centre

// Hole Dimensions
HOLE_DIAMETER = 11.2; // mm
HOLE_DEPTH = 25;      // mm (open top, closed bottom)
FLOOR_HEIGHT = 5;     // mm (solid floor at bottom)

// Tolerance for cutting operations (to ensure clean removal)
CUT_TOLERANCE = 0.1;  // mm

// Set global faceting for smooth curves
$fn = 64;

// Calculate grid offsets to center the grid on the block
// Total span X = (NUM_COLS_X - 1) * GRID_SPACING_X
// Offset X = (BLOCK_LENGTH_X - Total span X) / 2
GRID_OFFSET_X = (BLOCK_LENGTH_X - (NUM_COLS_X - 1) * GRID_SPACING_X) / 2;

// Total span Y = (NUM_ROWS_Y - 1) * GRID_SPACING_Y
// Offset Y = (BLOCK_WIDTH_Y - Total span Y) / 2
GRID_OFFSET_Y = (BLOCK_WIDTH_Y - (NUM_ROWS_Y - 1) * GRID_SPACING_Y) / 2;

// Main Block
difference() {
    // Create the solid rectangular block
    // Translate to ensure bottom is at Z=0
    translate([0, 0, BLOCK_HEIGHT_Z / 2]) {
        cube([BLOCK_LENGTH_X, BLOCK_WIDTH_Y, BLOCK_HEIGHT_Z]);
        
        // Create holes
        // We use a loop to generate cylinders that cut through the block
        for (r = [0 : NUM_ROWS_Y - 1]) {
            for (c = [0 : NUM_COLS_X - 1]) {
                // Calculate position of each hole center
                pos_x = GRID_OFFSET_X + c * GRID_SPACING_X;
                pos_y = GRID_OFFSET_Y + r * GRID_SPACING_Y;
                
                // Define the cutting cylinder
                // Radius is half diameter
                // Height is exactly the required hole depth (25mm)
                // Z position: Top of cylinder at block top (BLOCK_HEIGHT_Z / 2)
                // Bottom of cylinder at (BLOCK_HEIGHT_Z / 2) - HOLE_DEPTH
                cylinder(
                    h = HOLE_DEPTH,
                    r = HOLE_DIAMETER / 2,
                    center = [pos_x, pos_y, BLOCK_HEIGHT_Z / 2 - HOLE_DEPTH / 2],
                    $fn = 64
                );
            }
        }
    }
}