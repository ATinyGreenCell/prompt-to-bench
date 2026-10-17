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
// Total span = (N-1) * spacing. Offset = Total span / 2.
$GRID_OFFSET = (($GRID_ROWS - 1) * $HOLE_SPACING) / 2;

// Calculate notch position relative to center
// Notch is centered on Y axis (X=0).
// Y center is (Radius - Depth/2) to place it on the rim.
$TEMPLATE_RADIUS = $TEMPLATE_DIAMETER / 2;
$NOTCH_Y_CENTER = $TEMPLATE_RADIUS - ($NOTCH_DEPTH / 2);

// --- Main Body ---
difference() {
    // 1. Create the main disc
    translate([0, 0, 0])
        cylinder(
            h = $TEMPLATE_THICKNESS,
            d = $TEMPLATE_DIAMETER,
            $fn = 128
        );

    // 2. Cut the 7x7 grid of holes
    for (r = [0 : $GRID_ROWS - 1]) {
        for (c = [0 : $GRID_COLS - 1]) {
            // Calculate position for this hole
            // Formula: (index * spacing) - offset
            x_pos = (c * $HOLE_SPACING) - $GRID_OFFSET;
            y_pos = (r * $HOLE_SPACING) - $GRID_OFFSET;
            
            translate([x_pos, y_pos, 0])
                cylinder(
                    h = $TEMPLATE_THICKNESS + 0.1, // Extend slightly past bottom to ensure clean cut
                    d = $HOLE_DIAMETER,
                    $fn = 64
                );
        }
    }

    // 3. Cut the rectangular orientation notch on the +Y side
    // The notch is centered on the Y axis (X=0)
    // It extends from the rim inwards by $NOTCH_DEPTH
    // We cut a rectangle that is slightly larger than the notch dimensions to ensure clean edges
    translate([0, $NOTCH_Y_CENTER, 0])
        cube([
            $NOTCH_WIDTH + 0.1, // Extend slightly in X
            $NOTCH_DEPTH + 0.1, // Extend slightly in Y
            $TEMPLATE_THICKNESS + 0.1 // Extend slightly in Z
        ]);
}