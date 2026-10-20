$fn = 64;

// Dimensions
bore_diameter = 3;
collar_diameter = 12;
collar_height = 5;
barb8_height = 10;
barb8_bottom_diameter = 7.5;
barb8_top_diameter = 9.5;
barb5_height = 8;
barb5_bottom_diameter = 6.5;
barb5_top_diameter = 5.0;
total_height = 41;

// Helper function to create a single sawtooth barb
module sawtooth_barb(bottom_diameter, top_diameter, height, z_offset) {
    // Calculate slope for linear increase
    slope = (top_diameter - bottom_diameter) / height;
    
    // Create the increasing part (bottom to top)
    translate([0, 0, z_offset])
        linear_extrude(height = height, scale = (top_diameter/bottom_diameter))
            circle(d = bottom_diameter, $fn = 64);
    
    // Create the decreasing part (top back to bottom diameter)
    // We need to subtract the decreasing part from the increasing part to get the sawtooth step
    // Instead, we'll build it as two parts: increasing then decreasing with a step
    // But simpler: use hull for the step transition
    hull() {
        translate([0, 0, z_offset + height])
            circle(d = top_diameter, $fn = 64);
        translate([0, 0, z_offset + height + 0.01])
            circle(d = bottom_diameter, $fn = 64);
    }
}

// Main body: cylinder with bore
module main_body() {
    // Base cylinder (from z=0 to z=20)
    difference() {
        cylinder(h = 20, d = 12, $fn = 64);
        translate([0, 0, -0.01])
            cylinder(h = 20.02, d = bore_diameter, $fn = 64);
    }
    
    // Collar section (z=20 to z=25)
    translate([0, 0, 20])
        cylinder(h = collar_height, d = collar_diameter, $fn = 64);
    
    // Top section (z=25 to z=41)
    translate([0, 0, 25])
        cylinder(h = 16, d = 12, $fn = 64);
}

// 8mm barbs (z=0 to z=20)
module barbs_8mm() {
    // First barb (bottom)
    translate([0, 0, 0])
        sawtooth_barb(barb8_bottom_diameter, barb8_top_diameter, barb8_height, 0);
    
    // Second barb (top)
    translate([0, 0, barb8_height])
        sawtooth_barb(barb8_bottom_diameter, barb8_top_diameter, barb8_height, 0);
}

// 5mm barbs (z=25 to z=41)
module barbs_5mm() {
    // First barb (bottom)
    translate([0, 0, 25])
        sawtooth_barb(barb5_bottom_diameter, barb5_top_diameter, barb5_height, 0);
    
    // Second barb (top)
    translate([0, 0, 25 + barb5_height])
        sawtooth_barb(barb5_bottom_diameter, barb5_top_diameter, barb5_height, 0);
}

// Combine everything
module reducer() {
    // Create main body with bore
    main_body();
    
    // Add 8mm barbs
    barbs_8mm();
    
    // Add 5mm barbs
    barbs_5mm();
}

// Final part
reducer();