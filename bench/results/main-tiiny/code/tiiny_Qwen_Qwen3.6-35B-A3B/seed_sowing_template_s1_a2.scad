// --- Dimensions ---
DISH_RADIUS       = 45;   // Radius of the 90 mm Petri dish (half of 90)
DISC_DIAMETER     = 85;   // Diameter of the sowing template
DISC_THICKNESS    = 2;    // Thickness of the template
HOLE_DIAMETER     = 3;    // Diameter of the grid holes
GRID_SPACING      = 9;    // Centre-to-centre spacing of the grid
GRID_COLS         = 7;    // Number of columns in the grid
GRID_ROWS         = 7;    // Number of rows in the grid
NOTCH_WIDTH       = 10;   // Width of the rectangular notch (along X)
NOTCH_DEPTH       = 4;    // Depth of the notch cut into the rim (along -Y)

// --- Derived Values ---
DISC_RADIUS       = DISC_DIAMETER / 2;
HOLE_RADIUS       = HOLE_DIAMETER / 2;
OVERHANG          = 0.05; // Extra length for boolean operations to ensure clean cuts

// --- Grid Calculations ---
// Calculate the total width/height of the grid to center it
grid_width  = (GRID_COLS - 1) * GRID_SPACING;
grid_height = (GRID_ROWS - 1) * GRID_SPACING;

// Start with the base disc
difference() {
    // Main body of the template
    cylinder(h = DISC_THICKNESS, r = DISC_RADIUS, center = false, $fn = 64);

    // Cut the rectangular notch from the +Y side
    // The notch is centred on the Y axis (X=0).
    // It extends from the rim inward by NOTCH_DEPTH.
    // The rim is at radius DISC_RADIUS. The notch goes from Y = DISC_RADIUS - NOTCH_DEPTH to Y = DISC_RADIUS.
    // We make the cutting box slightly wider and deeper to ensure clean boolean subtraction.
    // The notch must go through the full thickness of the disc (Z=0 to Z=DISC_THICKNESS).
    translate([0, DISC_RADIUS - NOTCH_DEPTH/2, DISC_THICKNESS/2]) {
        cube([NOTCH_WIDTH + OVERHANG*2, NOTCH_DEPTH + OVERHANG*2, DISC_THICKNESS + OVERHANG*2], center = true);
    }

    // Cut the 7x7 grid of holes
    for (x_idx = [0 : GRID_COLS - 1]) {
        for (y_idx = [0 : GRID_ROWS - 1]) {
            // Calculate position relative to center
            // Center of grid is at (0,0)
            x_pos = (x_idx - (GRID_COLS - 1) / 2) * GRID_SPACING;
            y_pos = (y_idx - (GRID_ROWS - 1) / 2) * GRID_SPACING;
            
            translate([x_pos, y_pos, 0]) {
                // Extend hole slightly past the bottom and top surfaces
                cylinder(h = DISC_THICKNESS + OVERHANG*2, r = HOLE_RADIUS, center = false, $fn = 32);
            }
        }
    }
}