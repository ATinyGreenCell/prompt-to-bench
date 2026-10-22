// Dimensions for 10-well agarose gel comb
$fn = 64;

// Spine (back bar) dimensions
spine_length = 70;   // X direction
spine_width = 12;   // Y direction
spine_thickness = 1.5; // Z direction (height)

// Tooth dimensions
tooth_width = 5.0;    // X direction (width of each tooth)
tooth_length = 12;     // Y direction (length of each tooth, extending from spine)
tooth_gap = 1.5;       // Gap between adjacent teeth (in Y direction)

// Number of teeth
num_teeth = 10;

// Total width of all teeth and gaps
total_tooth_width = num_teeth * tooth_width;
total_gap_width = (num_teeth - 1) * tooth_gap;
total_y_span = total_tooth_width + total_gap_width;

// Center the tooth row on the spine in X direction
// Spine is 70 mm long in X, so we center the tooth row (12 mm in Y) on the spine's X-axis
// The tooth row extends in -Y direction from the spine's edge

// Calculate offset to center the tooth row in X
tooth_row_offset_x = (spine_length - tooth_width) / 2;

// Position of first tooth's X start (from spine's edge)
tooth_start_x = tooth_row_offset_x;

// Build the comb: start with the spine
module comb() {
    // Spine (back bar)
    translate([0, 0, 0])
        cube([spine_length, spine_width, spine_thickness], center = true);

    // Add teeth using a loop
    for (i = [0 : num_teeth - 1]) {
        // Calculate Y position of this tooth
        // Start from the spine's -Y edge (spine_width/2) and go further in -Y
        // The first tooth starts at spine_width/2 + tooth_gap/2 (to account for gap spacing)
        // But we'll use cumulative gaps to position each tooth
        tooth_y_offset = spine_width / 2 + (tooth_length + tooth_gap) * i + tooth_gap / 2;

        // Adjust Y to place tooth in -Y direction from spine
        // The tooth is centered in X over the spine
        tooth_x_center = spine_length / 2;

        // Position of this tooth's center in X
        tooth_x_start = tooth_x_center - tooth_width / 2;

        // Translate to the correct position
        translate([tooth_x_start, -tooth_y_offset, 0])
            cube([tooth_width, tooth_length, spine_thickness], center = true);
    }
}

// Render the comb
comb();