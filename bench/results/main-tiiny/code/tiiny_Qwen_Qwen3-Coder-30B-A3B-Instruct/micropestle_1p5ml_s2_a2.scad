// Define dimensions
handle_diameter = 8;
handle_height = 45;
cone_bottom_diameter = 8;
cone_top_diameter = 3;
cone_height = 17;
tip_diameter = 3;
groove_width = 2;
groove_depth = 1;
groove_z_positions = [10, 15, 20, 25];

// Create the pestle
union() {
    // Handle cylinder
    cylinder(h = handle_height, d = handle_diameter, center = false, $fn = 64);
    
    // Cone
    translate([0, 0, handle_height])
    cylinder(h = cone_height, d1 = cone_bottom_diameter, d2 = cone_top_diameter, center = false, $fn = 64);
    
    // Tip sphere
    translate([0, 0, handle_height + cone_height])
    sphere(d = tip_diameter, $fn = 64);
    
    // Grooves
    for (z_pos = groove_z_positions) {
        translate([0, 0, z_pos])
        cylinder(h = groove_width, d = handle_diameter - groove_depth, center = false, $fn = 64);
    }
}