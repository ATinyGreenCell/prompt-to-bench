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

// Calculate total width of the tooth row
tooth_row_w = num_teeth * tooth_w + (num_teeth - 1) * tooth_gap;

// Position the tooth row so it is centred on the spine in X
// The spine is centred at X=0. The tooth row starts at X = -(spine_len - tooth_row_w)/2
tooth_row_x_start = -(spine_len - tooth_row_w) / 2;

// The teeth hang from the top edge of the spine (Y = spine_w / 2)
// The teeth extend in the -Y direction.
// Tooth Y range: [spine_w/2 - tooth_l, spine_w/2]
// Spine Y range: [-spine_w/2, spine_w/2]

difference() {
    // 1. The main spine (back bar)
    translate([0, -spine_w / 2, 0]) 
        cube([spine_len, spine_w, comb_thk]);

    // 2. The teeth (cutting shapes)
    // We iterate through each tooth and cut it out of the spine.
    // The teeth are arranged in a row.
    // Position of tooth i (0 to num_teeth-1):
    // x = tooth_row_x_start + i * (tooth_w + tooth_gap)
    // y = spine_w / 2 (top edge of spine)
    for (i = [0 : num_teeth - 1]) {
        tx = tooth_row_x_start + i * (tooth_w + tooth_gap);
        
        // Cut the tooth shape. 
        // The tooth is a rectangle of width tooth_w and length tooth_l.
        // It hangs from the top edge of the spine.
        // We extend the cut slightly past the spine thickness to ensure clean separation.
        translate([tx, spine_w / 2, 0]) 
            cube([tooth_w, tooth_l + 0.1, comb_thk + 0.1]);
    }
}