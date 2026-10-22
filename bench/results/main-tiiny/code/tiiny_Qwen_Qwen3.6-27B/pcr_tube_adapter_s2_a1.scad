// Adapter sleeve: 0.2 mL PCR tube to 1.5 mL rack hole
// Dimensions measured with calipers

// Collar (rests on build plate)
collar_diameter = 13;
collar_thickness = 1.5;

// Sleeve body
sleeve_outer_diameter = 10.8;
sleeve_height = 21.5; // total height from z=0 to z=21.5

// Bore (through hole)
bore_diameter = 6.2;

// Print orientation: collar on bed (z=0 to 1.5), sleeve rises to z=21.5
// Centred on origin in X and Y

$fn = 64;

difference() {
    union() {
        // Collar
        translate([0, 0, 0])
            cylinder(h = collar_thickness, r = collar_diameter / 2, center = false);

        // Sleeve body
        translate([0, 0, collar_thickness])
            cylinder(h = sleeve_height - collar_thickness, r = sleeve_outer_diameter / 2, center = false);
    }

    // Bore: extends 1 mm below z=0 and 1 mm above z=21.5 to ensure clean cut
    translate([0, 0, -1])
        cylinder(h = sleeve_height + 2, r = bore_diameter / 2, center = false);
}