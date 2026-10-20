$fn = 64; // resolution for cylinders and circles

// Dimensions (mm)
thickness = 1.5;          // Z
spine_length = 70;        // X
spine_width = 12;         // Y
tooth_width = 5;          // X
tooth_length = 12;        // Y
gap = 1.5;                // Y
num_teeth = 10;           // number of teeth

// Derived dimensions
total_teeth_width = num_teeth*tooth_width + (num_teeth-1)*gap; // 63.5 mm
spine_end_offset = (spine_length - total_teeth_width) / 2;      // 3.25 mm
tooth_start_x = -spine_length/2 + spine_end_offset;             // left edge of first tooth
tooth_start_y = -spine_width/2 - tooth_length;                    // teeth hang below the spine

// Build comb
union() {
    // Spine
    translate([ -spine_length/2, -spine_width/2, 0]) cube([spine_length, spine_width, thickness]);

    // Teeth
    for (i = [0:num_teeth-1]) {
        x = tooth_start_x + i*(tooth_width + gap);
        translate([x, tooth_start_y, 0]) cube([tooth_width, tooth_length, thickness]);
    }
}