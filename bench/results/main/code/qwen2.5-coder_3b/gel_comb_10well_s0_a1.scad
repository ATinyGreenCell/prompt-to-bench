// Define dimensions
$fn = 64; // Number of facets for curved surfaces

// Dimensions of the comb
comb_width = 70;
comb_height = 12;
tooth_width = 5;
tooth_length = 12;
gap_width = 1.5;

// Calculate total width and height of the teeth row
total_teeth_width = tooth_width * 10 + gap_width * (9); // 9 gaps between 10 teeth

// Positioning the comb on the bed
comb_position_x = -comb_width / 2;
comb_position_y = -comb_height / 2;

// Thickness of the comb
comb_thickness = 1.5; // Corrected thickness

// Create the comb
difference() {
    // Base of the comb
    cube([comb_width, comb_height, comb_thickness]);

    // Teeth row
    for (i=[0:9]) {
        translate([comb_position_x + i * (tooth_width + gap_width), comb_position_y - tooth_length / 2, 0]) {
            cube([tooth_width, tooth_length, comb_thickness]);
        }
    }
}