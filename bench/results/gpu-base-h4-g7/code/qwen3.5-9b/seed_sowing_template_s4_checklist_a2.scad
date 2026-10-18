// Sowing template for 90mm Petri dish - flat disc with grid of holes and orientation notch.

// Dimensions
DISH_DIAMETER = 90;
DISC_DIAMETER = 85;
THICKNESS     = 2;
HOLE_COUNT    = 7;
HOLE_DIAMETER = 3;
HOLE_SPACING  = 9;
NOTCH_WIDTH   = 10;
NOTCH_DEPTH   = 4;

$fn = 64;

difference() {
    // Main disc body, centred on X/Y, sitting on Z=0
    // Spec says "disc", so we use a circle extruded, not a square.
    // To sit on Z=0 and be centred, we use rotate_extrude on a semi-circle or linear_extrude on a circle.
    // Using linear_extrude on a circle is simpler for a flat disc.
    // Circle radius = DISC_DIAMETER / 2
    translate([0, 0, 0]) 
        linear_extrude(height = THICKNESS) 
            circle(d = DISC_DIAMETER);
    
    // Cut holes
    // 7x7 grid, 9mm spacing, centred on origin.
    // Indices 0..6. Center index is 3.
    // Position = (i - 3) * 9
    for (i = [0 : HOLE_COUNT - 1]) {
        for (j = [0 : HOLE_COUNT - 1]) {
            let(x = (i - (HOLE_COUNT - 1) / 2) * HOLE_SPACING) {
                let(y = (j - (HOLE_COUNT - 1) / 2) * HOLE_SPACING) {
                    translate([x, y, 0]) cylinder(h = THICKNESS + 1, d = HOLE_DIAMETER);
                }
            }
        }
    }
    
    // Cut orientation notch on +Y side
    // Spec: 10 mm wide (X), 4 mm deep (Y, measured in from the rim), centred on Y axis.
    // Disc radius = 42.5.
    // Notch starts at Y = 42.5 - 4 = 38.5.
    // Notch ends at Y = 42.5 (the rim).
    // Notch spans X from -5 to +5.
    translate([0, DISC_DIAMETER / 2 - NOTCH_DEPTH, 0]) {
        // Create a rectangular prism that cuts the notch
        // Width = NOTCH_WIDTH, Depth = NOTCH_DEPTH, Height = THICKNESS + buffer
        translate([-NOTCH_WIDTH / 2, 0, 0]) 
            cube([NOTCH_WIDTH, NOTCH_DEPTH, THICKNESS + 1]);
    }
}