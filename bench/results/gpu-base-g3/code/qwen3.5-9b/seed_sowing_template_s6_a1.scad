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

// Notch dimensions
$NOTCH_WIDTH = 10;
$NOTCH_DEPTH = 4; // Total height of the notch along Y

// --- Calculated Variables ---
// Calculate grid offset to center the 7x7 grid
$GRID_OFFSET = (($GRID_ROWS - 1) * $HOLE_SPACING) / 2;

// --- Main Body ---
difference() {
    // Create the solid disc
    // Centered at (0,0,0)
    cylinder(
        h = $TEMPLATE_THICKNESS,
        d = $TEMPLATE_DIAMETER,
        center = true
    );
    
    // Cut the 7x7 grid of holes
    // Position: z = -0.01 to ensure clean cut without going below bed
    for (y = [0 : $GRID_ROWS - 1]) {
        for (x = [0 : $GRID_COLS - 1]) {
            translate([
                $GRID_OFFSET - ($HOLE_SPACING * x),
                $GRID_OFFSET - ($HOLE_SPACING * y),
                -0.01
            ]) {
                cylinder(
                    h = $TEMPLATE_THICKNESS + 0.1,
                    d = $HOLE_DIAMETER,
                    center = true
                );
            }
        }
    }
    
    // Cut the orientation notch on the +Y side
    // Specification: "centred on the Y axis"
    // This means the notch is symmetric around Y=0.
    // Width (X): 10mm -> X range: -5 to +5
    // Depth (Y): 4mm -> Y range: -2 to +2 (Total height 4mm centered at 0)
    // Position: z = -0.01 to ensure clean cut without going below bed
    
    translate([
        -$NOTCH_WIDTH / 2,
        -$NOTCH_DEPTH / 2,
        -0.01
    ]) {
        cube([
            $NOTCH_WIDTH,
            $NOTCH_DEPTH,
            $TEMPLATE_THICKNESS + 0.1
        ]);
    }
}