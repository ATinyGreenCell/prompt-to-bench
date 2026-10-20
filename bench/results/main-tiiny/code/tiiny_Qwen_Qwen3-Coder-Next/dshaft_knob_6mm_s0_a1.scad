// Replacement knob for hotplate stirrer with 6 mm D-shaft
// Dimensions from user specification

$fn = 64;

// Main knob dimensions
knob_diameter = 30;
knob_height = 15;

// D-shaft bore dimensions
d_shaft_diameter = 6.2;
d_shaft_radius = d_shaft_diameter / 2;
d_shaft_flat_to_opposite = 4.7;
d_shaft_depth = 12;

// Calculate position of the flat cut
// Distance from center to flat = d_shaft_radius - d_shaft_flat_to_opposite
// Since d_shaft_flat_to_opposite > d_shaft_radius, this is negative (flat is on other side of center)
flat_distance_from_center = d_shaft_radius - d_shaft_flat_to_opposite;  // = 3.1 - 4.7 = -1.6

// Grip groove dimensions
groove_diameter = 2;
num_grooves = 18;

// Pointer groove dimensions
pointer_width = 1.5;
pointer_depth = 1;

module knob() {
    // Main cylinder
    cylinder(h = knob_height, r = knob_diameter / 2, center = false);
}

module d_shaft_bore() {
    // First create the full cylinder for the bore
    translate([0, 0, -0.01]) {
        cylinder(h = d_shaft_depth + 0.01, r = d_shaft_radius, center = false);
    }
    
    // Calculate chord width at the flat position
    // The flat is at y = flat_distance_from_center (negative value)
    // Width = 2 * sqrt(r^2 - y^2)
    chord_width = 2 * sqrt(d_shaft_radius * d_shaft_radius - flat_distance_from_center * flat_distance_from_center);
    
    // Cut the flat side: subtract a rectangular prism
    // The flat is at y = flat_distance_from_center, and extends to y = -d_shaft_radius (bottom of circle)
    // Since flat_distance_from_center is negative, this means the cut is from the bottom up to the flat position
    translate([0, flat_distance_from_center, -0.01]) {
        cube([chord_width + 0.1, d_shaft_radius - abs(flat_distance_from_center) + 0.01, d_shaft_depth + 0.02], center = false);
    }
}

module grip_grooves() {