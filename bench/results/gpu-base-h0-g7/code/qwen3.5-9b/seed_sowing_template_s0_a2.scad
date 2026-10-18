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

// Z-offset to ensure the part rests on the bed at Z=0
// Cylinder is centered by default, so we translate it up by half its height.
$Z_OFFSET = $TEMPLATE_THICKNESS / 2;

// --- Main Body ---
difference() {
    // Create the main disc starting at z=0
    // Translate up by half height so bottom is at 0, top is at 2
    translate([0, 0, $Z_OFFSET])
        cylinder(
            h = $TEMPLATE_THICKNESS,
            d = $TEMPLATE_DIAMETER,
            center = false
        );

    // --- Cut Holes ---
    for (r = [0 : $GRID_ROWS - 1]) {
        for (c = [0 : $GRID_COLS - 1]) {
            // Calculate current hole position
            x = (c - ($GRID_COLS - 1) / 2) * $HOLE_SPACING;
            y = (r - ($GRID_ROWS - 1) / 2) * $HOLE_SPACING;
            
            // Cutter extends past the top face (Z=2)
            translate([x, y, 0])
                cylinder(
                    h = $TEMPLATE_THICKNESS + 0.1,
                    d = $HOLE_DIAMETER,
                    center = false
                );
        }
    }

    // --- Cut Notch ---
    // The notch is a rectangular cut on the side face.
    // Position: Y = $NOTCH_Y_POS.
    // X range: -($NOTCH_WIDTH/2) to +($NOTCH_WIDTH/2).
    // Z range: 0 to 2.
    // We extend the cutter slightly past the top and bottom faces to ensure a clean cut.
    
    translate([0, $NOTCH_Y_POS, 0])
        cube([
            $NOTCH_WIDTH + 0.1, // Extend slightly past X edges
            $NOTCH_DEPTH + 0.1, // Extend slightly past Y edges
            $TEMPLATE_THICKNESS + 0.1 // Extend slightly past Z edges (top and bottom)
        ]);
}