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
    // Ensure it sits on the bed (z=0) by not centering it vertically
    translate([0, 0, 0])
        cylinder(
            h = $DISC_THICKNESS,
            r = $DISC_DIAMETER / 2,
            center = false // Bottom is at z=0
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
    // Specification: "centred on the Y axis" -> Center X = 0 relative to the notch's own center.
    // Specification: "on the +Y side" -> Located at the positive X rim of the disc.
    // Specification: "10 mm wide (X)" -> Width along X axis.
    // Specification: "4 mm deep (Y, measured in from the rim)" -> Depth along Y axis (4mm total height).
    
    // The notch is a rectangular cutout.
    // Local cube dimensions: Width X, Depth Y, Height Z
    local_x = $NOTCH_WIDTH_X / 2;
    local_y = $NOTCH_DEPTH_Y / 2;
    
    // Translate to position on the rim (positive X) and centered on Y axis.
    // The rim is at X = $DISC_DIAMETER / 2.
    // The notch is centered on the Y axis, so its Y center is 0.
    // We translate the cube to be centered at (0,0) in local space, then move it to the rim.
    
    translate([$DISC_DIAMETER / 2, 0, 0]) 
        cube([
            $NOTCH_WIDTH_X, 
            $NOTCH_DEPTH_Y, 
            $DISC_THICKNESS + 0.1 // Extend slightly past bottom to ensure clean cut
        ]);
}