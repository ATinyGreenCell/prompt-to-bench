// 10-well agarose gel comb - flat plate with spine and hanging teeth.
// Orientation: Lying flat on XY plane, spine along X, teeth hanging in -Y.

// Dimensions
spine_len = 70;   // Length of the spine (X)
spine_w   = 12;   // Width of the spine (Y)
thickness = 1.5;  // Thickness of the plate (Z)

tooth_w   = 5.0;  // Width of each tooth (X)
tooth_h   = 12;   // Length of each tooth (Y)
gap       = 1.5;  // Gap between teeth (X)
n_teeth   = 10;   // Number of teeth

$fn = 64;

// Calculate total width of the tooth row
tooth_row_w = n_teeth * tooth_w + (n_teeth - 1) * gap;

// The spine is centered at X=0.
// The tooth row is centered on the spine in X, so it is also centered at X=0.
// The teeth hang from the -Y edge of the spine.
// Spine Y range: [-spine_w/2, spine_w/2] = [-6, 6].
// Teeth start at Y = -6 and extend to Y = -6 - tooth_h.

difference() {
    union() {
        // 1. The Spine
        // X: [-35, 35], Y: [-6, 6], Z: [0, 1.5]
        translate([-spine_len / 2, -spine_w / 2, 0]) 
            cube([spine_len, spine_w, thickness]);

        // 2. The Teeth Block
        // X: [-tooth_row_w/2, tooth_row_w/2]
        // Y: [-spine_w/2 - tooth_h, -spine_w/2]
        // Z: [0, thickness]
        translate([-tooth_row_w / 2, -spine_w / 2 - tooth_h, 0])
            cube([tooth_row_w, tooth_h, thickness]);
    }
    
    // Cut out the gaps between teeth
    // There are n_teeth - 1 gaps.
    // We iterate i from 0 to n_teeth - 2.
    for (i = [0 : n_teeth - 2]) {
        // Calculate X position of the gap
        // The tooth row starts at -tooth_row_w / 2.
        // Tooth 0 starts at -tooth_row_w / 2.
        // Tooth i starts at -tooth_row_w / 2 + i * (tooth_w + gap).
        // Gap i is between Tooth i and Tooth i+1.
        // Gap i starts at (Start of Tooth i) + tooth_w.
        
        row_start = -tooth_row_w / 2;
        gap_x_start = row_start + i * (tooth_w + gap) + tooth_w;
        gap_x_center = gap_x_start + gap / 2;
        
        // Cut a slot through the teeth block
        // The slot must be slightly wider than the gap to ensure clean separation.
        // We cut a rectangle of width (gap + 0.1).
        // Y range of the cut: full height of the teeth block (tooth_h).
        // Z range: extend slightly below Z=0 to ensure clean cut.
        translate([gap_x_center, -spine_w / 2 - tooth_h / 2, -0.1])
            cube([gap + 0.1, tooth_h, thickness + 0.1]);
    }
}