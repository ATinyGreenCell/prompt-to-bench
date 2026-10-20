// Dimensions for PCR tube adapter sleeve
// Collar diameter: 13 mm, Collar thickness: 1.5 mm
// Sleeve body outer diameter: 10.8 mm, Total height: 21.5 mm
// Bore diameter: 6.2 mm

$fn = 64;

// Define variables
collar_diameter = 13;
collar_thickness = 1.5;
sleeve_outer_diameter = 10.8;
total_height = 21.5;
bore_diameter = 6.2;

// Create the collar
collar = union() {
    // Outer cylinder of the collar
    cylinder(h = collar_thickness, r = collar_diameter / 2, $fn = 64);
    // Inner bore through the collar
    cylinder(h = collar_thickness, r = bore_diameter / 2, $fn = 64, center = true);
};

// Create the sleeve body
sleeve_body = union() {
    // Outer cylinder of the sleeve body
    cylinder(h = total_height - collar_thickness, r = sleeve_outer_diameter / 2, $fn = 64);
    // Inner bore of the sleeve body
    cylinder(h = total_height - collar_thickness, r = bore_diameter / 2, $fn = 64, center = true);
};

// Combine collar and sleeve body
adapter_sleeve = union() {
    // Collar at z = 0 to 1.5
    translate([0, 0, 0]) collar;
    // Sleeve body on top of the collar
    translate([0, 0, collar_thickness]) sleeve_body;
};

// Final output
adapter_sleeve;