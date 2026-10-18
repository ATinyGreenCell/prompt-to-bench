// 10-well agarose gel comb - flat plate with spine and 10 hanging teeth.
// Orientation: Lying flat on XY plane, spine along X, teeth hanging in -Y.

// Dimensions
spine_len = 70;   // Length of the spine (X)
spine_w   = 12;   // Width of the spine (Y)
plate_thk = 1.5;  // Thickness of the plate (Z)

tooth_w   = 5.0;  // Width of each tooth (X)
tooth_l   = 12;   // Length of each tooth (Y)
tooth_h   = 12;   // Height of each tooth hanging from spine (Y)
num_teeth = 10;   // Number of teeth
gap       = 1.5;  // Gap between teeth (X)

$fn = 64;

// Calculate total width of the tooth row
tooth_row_w = (num_teeth * tooth_w) + ((num_teeth - 1) * gap);

// Calculate the offset to centre the tooth row on the spine width
// Spine is 12mm wide. Tooth row is centered.
// The teeth hang from the -Y edge of the spine.
// Spine Y range: [-6, 6].
// Teeth hang in -Y.
// The attachment face is at Y = -6.
// The teeth extend from Y = -6 down to Y = -6 - tooth_h.
// Tooth row center Y = -6 - tooth_h / 2.
tooth_row_y_center = -spine_w / 2 - tooth_h / 2;

// Calculate X positions for the teeth
// Total width of tooth row = tooth_row_w.
// Center is at X = 0.
// Step size = tooth_w + gap.
// First tooth center = -tooth_row_w / 2 + tooth_w / 2.
step = tooth_w + gap;
first_tooth_x = -tooth_row_w / 2 + tooth_w / 2;

difference() {
    union() {
        // 1. The Spine (Back Bar)
        // Dimensions: spine_len x spine_w x plate_thk
        // Centered at origin, sitting on Z=0.
        translate([0, -spine_w / 2, 0]) 
            cube([spine_len, spine_w, plate_thk]);

        // 2. The Teeth
        // Each tooth is a block of size: tooth_w x tooth_h x plate_thk
        // They hang from the spine.
        // The spine is at Y = [-6, 6].
        // The teeth hang in -Y.
        // The attachment face is at Y = -6.
        // The teeth extend from Y = -6 to Y = -6 - tooth_h.
        
        for (i = [0 : num_teeth - 1]) {
            tx = first_tooth_x + i * step;
            
            // Tooth geometry
            // X: tx - tooth_w/2 to tx + tooth_w/2
            // Y: -spine_w/2 - tooth_h to -spine_w/2 (hanging down)
            // Z: 0 to plate_thk
            
            translate([tx, -spine_w / 2 - tooth_h, 0])
                cube([tooth_w, tooth_h, plate_thk]);
        }
    }
}