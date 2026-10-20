// Parameters (mm)
collar_diameter = 13;          // outer diameter of the bottom collar
collar_thickness = 1.5;        // thickness of the collar (z = 0 → 1.5)
sleeve_outer_diameter = 10.8; // outer diameter of the sleeve body
sleeve_height = 20.0;          // height of the sleeve body (z = 1.5 → 21.5)
total_height = collar_thickness + sleeve_height; // overall part height = 21.5 mm
bore_diameter = 6.2;           // diameter of the straight bore
clearance = 0.01;              // extra length beyond each face for clean cuts

// Set resolution for curved features
$fn = 128;

// Collar (cylinder, sits on the bed)
module collar() {
    cylinder(d = collar_diameter, h = collar_thickness, center = false);
}

// Sleeve body (cylinder, starts at collar top)
module sleeve_body() {
    translate([0, 0, collar_thickness])
        cylinder(d = sleeve_outer_diameter, h = sleeve_height, center = false);
}

// Complete part before bore
module raw_part() {
    union() {
        collar();
        sleeve_body();
    }
}

// Bore that cuts through the whole part
module bore() {
    // Height extends clearance beyond both ends
    bore_height = total_height + 2*clearance;
    translate([0, 0, -clearance])
        cylinder(d = bore_diameter, h = bore_height, center = false);
}

// Final printable part
difference() {
    raw_part();
    bore();
}