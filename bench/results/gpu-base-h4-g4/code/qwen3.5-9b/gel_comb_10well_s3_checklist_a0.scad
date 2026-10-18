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
// So the top of the teeth aligns with the -Y edge of the spine.
// We need to shift the tooth row in Y so its center aligns with the spine center.
// Spine center Y = 0.
// Tooth row center Y = 0.
// Tooth row extends from Y = -tooth_row_w/2 to Y = +tooth_row_w/2.
// Spine extends from Y = -spine_w/2 to Y = +spine_w/2.
// The teeth hang from the spine's -Y edge (Y = -spine_w/2).
// So the top of the teeth (Y = +tooth_h relative to spine edge) must be at Y = -spine_w/2.
// Wait, the teeth hang *from* the spine.
// Let's define the spine as the base.
// Spine Y range: [-6, 6].
// Teeth hang in -Y direction.
// So the "top" of the teeth (where they attach) is at Y = -6.
// The teeth extend from Y = -6 down to Y = -6 - tooth_h.
// The tooth row width is tooth_row_w.
// The center of the tooth row in X must be 0.
// The center of the tooth row in Y must be such that the top edge is at Y = -6.
// Center Y = (Top Y + Bottom Y) / 2 = (-6 + (-6 - tooth_h)) / 2 = -6 - tooth_h/2.

tooth_row_y_center = -spine_w / 2 - tooth_h / 2;

// Calculate X positions for the teeth
// Total width of tooth row = tooth_row_w.
// Center is at X = 0.
// We need to place num_teeth items with spacing gap.
// The positions are centered.
// Let's generate the X coordinates.
// The pattern is: tooth, gap, tooth, gap, ... tooth.
// Total width = N*tooth_w + (N-1)*gap.
// The center of the first tooth is at: - (tooth_row_w / 2) + (tooth_w / 2).
// Let's verify:
// Center of pattern = 0.
// Left edge of pattern = -tooth_row_w / 2.
// Right edge of pattern = +tooth_row_w / 2.
// First tooth center = Left edge + tooth_w / 2 = -tooth_row_w / 2 + tooth_w / 2.
// Step size = tooth_w + gap.
// Position i (0 to num_teeth-1) = First tooth center + i * step.

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
        // Each tooth is a block of size: tooth_w x tooth_l x plate_thk
        // They hang from the spine.
        // The spine is at Y = [-6, 6].
        // The teeth hang in -Y.
        // The attachment face is at Y = -6.
        // The teeth extend from Y = -6 to Y = -6 - tooth_h.
        // Wait, the tooth length is 12mm.
        // If they hang from the spine, the dimension along Y is tooth_h.
        // The spine is 12mm wide.
        // So the teeth are 12mm long (Y) and hang from the 12mm wide spine?
        // "10 rectangular teeth that hang from one long edge of the spine in the -Y direction."
        // "Each tooth is 5.0 mm wide (X) and 12 mm long (Y)."
        // This implies the tooth length (Y) is equal to the spine width (Y).
        // So the teeth are essentially extensions of the spine width, but hanging down.
        // So the Y range of a tooth is [-6, -6 - 12] = [-6, -18].
        // The spine is at Y = [-6, 6].
        // So the teeth are attached at Y = -6.
        
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
    
    // Optional: Add a small fillet or chamfer if desired, but not requested.
    // Just the solid block.
}