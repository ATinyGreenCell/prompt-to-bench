// 10-well comb for casting agarose gels
// Print orientation: lying flat on XY plane, z=0

// Overall plate thickness (Z)
plate_thickness = 1.5;

// Spine (back bar) dimensions
spine_length = 70;    // X
spine_width = 12;     // Y

// Tooth dimensions
tooth_width = 5.0;    // X
tooth_length = 12;    // Y (extends in -Y from spine edge)

// Gap between teeth
gap_width = 1.5;

// Number of teeth
num_teeth = 10;

// Calculate total width of teeth + gaps
total_tooth_width = num_teeth * tooth_width;
total_gap_width = (num_teeth - 1) * gap_width;
total_pattern_width = total_tooth_width + total_gap_width;

// Center the pattern on the spine
offset_x = (spine_length - total_pattern_width) / 2;

// Spine edge where teeth attach (at y = 0, teeth extend in -Y)
spine_y_start = 0;

// Build the comb
difference() {
    // Main spine plate
    union() {
        // Spine base
        translate([0, 0, 0])
            cube([spine_length, spine_width, plate_thickness], center = false);
        
        // Teeth extending in -Y direction
        for (i = [0 : num_teeth - 1]) {
            tooth_x = offset_x + i * (tooth_width + gap_width);
            translate([tooth_x, -tooth_length, 0])
                cube([tooth_width, tooth_length, plate_thickness], center = false);
        }
    }
    
    // No cutting needed - this is a solid comb
}