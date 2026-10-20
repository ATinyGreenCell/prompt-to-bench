// Adapter sleeve for 0.2 mL PCR tube in 1.5 mL rack hole
// Print orientation: upside down (collar on bed)

$fn = 64;

// Dimensions
collar_diameter = 13;       // mm
collar_thickness = 1.5;     // mm (z = 0 to 1.5)
sleeve_outer_diameter = 10.8; // mm
sleeve_height = 20.0;       // mm (rises from z=1.5 to z=21.5)
bore_diameter = 6.2;        // mm

// Calculate radii
collar_radius = collar_diameter / 2;
sleeve_outer_radius = sleeve_outer_diameter / 2;
bore_radius = bore_diameter / 2;
total_height = collar_thickness + sleeve_height;

// Build the adapter
module adapter_sleeve() {
    // Base solid (collar + sleeve body)
    base = union() {
        // Collar (bottom part) - from z=0 to z=1.5
        translate([0, 0, 0]) {
            cylinder(h = collar_thickness, r = collar_radius, center = false);
        }
        
        // Sleeve body (upper part) - from z=1.5 to z=21.5
        translate([0, 0, collar_thickness]) {
            cylinder(h = sleeve_height, r = sleeve_outer_radius, center = false);
        }
    };
    
    // Bore (through-hole) - extends 0.01 mm past both ends
    bore = translate([0, 0, -0.01]) {
        cylinder(h = total_height + 0.02, r = bore_radius, center = false);
    };
    
    // Subtract bore from base
    difference() {
        base;
        bore;
    }
}

// Render the adapter
adapter_sleeve();