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

// Calculate handle radius
handle_radius = handle_diameter / 2;
cone_bottom_radius = handle_radius;
cone_top_radius = cone_top_diameter / 2;
sphere_radius = sphere_diameter / 2;

// Build the pestle
union() {
    // (1) Handle cylinder
    translate([0, 0, 0])
        cylinder(h = handle_height, r = handle_radius, center = false);
    
    // (2) Cone
    translate([0, 0, handle_height])
        cylinder(h = cone_height, r1 = cone_bottom_radius, r2 = cone_top_radius, center = false);
    
    // (3) Rounded tip (sphere)
    translate([0, 0, handle_height + cone_height])
        sphere(r = sphere_radius);
    
    // Grooves: cut circumferential grooves into the handle
    for (z_center = groove_centers) {
        z_start = z_center - groove_width/2;
        z_end = z_center + groove_width/2;
        // Subtract the handle in groove region, then add back the reduced cylinder
        translate([0, 0, z_start])
            difference() {
                cylinder(h = groove_width + 0.02, r = handle_radius, center = false);
                translate([0, 0, -0.01])
                    cylinder(h = groove_width + 0.03, r = handle_radius - groove_depth, center = false);
            }
    }
}