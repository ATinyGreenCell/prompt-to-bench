// 10-well comb for agarose gel casting
// Print orientation: lying flat on XY plane (Z = 0), builds upward (+Z)

// Dimensions
thickness = 1.5;        // Total thickness (Z)
spine_length = 70;      // Spine length (X)
spine_width = 12;       // Spine width (Y)
num_wells = 10;         // Number of teeth/wells
tooth_width = 5.0;      // Width of each tooth (X)
tooth_length = 12;      // Length of each tooth (Y)
gap_width = 1.5;        // Gap between neighbouring teeth (X)

// Calculations
total_tooth_and_gap_width = num_wells * tooth_width + (num_wells - 1) * gap_width;
tooth_row_start_x = (spine_length - total_tooth_and_gap_width) / 2;

// Build the comb
module comb() {
    // Spine (base plate) - positioned at Y=0 to Y=spine_width
    cube([spine_length, spine_width, thickness]);
    
    // Teeth - extend from the +Y edge of the spine in the -Y direction
    for (i = [0 : num_wells - 1]) {
        // Calculate X position of each tooth, centered on spine
        tooth_x = tooth_row_start_x + i * (tooth_width + gap_width);
        
        // Position tooth: X as calculated, Y from spine_width to spine_width - tooth_length
        translate([tooth_x, spine_width, 0])
            cube([tooth_width, -tooth_length, thickness]);
    }
}

// Build the comb
comb();