// Sowing template for 90mm Petri dish - flat disc with grid holes and orientation notch.

// Dimensions
DISH_DIA = 90;
DISC_DIA = 85;
THICKNESS = 2;
HOLE_COUNT = 7;
HOLE_DIA = 3;
HOLE_SPACING = 9;
NOTCH_WIDTH = 10;
NOTCH_DEPTH = 4;

$fn = 64;

// Calculate grid offsets to center the grid on the origin
// For 7 holes, indices are 0..6. Center index is 3.
// Offset = (index - 3) * spacing
grid_offset = (HOLE_COUNT - 1) / 2 * HOLE_SPACING;

difference() {
    // Main disc body
    translate([-DISC_DIA / 2, -DISC_DIA / 2, 0])
        cube([DISC_DIA, DISC_DIA, THICKNESS]);

    // Grid of holes
    for (i = [0 : HOLE_COUNT - 1]) {
        x_pos = (i - grid_offset) * HOLE_SPACING;
        
        // Cut hole through the entire thickness
        translate([x_pos, 0, -1])
            cylinder(h = THICKNESS + 2, d = HOLE_DIA);
    }

    // Orientation notch on the +Y side
    // The notch is 4mm deep, measured from the rim inward.
    // Rim Y is DISC_DIA / 2.
    // The cut must start at (Rim Y - Depth) and extend to Rim Y.
    notch_y_start = DISC_DIA / 2 - NOTCH_DEPTH;
    
    // Create the notch shape (a rectangular prism)
    // Position: X=0, Y=notch_y_start, Z=-1 (below bed)
    // Size: X=NOTCH_WIDTH, Y=NOTCH_DEPTH, Z=THICKNESS+2
    // This shape sits inside the disc and cuts out the material up to the rim.
    translate([0, notch_y_start, -1])
        cube([NOTCH_WIDTH, NOTCH_DEPTH, THICKNESS + 2]);
}