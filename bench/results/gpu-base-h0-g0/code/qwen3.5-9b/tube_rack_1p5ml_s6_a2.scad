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

// Fillet Radius for bottom hole edges to reduce overhang angle for printing
// This smooths the 90-degree corner to allow printing without supports
HOLE_FILLET_RADIUS = 1.0; // mm

// Tolerance for cutting operations
CUT_TOLERANCE = 0.1;  // mm

// Set global faceting for smooth curves
$fn = 64;

// Calculate grid offsets to center the grid on the block
GRID_OFFSET_X = (BLOCK_LENGTH_X - (NUM_COLS_X - 1) * GRID_SPACING_X) / 2;
GRID_OFFSET_Y = (BLOCK_WIDTH_Y - (NUM_ROWS_Y - 1) * GRID_SPACING_Y) / 2;

// Main Block
difference() {
    // Create the solid rectangular block (sitting on Z=0)
    cube([BLOCK_LENGTH_X, BLOCK_WIDTH_Y, BLOCK_HEIGHT_Z], center = false);
    
    // Create holes
    for (r = [0 : NUM_ROWS_Y - 1]) {
        for (c = [0 : NUM_COLS_X - 1]) {
            // Calculate position of each hole center
            pos_x = GRID_OFFSET_X + c * GRID_SPACING_X;
            pos_y = GRID_OFFSET_Y + r * GRID_SPACING_Y;
            
            // Define the cutting cylinder
            // Height is exactly the hole depth to leave the 5mm floor
            hole_height = HOLE_DEPTH;
            
            translate([pos_x, pos_y, 0]) {
                // Use minkowski to add a fillet to the bottom edge of the hole
                // This reduces the overhang angle at the bottom of the hole
                minkowski() {
                    cylinder(
                        h = hole_height,
                        d = HOLE_DIAMETER,
                        $fn = 64
                    );
                    // The sphere acts as the fillet tool
                    translate([0, 0, -HOLE_FILLET_RADIUS]) {
                        sphere(r = HOLE_FILLET_RADIUS, $fn = 64);
                    }
                }
            }
        }
    }
}