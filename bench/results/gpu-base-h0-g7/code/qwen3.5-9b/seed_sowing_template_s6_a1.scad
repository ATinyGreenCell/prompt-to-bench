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

// Notch dimensions
$NOTCH_WIDTH = 10;
$NOTCH_DEPTH = 4;

// --- Calculations ---
// Calculate grid offset to center the 7x7 grid on the disc
$GRID_OFFSET = (($GRID_ROWS - 1) * $HOLE_SPACING) / 2;

// --- Main Body ---
difference() {
    // Outer disc
    // Removed 'center=true' and added translation to ensure bottom is at Z=0
    translate([0, 0, -$TEMPLATE_THICKNESS/2]) {
        cylinder(
            h = $TEMPLATE_THICKNESS,
            d = $TEMPLATE_DIAMETER,
            center = false
        );
    }
    
    // Cut the 7x7 grid of holes
    for (x = [-$GRID_OFFSET : $HOLE_SPACING : $GRID_OFFSET]) {
        for (y = [-$GRID_OFFSET : $HOLE_SPACING : $GRID_OFFSET]) {
            translate([x, y, -$TEMPLATE_THICKNESS/2 - 0.01]) {
                cylinder(
                    h = $TEMPLATE_THICKNESS + 0.01,
                    d = $HOLE_DIAMETER,
                    center = false
                );
            }
        }
    }
    
    // Cut the orientation notch on the +Y side
    // The notch is 10mm wide (X) and 4mm deep (Y)
    // It is centered on the Y axis, so it spans from -5 to +5 in X
    // It cuts into the rim from the outside in.
    // Rim radius is 85/2 = 42.5mm.
    // Notch starts at Y = 42.5 - 4 = 38.5mm and goes to Y = 42.5mm.
    
    translate([0, 42.5 - $NOTCH_DEPTH, -$TEMPLATE_THICKNESS/2 - 0.01]) {
        // The notch is a rectangular prism cutting into the disc
        // Width = 10mm, Depth = 4mm, Thickness = 2mm
        cube([
            $NOTCH_WIDTH, 
            $NOTCH_DEPTH, 
            $TEMPLATE_THICKNESS + 0.01
        ]);
    }
}