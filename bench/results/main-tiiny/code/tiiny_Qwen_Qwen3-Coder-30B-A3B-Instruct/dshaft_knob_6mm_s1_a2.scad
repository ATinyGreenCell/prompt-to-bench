// Hotplate stirrer knob replacement
// Dimensions in millimeters

// Main knob dimensions
knob_diameter = 30;
knob_height = 15;

// D-shaped bore dimensions
d_bore_diameter = 6.2;
d_bore_flat_width = 4.7;
d_bore_depth = 12;

// Grip grooves
grip_groove_diameter = 2;
grip_groove_count = 18;

// Pointer groove
pointer_width = 1.5;
pointer_depth = 1;

// Calculate derived values
knob_radius = knob_diameter / 2;
d_bore_radius = d_bore_diameter / 2;
grip_groove_radius = grip_groove_diameter / 2;

module d_bore() {
    // Create D-shaped bore
    translate([0, 0, -0.01]) 
    union() {
        cylinder(h = d_bore_depth + 0.02, r = d_bore_radius, $fn = 64);
        translate([0, -d_bore_radius, 0]) 
        cube([d_bore_radius, 2*d_bore_radius, d_bore_depth + 0.02]);
    }
}

module grip_grooves() {
    for (i = [0 : grip_groove_count - 1]) {
        angle = i * 360 / grip_groove_count;
        translate([knob_radius, 0, 0]) 
        rotate([0, 0, angle]) 
        translate([knob_radius - grip_groove_radius, 0, 0]) 
        cylinder(h = knob_height + 0.02, r = grip_groove_radius, $fn = 64);
    }
}

module pointer_groove() {
    // Create pointer groove from center to outer edge
    translate([0, 0, -0.01]) 
    union() {
        // Main groove
        translate([0, 0, 0]) 
        cylinder(h = pointer_depth + 0.02, r = pointer_width / 2, $fn = 64);
        // Extend to outer edge
        translate([knob_radius - pointer_width / 2, 0, 0]) 
        cube([pointer_width, 2 * knob_radius, pointer_depth + 0.02]);
    }
}

// Main knob
difference() {
    cylinder(h = knob_height, r = knob_radius, $fn = 64);
    
    // D-shaped bore
    d_bore();
    
    // Grip grooves
    grip_grooves();
    
    // Pointer groove
    translate([0, 0, knob_height - pointer_depth]) 
    pointer_groove();
}