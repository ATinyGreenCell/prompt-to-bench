$fn = 128;

// --- Dimensions ---
// Petri Dish Diameter
$DISH_DIAMETER = 90;
// Template Diameter
$TEMPLATE_DIAMETER = 85;
// Template Thickness
$TEMPLATE_THICKNESS = 2;
// Hole Diameter
$HOLE_DIAMETER = 3;
// Hole Spacing (Center-to-Center)
$HOLE_SPACING = 9;
// Grid Size (7x7)
$GRID_SIZE = 7;
// Notch Width (X dimension)
$NOTCH_WIDTH = 10;
// Notch Depth (Y dimension, measured from rim inward)
$NOTCH_DEPTH = 4;

// --- Calculations ---
// Radius of the template
$R = $TEMPLATE_DIAMETER / 2;
// Radius of the hole
$r_hole = $HOLE_DIAMETER / 2;
// Offset for the grid to center it on the disc
$OFFSET = ($GRID_SIZE - 1) * ($HOLE_SPACING / 2);

// --- Main Body ---
// Create the flat disc lying on the XY plane (Z=0)
difference() {
    // Main Cylinder
    cylinder(
        h = $TEMPLATE_THICKNESS,
        d = $TEMPLATE_DIAMETER,
        center = true
    );
    
    // Cut the 7x7 Grid of Holes
    for (i = [0 : $GRID_SIZE - 1]) {
        for (j = [0 : $GRID_SIZE - 1]) {
            // Calculate position for each hole
            // i and j range from 0 to 6. Center is at 3.
            // x_pos = (i - 3) * spacing
            // y_pos = (j - 3) * spacing
            x_pos = (i - 3) * $HOLE_SPACING;
            y_pos = (j - 3) * $HOLE_SPACING;
            
            // Cut hole extending slightly past the face to ensure clean removal
            cylinder(
                h = $TEMPLATE_THICKNESS + 0.1,
                d = $HOLE_DIAMETER,
                center = [x_pos, y_pos, 0]
            );
        }
    }
    
    // Cut the Orientation Notch
    // Location: +Y side, centered on Y axis.
    // Width: 10mm along X.
    // Depth: 4mm inward from the rim (R - 4).
    // The notch goes from Z=0 to Z=2.
    
    // We cut a rectangular prism that intersects the cylinder.
    // To ensure the cut is clean, we extend the cutter slightly in Z.
    translate([0, 0, 0]) {
        difference() {
            // The "negative" space we want to create is a block.
            // We define the block relative to the cylinder surface.
            // The block starts at Y = R - $NOTCH_DEPTH and goes to Y = R.
            // It spans X from -($NOTCH_WIDTH/2) to +($NOTCH_WIDTH/2).
            // It spans Z from 0 to $TEMPLATE_THICKNESS + 0.1.
            
            // Since we are inside a difference(), we just place the cutter.
            // The cutter needs to be large enough to cover the full width of the notch.
            // Width = 10mm. Depth = 4mm. Height = 2mm.
            // Position: Centered at X=0. Y starts at (R - 4).
            
            translate([0, $R - $NOTCH_DEPTH, 0]) {
                cube([
                    $NOTCH_WIDTH, 
                    $NOTCH_DEPTH, 
                    $TEMPLATE_THICKNESS + 0.1
                ]);
            }
        }
    }
}