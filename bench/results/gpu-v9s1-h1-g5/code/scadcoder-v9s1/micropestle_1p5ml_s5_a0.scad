// Pestle for grinding tissue inside a 1.5 mL microcentrifuge tube
// Printed standing upright: handle at the bottom, tip at the top.

// ---------------- Parameters ----------------
handle_d      = 8;    // handle diameter (mm), z = 0 to 45
handle_h      = 45;   // handle height (mm)
cone_top_d    = 8;    // cone diameter at top of handle (mm)
cone_bottom_d = 3;    // cone diameter at z = 62 (mm)
cone_top_z    = 45;   // cone top height (mm)
sphere_d      = 3;    // tip sphere diameter (mm)
sphere_cz     = 62;   // tip sphere centre height (mm)
groove_count  = 4;    // number of circumferential grooves
groove_w      = 2;    // groove width (mm), in Z
groove_depth  = 1;    // groove depth (mm)
groove_z      = [10, 15, 20, 25]; // groove centre heights (mm)
eps           = 0.5;  // cutter overshoot past faces (mm)

$fn = 96;             // curve resolution

// ---------------- Model ----------------
difference() {
    union() {
        // (1) Cylindrical handle
        cylinder(d = handle_d, h = handle_h);

        // (2) Tapering cone: 8 mm at z = 45 to 3 mm at z = 62
        translate([0, 0, cone_top_z])
            cylinder(d1 = cone_top_d, d2 = cone_bottom_d, h = sphere_cz - cone_top_z);

        // (3) Rounded tip: 3 mm sphere centred at z = 62
        translate([0, 0, sphere_cz - sphere_d / 2])
            sphere(d = sphere_d);
    }

    // Grip grooves, cut through the full height of the handle
    for (z = groove_z)
        translate([0, 0, z - groove_w / 2])
            cylinder(d = handle_d + 2 * eps, h = groove_w, $fn = 96);
}