$fn = 128;

// --- Dimensions ---
// Template base dimensions
$TEMPLATE_DIAMETER = 85;
$TEMPLATE_THICKNESS = 2;

// Grid dimensions
$GRID_ROWS = 7;
$GRID_COLS = 7;
$HOLE_DIAMETER = 3;
$HOLE_SPACING = 9;

// Notch dimensions (on +Y side)
$NOTCH_WIDTH = 10;  // X dimension
$NOTCH_DEPTH = 4;   // Y dimension (in from rim)

// --- Calculations ---
// Calculate grid offset to center the 7x7 grid
$GRID_OFFSET = (($GRID_ROWS - 1) * $HOLE_SPACING) / 2;

// Calculate notch position relative to center
$TEMPLATE_RADIUS = $TEMPLATE_DIAMETER / 2;
$NOTCH_Y_POS = $TEMPLATE_RADIUS - $NOTCH_DEPTH;

// --- Main Body ---
difference() {
    // Create the main disc starting at z=0
    translate([0, 0, 0])
        cylinder(
            h = $TEMPLATE_THICKNESS,
            d = $TEMPLATE_DIAMETER,
            center = true
        );

    // --- Cut Holes ---
    for (r = [0 : $GRID_ROWS - 1]) {
        for (c = [0 : $GRID_COLS - 1]) {
            // Calculate current hole position
            x = (c - ($GRID_COLS - 1) / 2) * $HOLE_SPACING;
            y = (r - ($GRID_ROWS - 1) / 2) * $HOLE_SPACING;
            
            translate([x, y, 0])
                cylinder(
                    h = $TEMPLATE_THICKNESS + 0.1, // Extend slightly past top face to ensure clean cut
                    d = $HOLE_DIAMETER,
                    center = true
                );
        }
    }

    // --- Cut Notch ---
    // The notch is a rectangular cut on the side face.
    // We define a block that overlaps the side of the cylinder at the specific Y location.
    // We extend slightly in X and Y to ensure a clean cut, but keep Z tight to avoid floating artifacts.
    
    translate([0, $NOTCH_Y_POS, 0])
        cube([
            $NOTCH_WIDTH + 0.1, // Extend slightly past X edges
            $NOTCH_DEPTH + 0.1, // Extend slightly past Y edges
            $TEMPLATE_THICKNESS + 0.01 // Extend just enough to cut through, avoiding large gaps
        ]);
}