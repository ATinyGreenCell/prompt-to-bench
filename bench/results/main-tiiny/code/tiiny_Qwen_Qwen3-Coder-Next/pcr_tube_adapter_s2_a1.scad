// Adapter sleeve for 0.2 mL PCR tube in 1.5 mL rack hole
// Print orientation: upside down (collar on bed, sleeve rises upward)

// Dimensions
collar_diameter = 13;        // mm, outer diameter of collar
collar_thickness = 1.5;      // mm, height of collar
sleeve_outer_diameter = 10.8; // mm, outer diameter of sleeve body
sleeve_body_height = 20.0;   // mm, height of sleeve body (21.5 total - 1.5 collar = 20.0)
bore_diameter = 6.2;         // mm, inner bore diameter

// Set resolution for curves
$fn = 64;

// Collar (bottom part)
collar_radius = collar_diameter / 2;

// Sleeve body (upper part)
sleeve_radius = sleeve_outer_diameter / 2;
total_height = collar_thickness + sleeve_body_height;

// Bore (full height)
bore_radius = bore_diameter / 2;

// Build adapter sleeve
module adapter_sleeve() {
    // Collar base (from z=0 to z=collar_thickness)
    translate([0, 0, 0]) {
        cylinder(h = collar_thickness, r = collar_radius, center = false);
    }
    
    // Sleeve body (from z=collar_thickness to z=total_height)
    translate([0, 0, collar_thickness]) {
        cylinder(h = sleeve_body_height, r = sleeve_radius, center = false);
    }
    
    // Bore (subtract cylinder from center, extending past both ends)
    translate([0, 0, -0.01]) {
        cylinder(h = total_height + 0.02, r = bore_radius, center = false);
    }
}

// Render the adapter sleeve
adapter_sleeve();