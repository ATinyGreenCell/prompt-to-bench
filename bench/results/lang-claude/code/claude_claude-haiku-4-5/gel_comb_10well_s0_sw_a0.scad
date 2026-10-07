// Agarose gel comb for 10-lane gel electrophoresis
// Printed lying flat on XY plane, builds upward in Z

// Dimensions (mm)
spine_length_x = 70;      // Length of spine/backbone in X
spine_width_y = 12;       // Width of spine/backbone in Y
thickness_z = 1.5;        // Thickness of entire comb in Z

tooth_width_x = 5.0;      // Width of each tooth in X
tooth_length_y = 12;      // Length of each tooth in Y (protrusion)
tooth_gap = 1.5;          // Gap between adjacent teeth
num_teeth = 10;           // Number of teeth

$fn = 64;

// Calculate total span of teeth
teeth_total_span = num_teeth * tooth_width_x + (num_teeth - 1) * tooth_gap;

// Offsets to center comb at origin in XY
spine_x_min = -spine_length_x / 2;
spine_y_min = -spine_width_y / 2;

// Main spine/backbone
translate([spine_x_min, spine_y_min, 0]) {
    cube([spine_length_x, spine_width_y, thickness_z]);
}

// Ten teeth protruding in -Y direction
// Teeth are centered on spine in X
teeth_start_x = spine_x_min + (spine_length_x - teeth_total_span) / 2;

for (i = [0:num_teeth-1]) {
    tooth_x = teeth_start_x + i * (tooth_width_x + tooth_gap);
    tooth_y = spine_y_min - tooth_length_y;
    translate([tooth_x, tooth_y, 0]) {
        cube([tooth_width_x, tooth_length_y, thickness_z]);
    }
}