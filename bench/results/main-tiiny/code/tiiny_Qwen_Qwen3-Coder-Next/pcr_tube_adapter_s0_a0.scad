// Adapter sleeve for 0.2 mL PCR tube in 1.5 mL rack hole
// Print orientation: upside down (collar on bed)

$fn = 64;

// Dimensions
collar_diameter = 13;       // mm
collar_thickness = 1.5;     // mm
sleeve_outer_diameter = 10.8; // mm
sleeve_height = 21.5;       // mm
bore_diameter = 6.2;        // mm

// Calculate radii
collar_radius = collar_diameter / 2;
sleeve_outer_radius = sleeve_outer_diameter / 2;
bore_radius = bore_diameter / 2;

// Total height of the adapter
total_height = collar_thickness + sleeve_height;

// Build the adapter
module adapter_sleeve() {
    // Collar (bottom part)
    translate([0, 0, 0]) {
        cylinder(h = collar_thickness, r = collar_radius, center = false);
    }
    
    // Sleeve body (upper part)
    translate([0, 0, collar_thickness]) {
        cylinder(h = sleeve_height, r = sleeve_outer_radius, center = false);
    }
    
    // Bore (through-hole)
    translate([0, 0, -0.01]) {
        cylinder(h = total_height + 0.02, r = bore_radius, center = false);
    }
}

// Render the adapter
adapter_sleeve();