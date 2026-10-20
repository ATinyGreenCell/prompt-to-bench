// Adapter sleeve for 0.2 mL PCR tube in 1.5 mL rack hole
// Print orientation: upside down (collar on bed, sleeve body upward)

// Dimensions
collar_diameter = 13;       // mm, outer diameter of collar
collar_thickness = 1.5;     // mm, height of collar
sleeve_od = 10.8;           // mm, outer diameter of sleeve body
sleeve_height = 21.5;       // mm, height of sleeve body (from collar top to top of sleeve)
bore_diameter = 6.2;        // mm, inner bore diameter
wall_thickness = (collar_diameter - sleeve_od) / 2; // mm, wall thickness at collar

// Resolution
$fn = 64;

// Collar (bottom part)
collar_height = collar_thickness;
collar_radius = collar_diameter / 2;
sleeve_radius = sleeve_od / 2;
bore_radius = bore_diameter / 2;

// Build collar
module collar_part() {
    translate([0, 0, 0]) {
        cylinder(h = collar_height, r = collar_radius, center = false);
        // Subtract bore
        translate([0, 0, -0.1]) {
            cylinder(h = collar_height + 0.2, r = bore_radius, center = false);
        }
    }
}

// Build sleeve body (on top of collar)
module sleeve_body() {
    translate([0, 0, collar_height]) {
        cylinder(h = sleeve_height, r = sleeve_radius, center = false);
        // Subtract bore
        translate([0, 0, -0.1]) {
            cylinder(h = sleeve_height + 0.2, r = bore_radius, center = false);
        }
    }
}

// Combine parts
collar_part();
sleeve_body();