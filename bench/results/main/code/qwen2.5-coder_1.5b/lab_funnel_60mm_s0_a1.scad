// Define dimensions
$fn = 64; // For curved shapes

// Spout
spout_diameter = 10;
spout_height = 20;
spout_bore = spout_diameter - 0.01;

// Cone
cone_inner_diameter = 10;
cone_outer_diameter = 60;
cone_height = 30; // From z=20 to z=50

// Wall thickness
wall_thickness = 1.6;

// Create the spout
spout = cylinder(d=spout_diameter, h=spout_height, center=true);

// Create the cone
cone = rotate_extrude(angle=90, center=true) {
    cylinder(d=cone_inner_diameter, h=cone_height, center=true);
    translate([0, 0, cone_height]) {
        cylinder(d=cone_outer_diameter, h=wall_thickness, center=true);
    }
};

// Create the funnel
funnel = difference() {
    spout;
    cone;
};

// Display the result
translate([0, 0, -spout_height]) {
    hull() {
        funnel;
        translate([0, 0, wall_thickness]) {
            cylinder(d=wall_thickness, h=spout_height, center=true);
        }
    }
};