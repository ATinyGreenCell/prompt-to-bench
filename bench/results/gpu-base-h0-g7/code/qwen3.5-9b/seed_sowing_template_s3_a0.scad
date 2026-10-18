$fn = 128;

// --- Dimensions ---
// Petri Dish Diameter
$DISH_DIAMETER = 90;
// Template Diameter
$TEMPLATE_DIAMETER = 85;
// Template Thickness
$TEMPLATE_THICKNESS = 2;
// Hole Grid Size
$GRID_ROWS = 7;
$GRID_COLS = 7;
// Hole Diameter
$HOLE_DIAMETER = 3;
// Hole Spacing (Center-to-Center)
$HOLE_SPACING = 9;
// Notch Width (X dimension)
$NOTCH_WIDTH = 10;
// Notch Depth (Y dimension, measured from rim inward)
$NOTCH_DEPTH = 4;

// --- Calculations ---
// Center of the template
$X_CENTER = 0;
$Y_CENTER = 0;
$Z_BOTTOM = 0;
$Z_TOP = $TEMPLATE_THICKNESS;

// Calculate grid offsets to center the 7x7 grid
// Total span = (N-1) * spacing
$GRID_SPAN = ($GRID_ROWS - 1) * $HOLE_SPACING;
$GRID_OFFSET = $GRID_SPAN / 2;

// Calculate rim depth for notch positioning
$RIM_RADIUS = $TEMPLATE_DIAMETER / 2;
$RIM_DEPTH = $RIM_RADIUS - $NOTCH_DEPTH;

// --- Main Body ---
// Create the flat disc
difference() {
    // Outer shape: Cylinder
    cylinder(
        h = $TEMPLATE_THICKNESS,
        d = $TEMPLATE_DIAMETER,
        center = true
    );
    
    // Inner shape: The Notch
    // We cut a rectangular prism from the top face, extending slightly past the bottom to ensure clean cut
    translate([
        0, 
        $RIM_DEPTH - ($NOTCH_WIDTH / 2), // Center Y on the +Y side
        $Z_TOP - 0.05 // Extend slightly past top face
    ]) {
        cube([
            $NOTCH_WIDTH, 
            $NOTCH_DEPTH, 
            $TEMPLATE_THICKNESS + 0.05 // Extend slightly past bottom face
        ]);
    }
}

// --- Holes ---
// Loop to create the 7x7 grid of holes
for (r = [0 : $GRID_ROWS - 1], c = [0 : $GRID_COLS - 1]) {
    // Calculate position for current hole
    $x_pos = $X_CENTER + (c - ($GRID_COLS - 1) / 2) * $HOLE_SPACING;
    $y_pos = $Y_CENTER + (r - ($GRID_ROWS - 1) / 2) * $HOLE_SPACING;
    
    // Cut hole
    translate([
        $x_pos, 
        $y_pos, 
        $Z_BOTTOM - 0.05 // Extend slightly past bottom face
    ]) {
        cylinder(
            h = $TEMPLATE_THICKNESS + 0.05,
            d = $HOLE_DIAMETER,
            center = true
        );
    }
}