// Dimensions
rod_diameter = 12.7;
rod_wall = 3;
tubing_diameter = 6;
tubing_wall = 2;
opening_width = 10;
bridge_width = 6;

// Calculated dimensions
rod_outer_radius = rod_diameter / 2 + rod_wall;
rod_inner_radius = rod_diameter / 2 - rod_wall;
tubing_outer_radius = tubing_diameter / 2 + tubing_wall;
tubing_inner_radius = tubing_diameter / 2 - tubing_wall;

// Rod ring with opening
rod_ring = difference() {
    cylinder(h=10, r=rod_outer_radius);
    cylinder(h=10, r=rod_inner_radius);
    translate([-opening_width/2, 0, 0]) cube([opening_width, 10, 10]);
};

// Tubing ring with opening
tubing_ring = difference() {
    translate([15, 0, 0]) cylinder(h=10, r=tubing_outer_radius);
    translate([15, 0, 0]) cylinder(h=10, r=tubing_inner_radius);
    translate([15 + opening_width/2, 0, 0]) cube([opening_width, 10, 10]);
};

// Solid bridge
bridge = difference() {
    cube([bridge_width, 10, 10]);
    cylinder(h=10, r=tubing_outer_radius);
    cylinder(h=10, r=tubing_inner_radius);
    translate([-tubing_outer_radius, 0, 0]) cylinder(h=10, r=tubing_outer_radius);
    translate([-tubing_outer_radius, 0, 0]) cylinder(h=10, r=tubing_inner_radius);
};

// Final model
union() {
    rod_ring;
    tubing_ring;
    bridge;
};