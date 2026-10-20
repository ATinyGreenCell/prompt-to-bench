// Dimensions for 10-well agarose gel comb
$fn = 64;

// Spine (back bar)
spine_length = 70;   // X direction
spine_width = 12;      // Y direction
spine_thickness = 1.5; // Z direction

// Teeth
tooth_width = 5.0;     // X direction (width of each tooth)
tooth_length = 12;       // Y direction (length of each tooth)
tooth_gap = 1.5;       // Gap between adjacent teeth
num_teeth = 10;

// Calculate total tooth array width (including gaps)
total_teeth_width = num_teeth * tooth_width + (num_teeth - 1) * tooth_gap;

// Center teeth on spine in X direction
offset_x = (spine_length - total_teeth_width) / 2;

// Define the comb as a single solid body
module comb() {
    // Start with the spine
    translate([0, 0, 0])
        cube([spine_length, spine_width, spine_thickness], center = true);

    // Add teeth in a loop, positioned along the -Y edge of the spine
    for (i = [0 : num_teeth - 1]) {
        // Calculate X position of this tooth (centered on spine)
        tooth_x = -spine_length / 2 + offset_x + i * (tooth_width + tooth_gap) + tooth_width / 2;

        // Position tooth at the -Y edge of the spine (Y = -spine_width/2)
        // Each tooth extends from Y = -spine_width/2 to Y = -spine_width/2 - tooth_length
        translate([tooth_x, -spine_width/2 - tooth_length/2, 0])
            cube([tooth_width, tooth_length, spine_thickness], center = true);
    }
}

// Assemble the full comb
comb();