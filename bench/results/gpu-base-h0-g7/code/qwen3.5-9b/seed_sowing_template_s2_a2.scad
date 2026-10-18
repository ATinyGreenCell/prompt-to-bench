$fn = 128;

// --- Dimensions ---
// Petri dish inner diameter reference
DISH_DIAMETER = 90;

// Template main body
TEMPLATE_DIAMETER = 85;
TEMPLATE_THICKNESS = 2;

// Grid configuration
GRID_ROWS = 7;
GRID_COLS = 7;
HOLE_DIAMETER = 3;
HOLE_SPACING = 9; // Centre-to-centre

// Orientation notch
NOTCH_WIDTH = 10;  // X dimension
NOTCH_DEPTH = 4;   // Y dimension (in from rim)

// --- Calculations ---
// Calculate notch position relative to center
// Notch is on +Y side, centred on Y axis.
// Distance from center to rim = TEMPLATE_DIAMETER / 2
RIM_RADIUS = TEMPLATE_DIAMETER / 2;
// Notch center Y coordinate = Rim Radius - Notch Depth
// 42.5 - 4 = 38.5 mm
NOTCH_CENTER_Y = RIM_RADIUS - NOTCH_DEPTH;

// --- Main Body ---
difference() {
    // 1. Create the flat disc
    // Translate DOWN by TEMPLATE_THICKNESS so the bottom face sits at z = 0.
    // Cylinder center is at z = TEMPLATE_THICKNESS, bottom is at z = 0.
    union() {
        translate([0, 0, TEMPLATE_THICKNESS]) {
            cylinder(
                h = TEMPLATE_THICKNESS,
                d = TEMPLATE_DIAMETER,
                center = true
            );
        }
    }

    // 2. Cut the 7x7 grid of holes
    for (r = [0 : GRID_ROWS - 1]) {
        for (c = [0 : GRID_COLS - 1]) {
            // Calculate position for this hole
            x_pos = (c - (GRID_COLS - 1) / 2) * HOLE_SPACING;
            y_pos = (r - (GRID_ROWS - 1) / 2) * HOLE_SPACING;
            
            translate([x_pos, y_pos, 0]) {
                cylinder(
                    h = TEMPLATE_THICKNESS + 0.1, // Extend slightly past bottom to ensure clean cut
                    d = HOLE_DIAMETER,
                    center = true
                );
            }
        }
    }

    // 3. Cut the rectangular orientation notch
    // The notch is on the +Y side.
    // We need to cut a rectangle defined by:
    // X: from -NOTCH_WIDTH/2 to +NOTCH_WIDTH/2
    // Y: from NOTCH_CENTER_Y - NOTCH_DEPTH/2 to NOTCH_CENTER_Y + NOTCH_DEPTH/2
    // Z: from 0 to TEMPLATE_THICKNESS + 0.1
    
    // Explicitly set Y to positive value to ensure it's on the +Y side
    translate([0, NOTCH_CENTER_Y, 0]) {
        cube([
            NOTCH_WIDTH, 
            NOTCH_DEPTH, 
            TEMPLATE_THICKNESS + 0.1
        ]);
    }
}