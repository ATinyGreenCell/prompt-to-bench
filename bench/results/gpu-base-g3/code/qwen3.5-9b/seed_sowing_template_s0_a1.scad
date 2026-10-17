$fn = 128;

// --- Dimensions ---
// Petri dish inner diameter reference
$DISH_DIAMETER = 90;

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
// For 7 items with 9mm spacing, total span is 6 * 9 = 54mm.
// Offset from center is 27mm.
$GRID_OFFSET = (($GRID_ROWS - 1) * $HOLE_SPACING) / 2;

// Calculate notch position relative to center
// Notch is centered on Y axis (X=0).
// It is located at the rim edge, moving inward by $NOTCH_DEPTH.
$TEMPLATE_RADIUS = $TEMPLATE_DIAMETER / 2;
$NOTCH_Y_POS = $TEMPLATE_RADIUS - $NOTCH_DEPTH;

// --- Main Body ---
// Create the flat disc
// Translate up by half thickness to sit on Z=0
translate([0, 0, $TEMPLATE_THICKNESS / 2]) {
    difference() {
        // Main cylinder
        cylinder(
            h = $TEMPLATE_THICKNESS,
            d = $TEMPLATE_DIAMETER,
            center = true
        );

        // --- Cut Holes ---
        // Loop for 7x7 grid
        for (r = [0 : $GRID_ROWS - 1], c = [0 : $GRID_COLS - 1]) {
            translate([
                $GRID_OFFSET * c - $GRID_OFFSET,
                $GRID_OFFSET * r - $GRID_OFFSET,
                -$TEMPLATE_THICKNESS / 2 - 0.01 // Extend slightly past bottom
            ]) {
                cylinder(
                    h = $TEMPLATE_THICKNESS + 0.02, // Extend slightly past top
                    d = $HOLE_DIAMETER,
                    center = true
                );
            }
        }

        // --- Cut Notch ---
        // The notch is a rectangular cut on the side face.
        // We define a box that intersects the side of the cylinder.
        // Position: Centered at X=0, Y=$NOTCH_Y_POS, Z=0 (mid-height of disc)
        // Size: Width=$NOTCH_WIDTH, Height=$NOTCH_DEPTH, Depth=$TEMPLATE_THICKNESS
        translate([
            0,
            $NOTCH_Y_POS,
            0
        ]) {
            // Add a small buffer to ensure clean cut
            cube([
                $NOTCH_WIDTH + 0.1,
                $NOTCH_DEPTH + 0.1,
                $TEMPLATE_THICKNESS + 0.1
            ]);
        }
    }
}