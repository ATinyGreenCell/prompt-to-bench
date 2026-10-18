// Pestle for grinding tissue inside a 1.5 mL microcentrifuge tube
// Print orientation: standing upright, bottom on the bed (z = 0)

// ---------------- Parameters ----------------
handle_d      = 8;    // handle diameter (bottom and cone base)
handle_h      = 45;   // handle height (z = 0 to z = 45)
cone_top_d    = 3;    // cone tip diameter (at z = 62)
cone_bottom_d = 8;    // cone base diameter (at z = 45)
tip_d         = 3;    // sphere tip diameter
tip_z         = 62;   // sphere centre height
groove_count  = 4;    // number of circumferential grooves
groove_w      = 2;    // groove width in Z
groove_depth  = 1;    // groove depth into handle
groove_z      = [10, 15, 20, 25]; // groove centre heights
eps           = 0.5;  // cutter overshoot past faces
$fn           = 96;   // curve resolution

// ---------------- Model ----------------
difference() {
    union() {
        // (1) Cylindrical handle
        cylinder(d = handle_d, h = handle_h);

        // (2) Tapering cone from z = 45 to z = 62
        translate([0, 0, handle_h])
            cylinder(d1 = cone_bottom_d, d2 = cone_top_d, h = tip_z - handle_h);

        // (3) Rounded tip: sphere centred at z = 62
        translate([0, 0, tip_z])
            sphere(d = tip_d);
    }

    // (4) Grip grooves, cut through the full handle depth
    for (z = groove_z)
        translate([0, 0, z - groove_w / 2])
            cylinder(d = handle_d + 2 * eps, h = groove_w);
}