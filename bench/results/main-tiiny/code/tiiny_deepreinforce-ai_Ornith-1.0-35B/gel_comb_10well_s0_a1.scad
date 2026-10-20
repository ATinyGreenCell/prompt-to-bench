// 10-well agarose gel comb
// Print orientation: lying flat on XY plane, z=0

// Overall plate dimensions
plate_thickness = 1.5;    // Z thickness (mm)
spine_length = 70;         // X length (mm)
spine_width = 12;          // Y width (mm)

// Tooth dimensions
tooth_width = 5.0;         // X width (mm)
tooth_length = 12;         // Y length (mm) (extends in -Y from spine edge)

// Gap between teeth
gap_width = 1.5;           // X gap (mm)

// Number of teeth
num_teeth = 10;

// Calculate total width of teeth + gaps
total_tooth_width = num_teeth * tooth_width;
total_gap_width = (num_teeth - 1) * gap_width;
total_tooth_group_width = total_tooth_width + total_gap_width;

// Center the tooth group on the spine in X
tooth_group_offset_x = (spine_length - total_tooth_group_width) / 2;

// Position of first tooth in X (relative to origin)
first_tooth_x = tooth_group_offset_x;

// Spine extends in +Y from center, teeth hang in -Y
// Spine Y range: [-spine_width/2, spine_width/2]
// Teeth start at spine bottom edge: y = -spine_width/2
// Teeth extend to: y = -spine_width/2 - tooth_length

$fn = 64;

// Main spine plate
union() {
    // Spine body - centered at origin
    translate([0, 0, 0])
        cube([spine_length, spine_width, plate_thickness], center = false);
    
    // Add teeth
    for (i = [0 : num_teeth - 1]) {
        tooth_x = first_tooth_x + i * (tooth_width + gap_width);
        translate([tooth_x, -spine_width/2 - tooth_length, 0])
            cube([tooth_width, tooth_length, plate_thickness], center = false);
    }
}