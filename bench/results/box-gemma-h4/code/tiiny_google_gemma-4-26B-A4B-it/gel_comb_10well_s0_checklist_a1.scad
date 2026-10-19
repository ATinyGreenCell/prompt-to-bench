// 10-well agarose gel comb
// Designed for FDM printing, lying flat on the XY plane.

// --- Dimensions ---
spine_l     = 70.0;    // Length of the spine (X)
spine_w     = 12.0;    // Width of the spine (Y)
plate_t     = 1.5;     // Thickness of the plate (Z)
tooth_w     = 5.0;     // Width of each tooth (X)
tooth_l     = 12.0;    // Length of each tooth (Y)
gap         = 1.5;     // Gap between teeth
num_teeth   = 10;      // Number of teeth

$fn = 64;

// --- Calculations ---
// Total width of the teeth array (from start of first tooth to end of last)
// Total X = (num_teeth * tooth_w) + ((num_teeth - 1) * gap)
total_teeth_x = (num_teeth * tooth_w) + ((num_teeth - 1) * gap);

// Offset to center the teeth array along the X axis of the spine
// The teeth array starts at (x_offset - total_teeth_x/2)
x_offset = (spine_l - total_teeth_x) / 2;

// The teeth hang from one long edge in the -Y direction.
// Spine Y range: [-spine_w/2, spine_w/2]
// Teeth Y range: [-spine_w/2 - tooth_l, -spine_w/2]

union() {
    // Main Body: The spine
    // Centered on X and Y, sitting on Z=0
    translate([-spine_l/2, -spine_w/2, 0])
        cube([spine_l, spine_w, plate_t]);
    
    // The Teeth
    for (i = [0 : num_teeth - 1]) {
        // Calculate X position for this tooth
        // We center the whole array by starting at the calculated x_offset
        // and subtracting half the tooth width to align the edge.
        tx = (x_offset - total_teeth_x/2) + (i * (tooth_w + gap));
        
        // Translate to position: 
        // X: centered on the spine
        // Y: attached to the edge (spine_w/2) and extending in -Y direction
        // Note: The prompt says "hang from one long edge... in the -Y direction"
        // If the edge is at +spine_w/2, hanging in -Y means Y goes from spine_w/2 down to spine_w/2 - tooth_l.
        // However, standard comb design usually extends away from the spine.
        // To "hang in the -Y direction" from the edge at +spine_w/2:
        // Y range: [spine_w/2 - tooth_l, spine_w/2]
        
        translate([tx, spine_w/2 - tooth_l, 0])
            cube([tooth_w, tooth_l, plate_t]);
    }
}