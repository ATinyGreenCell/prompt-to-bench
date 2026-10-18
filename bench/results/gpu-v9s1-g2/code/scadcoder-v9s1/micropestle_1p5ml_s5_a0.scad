// Pestle for grinding tissue inside a 1.5 mL microcentrifuge tube
// Printed standing upright (z = 0 at the bottom)

// ---------------- Parameters ----------------
handle_d      = 8;    // handle diameter (mm), z = 0 to 45
handle_h      = 45;   // handle height (mm)
cone_d_top    = 8;    // cone diameter at top of handle (mm)
cone_d_tip    = 3;    // cone diameter at z = 62 (mm)
cone_top_z    = 62;   // cone top height (mm)
tip_d         = 3;    // rounded tip diameter (mm)
tip_z         = 62;   // tip centre height (mm)
groove_count  = 4;    // number of circumferential grooves
groove_w      = 2;    // groove width in Z (mm)
groove_depth  = 1;    // groove depth (mm)
groove_z      = [10, 15, 20, 25]; // groove centre heights (mm)
eps           = 0.5;  // cutter overshoot past faces (mm)
$fn           = 96;   // curve resolution

// ---------------- Model ----------------
difference() {
    union() {
        // (1) Cylindrical handle
        cylinder(d = handle_d, h = handle_h);

        // (2) Tapered cone from handle top to tip diameter
        translate([0, 0, cone_top_z - cone_d_tip])
            cylinder(d1 = cone_d_tip, d2 = cone_d_top, h = cone_d_tip);

        // (3) Rounded tip: sphere centred at z = 62
        translate([0, 0, tip_z - tip_d / 2])
            sphere(d = tip_d);
    }

    // Grip grooves, cut through the handle (z = 0 to 45)
    for (z = groove_z)
        translate([0, 0, z - groove_w / 2])
            cylinder(d = handle_d + 2 * eps, h = groove_w, $fn = 64);
}