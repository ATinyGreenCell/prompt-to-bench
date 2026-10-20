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
total_tooth_width = num_wells * tooth_width;
total_gap_width = (num_wells - 1) * gap_width;
total_tooth_and_gap_width = total_tooth_width + total_gap_width;
spine_center_x = spine_length / 2;
tooth_row_start_x = spine_center_x - total_tooth_and_gap_width / 2;

// Comb construction
module comb() {
    // Spine (base plate)
    translate([0, (spine_width - thickness) / 2, 0])
        cube([spine_length, thickness, thickness]);
    
    // Teeth (wells)
    for (i = [0 : num_wells - 1]) {
        // Calculate X position of each tooth
        tooth_x = tooth_row_start_x + i * (tooth_width + gap_width);
        
        // Position tooth: X from spine center, Y extends in -Y direction from spine edge
        // Spine edge is at Y = spine_width/2 + thickness/2 (outer edge of spine)
        // Tooth extends from spine edge in -Y direction for tooth_length
        translate([tooth_x, spine_width/2 + thickness/2 - tooth_length, 0])
            cube([tooth_width, tooth_length, thickness]);
    }
}

// Build the comb
comb();