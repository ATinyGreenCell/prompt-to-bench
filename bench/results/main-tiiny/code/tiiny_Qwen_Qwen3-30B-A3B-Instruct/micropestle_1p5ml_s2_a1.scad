$fn = 64;

// Dimensions
handle_diameter = 8;
cone_start_z = 45;
cone_end_z = 62;
cone_base_diameter = 8;
cone_tip_diameter = 3;
tip_sphere_radius = 3;
tip_sphere_center_z = 62;

// Groove dimensions
groove_width_z = 2;
groove_depth = 1;
groove_centers_z = [10, 15, 20, 25];

// Create the pestle
module pestle() {
    // Base handle: cylinder from z = 0 to z = 45
    translate([0, 0, 0])
        cylinder(h = 45, r = handle_diameter / 2, center = false);

    // Cone: tapers from 8 mm at z = 45 to 3 mm at z = 62
    // Use linear_extrude with a polygon that tapers from base to tip
    // Create a polygon with two points: (4, 45) and (1.5, 62)
    // Then extrude it along Z from 45 to 62
    translate([0, 0, cone_start_z])
        linear_extrude(height = cone_end_z - cone_start_z, convexity = 10)
        polygon(points = [[4, 0], [1.5, cone_end_z - cone_start_z]]);

    // Rounded tip: sphere of radius 3 mm, centered at z = 62
    translate([0, 0, tip_sphere_center_z])
        sphere(r = tip_sphere_radius);

    // Add grooves: four circumferential grooves on the handle
    for (z_center in groove_centers_z) {
        // Cut a groove: a cylinder of radius (handle_diameter/2 - groove_depth) 
        // that goes through the handle, centered at z_center, with height groove_width_z
        // The groove is cut into the handle, so we subtract a cylinder from the handle
        // The groove cylinder should extend slightly beyond the handle's Z bounds to ensure clean cut
        translate([0, 0, z_center - groove_width_z / 2 - 0.01])
            difference() {
                // Full cylinder for the groove, slightly longer than needed
                cylinder(h = groove_width_z + 0.02, r = (handle_diameter / 2) - groove_depth, center = false);
                // Clip it to the handle's region using a bounding box (to avoid cutting outside)
                // We'll use a cube that covers the handle's region at this z
                // But since we're using difference, we can just ensure the groove is within bounds
                // So we don't need extra clipping — the handle already bounds it
            }
    }
}

// Assemble the pestle
pestle();