$fn = 64;

// Dimensions
bore_diameter = 3;
main_body_diameter = 12;
collar_diameter = 12;
collar_height = 5;
barb8_height = 10;
barb8_bottom_diameter = 7.5;
barb8_top_diameter = 9.5;
barb5_height = 8;
barb5_bottom_diameter = 6.5;
barb5_top_diameter = 5.0;
total_height = 41;

// Helper function to create a single sawtooth barb (3D only)
module sawtooth_barb_3d(bottom_diameter, top_diameter, height, z_offset) {
    half_height = height / 2;
    
    // Create the sawtooth profile using hull for the step transition
    // First ramp: bottom to top
    hull() {
        translate([0, 0, z_offset])
            cylinder(d = bottom_diameter, h = 0.01, $fn = 64);
        translate([0, 0, z_offset + half_height])
            cylinder(d = top_diameter, h = 0.01, $fn = 64);
    }
    
    // Step back: top to bottom
    hull() {
        translate([0, 0, z_offset + half_height])
            cylinder(d = top_diameter, h = 0.01, $fn = 64);
        translate([0, 0, z_offset + height])
            cylinder(d = bottom_diameter, h = 0.01, $fn = 64);
    }
}

// Main body with bore
module main_body_with_bore() {
    // Base cylinder (from z=0 to z=20)
    difference() {
        cylinder(h = 20, d = main_body_diameter, $fn = 64);
        translate([0, 0, -0.01])
            cylinder(h = 20.02, d = bore_diameter, $fn = 64);
    }
    
    // Collar section (z=20 to z=25)
    translate([0, 0, 20])
        cylinder(h = collar_height, d = collar_diameter, $fn = 64);
    
    // Top section (z=25 to z=41)
    translate([0, 0, 25])
        cylinder(h = 16, d = main_body_diameter, $fn = 64);
}

// 8mm barbs (z=0 to z=20)
module barbs_8mm() {
    // First barb (bottom)
    translate([0, 0, 0])
        sawtooth_barb_3d(barb8_bottom_diameter, barb8_top_diameter, barb8_height, 0);
    
    // Second barb (top)
    translate([0, 0, barb8_height])
        sawtooth_barb_3d(barb8_bottom_diameter, barb8_top_diameter, barb8_height, 0);
}

// 5mm barbs (z=25 to z=41)
module barbs_5mm() {
    // First barb (bottom)
    translate([0, 0, 25])
        sawtooth_barb_3d(barb5_bottom_diameter, barb5_top_diameter, barb5_height, 0);
    
    // Second barb (top)
    translate([0, 0, 25 + barb5_height])
        sawtooth_barb_3d(barb5_bottom_diameter, barb5_top_diameter, barb5_height, 0);
}

// Combine everything with proper union
module reducer() {
    // Start with main body
    main_body_with_bore();
    
    // Add 8mm barbs
    barbs_8mm();
    
    // Add 5mm barbs
    barbs_5mm();
}

// Final part
reducer();