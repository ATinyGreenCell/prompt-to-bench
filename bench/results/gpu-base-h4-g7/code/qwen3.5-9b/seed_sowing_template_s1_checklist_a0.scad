// Sowing template for 90mm Petri dish - flat disc with grid holes and orientation notch.

// Dimensions
DISH_DIAMETER = 90;
DISC_DIAMETER = 85;
THICKNESS     = 2;
HOLE_COUNT    = 7;
HOLE_DIAMETER = 3;
HOLE_SPACING  = 9;
NOTCH_WIDTH   = 10;
NOTCH_DEPTH   = 4;

$fn = 128;

// Calculate grid positions centred on origin
// n features spaced p apart and centred on the origin sit at (i - (n - 1) / 2) * p
grid_offset = (HOLE_COUNT - 1) / 2 * HOLE_SPACING;

difference() {
    // Main disc body
    translate([-DISC_DIAMETER / 2, -DISC_DIAMETER / 2, 0])
        cube([DISC_DIAMETER, DISC_DIAMETER, THICKNESS]);

    // Grid of holes
    for (i = [0 : HOLE_COUNT - 1]) {
        x_pos = (i - grid_offset) * HOLE_SPACING;
        y_pos = (i - grid_offset) * HOLE_SPACING;
        
        // Cut hole extending slightly past the face to ensure clean cut
        translate([x_pos, y_pos, -1])
            cylinder(h = THICKNESS + 2, d = HOLE_DIAMETER);
    }

    // Orientation notch on the +Y side
    // Notch is 10mm wide (X) and 4mm deep (Y, measured in from the rim)
    // Rim Y position = DISC_DIAMETER / 2 = 42.5
    // Notch starts at Y = 42.5 - 4 = 38.5
    // Notch extends to Y = 42.5
    // Notch is centred on Y axis, so X range is [-5, 5]
    
    translate([0, DISC_DIAMETER / 2 - NOTCH_DEPTH, 0])
        cube([NOTCH_WIDTH, NOTCH_DEPTH, THICKNESS + 2]);
}