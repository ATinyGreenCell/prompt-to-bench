// 10-well agarose gel comb - flat plate with spine and hanging teeth.
// Orientation: Lying flat on XY plane, spine along X, teeth hanging in -Y.

// Dimensions
spine_len = 70;
spine_w   = 12;
comb_thk  = 1.5;

tooth_w   = 5.0;
tooth_l   = 12;
tooth_gap = 1.5;
num_teeth = 10;

$fn = 64;

// Calculate total width of the tooth row (teeth + gaps)
tooth_row_w = num_teeth * tooth_w + (num_teeth - 1) * tooth_gap;

// Position the tooth row so it is centred on the spine in X
tooth_row_x_start = -(spine_len - tooth_row_w) / 2;

difference() {
    // 1. The main spine (back bar)
    translate([0, -spine_w / 2, 0]) 
        cube([spine_len, spine_w, comb_thk]);

    // 2. The wells (cutting shapes)
    // We iterate through each tooth position and cut out the tooth AND the gap.
    // This creates the empty space for the agarose well.
    for (i = [0 : num_teeth - 1]) {
        tx = tooth_row_x_start + i * (tooth_w + tooth_gap);
        
        // Calculate the width of the cut: tooth width + gap width
        cut_w = tooth_w + tooth_gap;
        
        // The cut extends slightly past the spine thickness to ensure clean separation
        translate([tx, spine_w / 2, 0]) 
            cube([cut_w, tooth_l + 0.1, comb_thk + 0.1]);
    }
}