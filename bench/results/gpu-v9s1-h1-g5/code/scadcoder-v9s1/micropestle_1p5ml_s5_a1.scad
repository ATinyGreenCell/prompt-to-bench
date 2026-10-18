// Pestle for grinding tissue inside a 1.5 mL microcentrifuge tube
// Printed standing upright: handle at the bottom, tip at the top.
//
// Dimensions (mm):
//   handle_d      = 8.00   // handle diameter
//   handle_h      = 45.00  // handle height (z = 0 to 45)
//   cone_bottom_d = 3.00   // cone diameter at z = 62
//   sphere_d      = 3.00   // tip sphere diameter
//   groove_count  = 4      // number of circumferential grooves
//   groove_w      = 2.00   // groove width in Z
//   groove_depth  = 1.00   // groove depth from surface
//   groove_z      = [10, 15, 20, 25] // groove centre heights

// ---------------- Parameters ----------------
handle_d      = 8.0;
handle_h      = 45.0;
cone_bottom_d = 3.0;
sphere_d      = 3.0;
groove_count  = 4;
groove_w      = 2.0;
groove_depth  = 1.0;
groove_z      = [10, 15, 20, 25];

eps = 0.5;      // cutter overshoot past faces (mm)

$fn = 96;

// ---------------- Model ----------------
difference() {
    union() {
        // (1) Cylindrical handle: z = 0 to 45
        cylinder(d = handle_d, h = handle_h);

        // (2) Cone: z = 45 to 62, 8 mm -> 3 mm diameter
        translate([0, 0, handle_h])
            cylinder(d1 = handle_d, d2 = cone_bottom_d, h = sphere_d);

        // (3) Rounded tip: sphere centred at z = 62
        translate([0, 0, handle_h + sphere_d / 2])
            sphere(d = sphere_d);
    }

    // Grip grooves
    for (z = groove_z)
        translate([0, 0, z - groove_w / 2])
            cylinder(d = handle_d + 2 * eps, h = groove_w, $fn = 96);
}