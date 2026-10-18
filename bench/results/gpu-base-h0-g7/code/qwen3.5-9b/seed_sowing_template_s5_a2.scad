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

// --- Main Body ---
// Create the flat disc lying on the XY plane (Z=0).
// We do NOT use center=true. We place the cylinder at Z=0 so the bottom is at Z=0.
difference() {
    // Main Cylinder
    // Position: X=0, Y=0, Z=0. Height = 2mm.
    cylinder(
        h = $TEMPLATE_THICKNESS,
        d = $TEMPLATE_DIAMETER,
        center = false
    );
    
    // Cut the 7x7 Grid of Holes
    // We subtract cylinders that extend slightly past the top face (Z=2) to ensure clean removal.
    for (i = [0 : $GRID_SIZE - 1]) {
        for (j = [0 : $GRID_SIZE - 1]) {
            // Calculate position for each hole
            // i and j range from 0 to 6. Center is at 3.
            // x_pos = (i - 3) * spacing
            // y_pos = (j - 3) * spacing
            x_pos = (i - 3) * $HOLE_SPACING;
            y_pos = (j - 3) * $HOLE_SPACING;
            
            // Cut hole extending slightly past the face to ensure clean removal
            // The hole goes from Z=0 to Z=2. We cut to Z=2.1.
            translate([x_pos, y_pos, 0]) {
                cylinder(
                    h = $TEMPLATE_THICKNESS + 0.1,
                    d = $HOLE_DIAMETER,
                    center = false
                );
            }
        }
    }
    
    // Cut the Orientation Notch
    // Location: +Y side, centered on Y axis.
    // Width: 10mm along X.
    // Depth: 4mm inward from the rim (R - 4).
    // The notch goes from Z=0 to Z=2.
    
    // We cut a rectangular prism that intersects the cylinder.
    // Position: Centered at X=0. Y starts at (R - 4).
    // The cutter needs to cover the full width and depth.
    // We extend the cutter slightly in Z to ensure it cuts through the top face cleanly.
    translate([0, $R - $NOTCH_DEPTH, 0]) {
        cube([
            $NOTCH_WIDTH, 
            $NOTCH_DEPTH, 
            $TEMPLATE_THICKNESS + 0.1
        ]);
    }
}