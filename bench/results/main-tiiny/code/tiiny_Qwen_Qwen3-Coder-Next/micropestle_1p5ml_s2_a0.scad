$fn = 64;

// Dimensions
handle_diameter = 8;
handle_height = 45;
cone_top_diameter = 3;
cone_height = 17; // 62 - 45
sphere_diameter = 3;
groove_width = 2;
groove_depth = 1;
groove_centers = [10, 15, 20, 25];

// Calculate cone height from base to top
cone_base_diameter = handle_diameter;
cone_base_radius = cone_base_diameter / 2;
cone_top_radius = cone_top_diameter / 2;
sphere_radius = sphere_diameter / 2;

// Handle cylinder
module handle() {
    cylinder(h = handle_height, r = handle_diameter / 2, center = false);
}

// Grooves
module grooves() {
    for (z_center = groove_centers) {
        translate([0, 0, z_center - groove_width / 2])
            cylinder(h = groove_width + 0.01, r = (handle_diameter / 2) - groove_depth, center = false);
    }
}

// Cone
module cone() {
    bottom_radius = handle_diameter / 2;
    top_radius = cone_top_diameter / 2;
    height = cone_height;
    
    translate([0, 0, handle_height])
        cylinder(h = height, r1 = bottom_radius, r2 = top_radius, center = false);
}

// Rounded tip (sphere)
module tip() {
    translate([0, 0, handle_height + cone_height])
        sphere(r = sphere_radius);
}

// Assemble the pestle
module pestle() {
    union() {
        // Handle with grooves subtracted
        difference() {
            handle();
            grooves();
        }
        
        // Cone
        cone();
        
        // Tip
        tip();
    }
}

pestle();