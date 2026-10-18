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
$GRID_SPAN = ($GRID_ROWS - 1) * $HOLE_SPACING;
$GRID_OFFSET = $GRID_SPAN / 2;

// Calculate rim depth for notch positioning
$RIM_RADIUS = $TEMPLATE_DIAMETER / 2;
// The notch starts at this Y coordinate (Rim Radius - Depth)
$NOTCH_START_Y = $RIM_RADIUS - $NOTCH_DEPTH;
// The center of the notch in Y (Start + Width/2)
$NOTCH_CENTER_Y = $NOTCH_START_Y + ($NOTCH_WIDTH / 2);

// --- Main Body ---
difference() {
    // Outer shape: Cylinder
    cylinder(
        h = $TEMPLATE_THICKNESS,
        d = $TEMPLATE_DIAMETER,
        center = true
    );
    
    // Inner shape: The Notch
    // Positioned on the +Y side, centered on the Y axis of the notch itself
    translate([
        0, 
        $NOTCH_CENTER_Y, 
        $Z_TOP - 0.01 // Extend slightly past top face
    ]) {
        cube([
            $NOTCH_WIDTH, 
            $NOTCH_DEPTH, 
            $TEMPLATE_THICKNESS + 0.01 // Extend slightly past bottom face
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
        $Z_BOTTOM - 0.01 // Extend slightly past bottom face
    ]) {
        cylinder(
            h = $TEMPLATE_THICKNESS + 0.01,
            d = $HOLE_DIAMETER,
            center = true
        );
    }
}

// --- Final Positioning ---
// The difference operation creates a shell where the bottom of the cuts is at Z = -0.01 (approx).
// We translate the entire assembly up by the max depth of the cuts to ensure the bottom is exactly at Z=0.
// Max depth is roughly 1mm (thickness + 0.01 extension).
translate([0, 0, $TEMPLATE_THICKNESS + 0.01]) {
    // The geometry defined above
}