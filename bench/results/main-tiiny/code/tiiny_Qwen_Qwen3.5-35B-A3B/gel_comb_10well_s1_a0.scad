// Dimensions for 10-well agarose gel comb
// Units: millimetres

// Overall plate thickness (Z direction)
thick = 1.5;

// Spine dimensions
spine_len = 70;      // Length along X
spine_wid = 12;      // Width along Y

// Tooth dimensions
tooth_wid = 5.0;     // Width along X
tooth_len = 12;      // Length along Y (hanging in -Y)

// Gap between teeth
gap_wid = 1.5;       // Gap along X

// Number of teeth
num_teeth = 10;

// Calculate total width of teeth + gaps
// Total width = num_teeth * tooth_wid + (num_teeth - 1) * gap_wid
total_tooth_width = num_teeth * tooth_wid + (num_teeth - 1) * gap_wid;

// Centering the tooth row on the spine in X
// Spine is centered at X=0, so we shift the tooth row to align with spine center
tooth_row_offset_x = (spine_wid - total_tooth_width) / 2;

// Calculate the Y position of the teeth
// Spine extends from Y = -spine_wid/2 to Y = +spine_wid/2
// Teeth hang in -Y direction from the spine edge (Y = -spine_wid/2)
// Tooth length is 12mm, so they extend from Y = -spine_wid/2 down to Y = -spine_wid/2 - 12
tooth_start_y = -spine_wid / 2;
tooth_end_y = tooth_start_y - tooth_len;

// Build the comb
module comb() {
    // 1. Create the spine (flat plate)
    // Centered at origin, lying on XY plane (Z=0 to Z=thick)
    translate([0, 0, 0])
        cube([spine_len, spine_wid, thick], center = true);

    // 2. Create the teeth
    // We use a loop to create each tooth
    for (i = [0 : num_teeth - 1]) {
        // Calculate X position for this tooth
        // The row is centered, so we start at tooth_row_offset_x
        // Each tooth is spaced by (tooth_wid + gap_wid)
        tooth_x = tooth_row_offset_x + i * (tooth_wid + gap_wid);
        
        // Create a single tooth
        translate([tooth_x, tooth_start_y, 0])
            cube([tooth_wid, tooth_len, thick], center = false);
    }
}

// Final assembly
comb();