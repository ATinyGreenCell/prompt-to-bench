$fn = 128;

// --- Dimensions ---
// Petri Dish Diameter (for reference)
$DISH_DIAMETER = 90;

// Disc Dimensions
$DISC_DIAMETER = 85;
$DISC_THICKNESS = 2;

// Grid Configuration
$GRID_ROWS = 7;
$GRID_COLS = 7;
$HOLE_DIAMETER = 3;
$HOLE_SPACING = 9;

// Notch Dimensions (on +Y side)
$NOTCH_WIDTH_X = 10;
$NOTCH_DEPTH_Y = 4;

// --- Variables ---
// Calculate grid offset to center the 7x7 grid
$GRID_OFFSET = (($GRID_ROWS - 1) * $HOLE_SPACING) / 2;

// Main Body
difference() {
    // Create the main disc
    translate([0, 0, 0])
        cylinder(
            h = $DISC_THICKNESS,
            r = $DISC_DIAMETER / 2,
            center = true
        );

    // Cut the 7x7 grid of holes
    for (r = [0 : $GRID_ROWS - 1]) {
        for (c = [0 : $GRID_COLS - 1]) {
            // Calculate position for this hole
            x = c * $HOLE_SPACING - $GRID_OFFSET;
            y = r * $HOLE_SPACING - $GRID_OFFSET;
            
            translate([x, y, 0])
                cylinder(
                    h = $DISC_THICKNESS + 0.1, // Extend slightly past bottom to ensure clean cut
                    r = $HOLE_DIAMETER / 2,
                    center = true
                );
        }
    }

    // Cut the orientation notch on the +Y side
    // The notch is centered on the Y axis, so its center Y is 0.
    // It extends from Y = -NOTCH_DEPTH_Y/2 to Y = +NOTCH_DEPTH_Y/2 relative to the center line.
    // Since it's on the +Y side of the rim, we cut into the positive Y region.
    // The notch width is along X.
    
    translate([0, $NOTCH_DEPTH_Y / 2, 0]) // Shift to center the notch on the Y-axis
        cube([
            $NOTCH_WIDTH_X, 
            $NOTCH_DEPTH_Y, 
            $DISC_THICKNESS + 0.1 // Extend slightly past bottom
        ]);
}