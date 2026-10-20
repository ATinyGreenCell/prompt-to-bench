// Pestle for grinding tissue inside a 1.5 mL microcentrifuge tube
// Printed standing upright, resting on the XY plane at z = 0.

$fn = 64;

// Dimensions (mm)
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

// Build the pestle in the print orientation: upright, base at z = 0.
difference() {
    // (1) Cylindrical handle from z = 0 to z = 45
    cylinder(h = handle_height, d = handle_diameter, center = false);

    // (2) Cone tapering from 8 mm at z = 45 to 3 mm at z = 62
    translate([0, 0, cone_bottom_z])
        cylinder(h = cone_top_z - cone_bottom_z,
                 d1 = cone_bottom_diameter,
                 d2 = cone_top_diameter,
                 center = false);

    // (3) Rounded tip: 3 mm sphere centred at z = 62
    translate([0, 0, tip_center_z])
        sphere(d = tip_diameter);

    // Grip grooves: cut four circumferential grooves into the handle.
    // Each groove is 2 mm wide in Z and 1 mm deep, centred at the given Z.
    // The cutting ring extends 0.5 mm past the handle surface in X/Y
    // and 0.5 mm past each face in Z, so no faces are coplanar.
    for (z = groove_centers_z) {
        translate([0, 0, z - groove_width / 2])
            difference() {
                // Outer cylinder: extends 0.5 mm past the handle surface
                cylinder(h = groove_width + 1, d = handle_diameter + 1, center = false);
                // Inner cylinder: defines the groove depth (1 mm into the handle)
                cylinder(h = groove_width + 1, d = handle_diameter - 2 * groove_depth, center = false);
            }
    }
}