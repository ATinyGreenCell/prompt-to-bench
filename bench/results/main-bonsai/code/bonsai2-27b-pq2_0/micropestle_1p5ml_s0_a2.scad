$fn = 64;

handle_diameter = 8;
handle_height   = 45;
cone_bottom_diameter = 8;
cone_top_diameter    = 3;
cone_bottom_z        = 45;
cone_top_z           = 62;
tip_diameter = 3;
tip_center_z = 62;
groove_width = 2;
groove_depth = 1;
groove_centers_z = [10, 15, 20, 25];

difference() {
    union() {
        cylinder(h = handle_height, d = handle_diameter, center = false);
        translate([0, 0, cone_bottom_z])
            cylinder(h = cone_top_z - cone_bottom_z, d1 = cone_bottom_diameter, d2 = cone_top_diameter, center = false);
        translate([0, 0, tip_center_z])
            sphere(d = tip_diameter);
    }
    for (z = groove_centers_z) {
        translate([0, 0, z - groove_width / 2])
            difference() {
                cylinder(h = groove_width + 1, d = handle_diameter + 1, center = false);
                cylinder(h = groove_width + 1, d = handle_diameter - 2 * groove_depth, center = false);
            }
    }
}