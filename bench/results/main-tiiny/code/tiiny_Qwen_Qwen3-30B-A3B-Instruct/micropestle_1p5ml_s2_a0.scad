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
    // Create a polygon that goes from radius 4 at z = 45 to radius 1.5 at z = 62
    // We'll use a polygon with two points: (4, 45) and (1.5, 62)
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
                // But we only want the part that intersects the handle, so we use a bounding box to limit it
                // We'll use a cube to clip the groove to the handle's region
                // The groove is only in the handle (z = 0 to 45), so we clip it to that region
                // But since we're using difference, we can just make the groove cylinder long enough and let it be clipped by the handle
                // So we don't need extra clipping — the handle already bounds it
            }
    }
}

// Assemble the pestle
pestle();