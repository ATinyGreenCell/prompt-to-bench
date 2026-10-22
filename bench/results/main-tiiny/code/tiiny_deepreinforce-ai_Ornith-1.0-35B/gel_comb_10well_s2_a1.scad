// 10-well comb for casting agarose gels
// Print orientation: lying flat on XY plane, z=0

// Overall plate thickness
plate_thickness = 1.5;

// Spine (back bar) dimensions
spine_length = 70;    // X direction
spine_width = 12;     // Y direction

// Tooth dimensions
tooth_width = 5.0;    // X direction
tooth_length = 12;    // Y direction (extends in -Y from spine)

// Gap between teeth
gap_width = 1.5;

// Number of teeth
num_teeth = 10;

// Calculate total width of teeth + gaps
total_tooth_width = num_teeth * tooth_width;
total_gap_width = (num_teeth - 1) * gap_width;
total_pattern_width = total_tooth_width + total_gap_width;

// Center offset to align pattern with spine center
pattern_offset_x = (spine_length - total_pattern_width) / 2;

// Build the comb as a single solid
union() {
    // Spine (back bar) - positioned at y=0 to y=spine_width
    translate([0, 0, 0])
        cube([spine_length, spine_width, plate_thickness]);
    
    // Teeth - extend from y=0 in -Y direction
    for (i = [0 : num_teeth - 1]) {
        x_pos = pattern_offset_x + i * (tooth_width + gap_width);
        translate([x_pos, -tooth_length, 0])
            cube([tooth_width, tooth_length, plate_thickness]);
    }
}