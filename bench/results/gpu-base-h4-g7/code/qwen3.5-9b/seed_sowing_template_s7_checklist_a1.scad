// Sowing template for a 90 mm Petri dish.
// Flat disc 85 mm diameter, 2 mm thick.
// 7x7 grid of 3 mm holes, 9 mm spacing, centred.
// Rectangular notch on the +Y rim: 10 mm wide, 4 mm deep.

$fn = 64;

// Dimensions
DISC_DIA = 85;
THICKNESS = 2;
GRID_SIZE = 7;
HOLE_DIA = 3;
HOLE_SPACING = 9;
NOTCH_WIDTH = 10;
NOTCH_DEPTH = 4;

// Calculate grid positions
// Total span = (7-1) * 9 = 54mm. Half span = 27mm.
// We want the grid to be centred at 0,0.
GRID_HALF_SPAN = (GRID_SIZE - 1) * HOLE_SPACING / 2;

difference() {
    // Main disc body
    translate([0, 0, 0])
        cylinder(h = THICKNESS, d = DISC_DIA);

    // Grid of holes
    // Loop i from 0 to 6.
    // Position = (i - (GRID_SIZE-1)/2) * spacing
    // For i=3 (middle), pos = 0.
    for (i = [0 : GRID_SIZE - 1]) {
        x = (i - GRID_HALF_SPAN) * HOLE_SPACING;
        y = (i - GRID_HALF_SPAN) * HOLE_SPACING;
        
        // Cut hole extending slightly past the face
        translate([x, y, -0.01])
            cylinder(h = THICKNESS + 0.01, d = HOLE_DIA);
    }

    // Rectangular orientation notch on the +Y side
    // Notch is 10mm wide (X) and 4mm deep (Y, measured in from rim).
    // Rim radius is DISC_DIA / 2 = 42.5 mm.
    // Notch starts at Y = 42.5 - 4 = 38.5 mm.
    // Notch is centred on Y axis, so X range is [-5, 5].
    
    notch_start_y = DISC_DIA / 2 - NOTCH_DEPTH;
    
    translate([0, notch_start_y, -0.01])
        cube([NOTCH_WIDTH, NOTCH_DEPTH, THICKNESS + 0.01]);
}