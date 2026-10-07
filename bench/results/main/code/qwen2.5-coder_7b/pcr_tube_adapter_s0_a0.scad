// Dimensions
collar_diameter = 13;
collar_thickness = 1.5;
sleeve_outer_diameter = 10.8;
bore_diameter = 6.2;
total_height = 21.5;

// Collar
collar = cylinder(d = collar_diameter, h = collar_thickness);

// Sleeve body
sleeve_body = cylinder(d_out = sleeve_outer_diameter, d_in = bore_diameter, h = total_height - collar_thickness);

// Bore
bore = cylinder(d = bore_diameter, h = total_height);

// Adapter sleeve
adapter_sleeve = difference() {
    union() {
        collar;
        translate([0, 0, collar_thickness]) sleeve_body;
    }
    bore;
}

// Print orientation: upside down
translate([0, 0, -total_height]) adapter_sleeve;