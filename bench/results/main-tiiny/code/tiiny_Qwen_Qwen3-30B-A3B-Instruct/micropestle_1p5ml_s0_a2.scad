// Dimensions in millimetres
handle_diameter = 8;
cone_start_z = 45;
cone_end_z = 62;
cone_base_diameter = 8;
cone_tip_diameter = 3;
tip_sphere_radius = 3;
tip_sphere_center_z = 62;

// Groove dimensions
groove_width_z = 2;   // width in Z direction
groove_depth = 1;     // depth into the handle
groove_centers_z = [10, 15, 20, 25];

// Set resolution for smooth curves
$fn = 64;

// Main body: handle + cone + tip
module pestle() {
    // (1) Handle: cylinder from z = 0 to z = 45
    translate([0, 0, 0])
        cylinder(h = 45, r = handle_diameter / 2, center = false);

    // (2) Cone: tapers from 8 mm at z = 45 to 3 mm at z = 62
    // Use linear_extrude with a polygon that tapers from base to tip
    translate([0, 0, cone_start_z])
        linear_extrude(height = cone_end_z - cone_start_z, convexity = 10)
        polygon(points = [
            [handle_diameter / 2, 0],
            [cone_tip_diameter / 2, cone_end_z - cone_start_z]
        ]);

    // (3) Rounded tip: sphere of 3 mm diameter, centred at z = 62
    translate([0, 0, tip_sphere_center_z])
        sphere(r = tip_sphere_radius);
}

// Grooves: four circumferential grooves on the handle
module grooves() {
    for (z_center in groove_centers_z) {
        // Create a rectangular prism for the groove
        // Groove is 2 mm high (in Z), 1 mm deep (into the handle), and wraps around the handle
        // Use a cylinder with a rectangular hole cut through it
        difference() {
            // Outer cylinder: same as handle, but only for the groove height
            translate([0, 0, z_center])
                cylinder(h = groove_width_z, r = handle_diameter / 2, center = false);

            // Cut out a rectangular prism (in the radial direction) to make the groove
            // The cut extends 0.1 mm beyond the handle radius to ensure clean difference
            translate([0, 0, z_center])
                cube(size = [handle_diameter + 0.1, groove_depth + 0.1, groove_width_z], center = false);
        }
    }
}

// Assemble the pestle with grooves
union() {
    pestle();
    grooves();
}