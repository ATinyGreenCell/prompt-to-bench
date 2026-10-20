// Pestle for grinding tissue in a 1.5 mL microcentrifuge tube
// Units: mm

// Dimensions
handle_diameter = 8;
handle_height = 45;
cone_start_z = 45;
cone_end_z = 62;
cone_bottom_diameter = 8;
cone_top_diameter = 3;
tip_diameter = 3;
tip_z = 62;
groove_width = 2;
groove_depth = 1;
groove_z_positions = [10, 15, 20, 25];

// Derived Dimensions
handle_radius = handle_diameter / 2;
cone_start_radius = cone_bottom_diameter / 2;
cone_end_radius = cone_top_diameter / 2;
tip_radius = tip_diameter / 2;

$fn = 64;

module pestle() {
    union() {
        // 1. Cylindrical Handle
        cylinder(h = handle_height, r = handle_radius, center = false);

        // 2. Tapered Cone
        // Using linear interpolation for the cone radius
        translate([0, 0, cone_start_z])
        cylinder(h = cone_end_z - cone_start_z, 
                 r1 = cone_start_radius, 
                 r2 = cone_end_radius, 
                 center = false);

        // 3. Rounded Tip
        translate([0, 0, tip_z])
        sphere(r = tip_radius);
    }
}

module grooves() {
    for (z = groove_z_positions) {
        // Create a slot shape
        // We cut a rectangular prism that is wider than the handle
        // and extrude it to create a groove
        translate([0, 0, z])
        cube([handle_diameter + 2, handle_diameter + 2, groove_width], center = true);
    }
}

difference() {
    pestle();
    grooves();
}