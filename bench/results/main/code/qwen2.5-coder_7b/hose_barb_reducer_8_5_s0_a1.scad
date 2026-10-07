// Dimensions in millimeters
$fn = 64;

d8_inner = 8;
d8_outer_bottom = 7.5;
d8_outer_top = 9.5;
barb8_height = 10;
collar_diameter = 12;
d5_inner = 5;
d5_outer_bottom = 6.5;
d5_outer_top = 5.0;
barb5_height = 8;
total_length = 41;

// Function to create a barb with linear outer diameter change
barb(d_outer_bottom, d_outer_top, height) {
    difference() {
        cylinder(h = height, r = d_outer_top / 2);
        translate([0, 0, -0.01]) cylinder(h = height + 0.02, r = d_outer_bottom / 2);
    }
}

// Function to create a barb with linear outer diameter change and step back
barb_with_step(d_outer_bottom, d_outer_top, step_d, height) {
    difference() {
        cylinder(h = height, r = d_outer_top / 2);
        translate([0, 0, -0.01]) cylinder(h = height + 0.02, r = d_outer_bottom / 2);
        translate([0, 0, height - step_d]) cylinder(h = step_d + 0.02, r = (d_outer_top + d_outer_bottom) / 4);
    }
}

// Main part
union() {
    // Barbs for 8 mm tubing
    for (z = [0:19]) {
        translate([0, 0, z * barb8_height / 20]) rotate_extrude() difference() {
            circle(r = d8_outer_top / 2);
            translate([0, 0, -0.01]) circle(r = d8_outer_bottom / 2);
        }
    }

    // Collar
    cylinder(h = collar_diameter * barb8_height / 20, r = collar_diameter / 2);

    // Barbs for 5 mm tubing
    for (z = [21:40]) {
        translate([0, 0, z * barb5_height / 20 + 20]) rotate_extrude() difference() {
            circle(r = d5_outer_top / 2);
            translate([0, 0, -0.01]) circle(r = d5_outer_bottom / 2);
        }
    }
}