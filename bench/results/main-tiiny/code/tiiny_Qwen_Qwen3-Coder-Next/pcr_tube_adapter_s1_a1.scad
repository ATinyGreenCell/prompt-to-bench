// Adapter sleeve for 0.2 mL PCR tube in 1.5 mL rack hole
// Print orientation: upside down (collar on bed, sleeve body upward)

// Dimensions
collar_diameter = 13;       // mm, outer diameter of collar
collar_thickness = 1.5;     // mm, height of collar
sleeve_od = 10.8;           // mm, outer diameter of sleeve body
sleeve_height = 21.5;       // mm, height of sleeve body (from collar top to top of sleeve)
bore_diameter = 6.2;        // mm, inner bore diameter

// Resolution
$fn = 64;

// Collar (bottom part) - from z=0 to z=1.5
module collar_part() {
    collar_radius = collar_diameter / 2;
    bore_radius = bore_diameter / 2;
    
    // Main collar cylinder
    cylinder(h = collar_thickness, r = collar_radius, center = false);
    
    // Subtract bore (extend 0.01 mm below and above collar)
    translate([0, 0, -0.01]) {
        cylinder(h = collar_thickness + 0.02, r = bore_radius, center = false);
    }
}

// Sleeve body (on top of collar) - from z=1.5 to z=23.0
module sleeve_body() {
    sleeve_radius = sleeve_od / 2;
    bore_radius = bore_diameter / 2;
    
    // Main sleeve cylinder
    translate([0, 0, collar_thickness]) {
        cylinder(h = sleeve_height, r = sleeve_radius, center = false);
    }
    
    // Subtract bore (extend 0.01 mm below and above sleeve body)
    translate([0, 0, collar_thickness - 0.01]) {
        cylinder(h = sleeve_height + 0.02, r = bore_radius, center = false);
    }
}

// Build the complete adapter
collar_part();
sleeve_body();