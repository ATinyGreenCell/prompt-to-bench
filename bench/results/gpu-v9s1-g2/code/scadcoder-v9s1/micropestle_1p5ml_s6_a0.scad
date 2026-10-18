// Pestle for grinding tissue inside a 1.5 mL microcentrifuge tube
// Printed standing upright (z = 0 at the bottom)

// ---------------- Parameters ----------------
handle_d      = 8;    // handle diameter (mm), z = 0 to 45
handle_h      = 45;   // handle height (mm)
cone_top_d    = 8;    // cone top diameter, at z = handle_h (mm)
cone_tip_d    = 3;    // cone tip diameter (mm), at z = 62
sphere_d      = 3;    // tip sphere diameter (mm), centred at z = 62
groove_count  = 4;    // number of circumferential grooves
groove_w      = 2;    // groove width (mm), measured in Z
groove_depth  = 1;    // groove depth (mm)
groove_z      = [10, 15, 20, 25]; // groove centre heights (mm)
eps           = 0.5;  // cutter overshoot past faces (mm)

$fn = 96;

// ---------------- Model ----------------
difference() {
    union() {
        // (1) Cylindrical handle
        cylinder(d = handle_d, h = handle_h);

        // (2) Tapered cone: 8 mm at z = 45 to 3 mm at z = 62
        translate([0, 0, handle_h])
            cylinder(d1 = cone_top_d, d2 = cone_tip_d, h = cone_tip_d - handle_h);

        // (3) Rounded tip: 3 mm sphere centred at z = 62
        translate([0, 0, 62 - sphere_d / 2])
            sphere(d = sphere_d);
    }

    // Grip grooves, cut through the handle (and slightly into the cone)
    for (z = groove_z)
        translate([0, 0, z - groove_w / 2])
            cylinder(d = handle_d + 2 * eps, h = groove_w, $fn = 96);
}