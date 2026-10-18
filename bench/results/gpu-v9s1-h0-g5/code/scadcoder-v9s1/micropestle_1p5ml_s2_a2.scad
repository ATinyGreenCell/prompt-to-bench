// Pestle for grinding tissue inside a 1.5 mL microcentrifuge tube
// Print orientation: standing upright on the bed, builds up +Z

// ---------------- Parameters ----------------
handle_d      = 8;    // handle diameter (mm), z = 0 to 45
handle_h      = 45;   // handle height (mm)
cone_d_top    = 8;    // cone diameter at top (mm), z = 45
cone_d_tip    = 3;    // cone diameter at tip (mm), z = 62
cone_h        = 17;   // cone height (mm), 45 to 62
tip_r         = 1.5;  // tip sphere radius (mm), centre z = 62
tip_h         = 3;    // tip height above centre (mm)

groove_count  = 4;    // number of circumferential grooves
groove_w      = 2;    // groove width (mm), in Z
groove_d      = 1;    // groove depth (mm)
groove_z      = [10, 15, 20, 25]; // groove centre heights (mm)

eps           = 0.5;  // cutter overshoot past faces (mm)
$fn           = 96;   // curve resolution

// ---------------- Model ----------------
difference() {
    union() {
        // (1) Cylindrical handle
        cylinder(d = handle_d, h = handle_h);

        // (2) Tapering cone, 8 mm at z = 45 to 3 mm at z = 62
        translate([0, 0, handle_h])
            cylinder(d1 = cone_d_top, d2 = cone_d_tip, h = cone_h);

        // (3) Rounded tip: 3 mm diameter sphere centred at z = 62
        translate([0, 0, cone_h + tip_r])
            sphere(r = tip_r);
    }

    // Grip grooves, each extending past the bottom face
    for (g = [0 : groove_count - 1]) {
        translate([0, 0, groove_z[g] - eps])
            cylinder(d = handle_d + 2 * eps, h = groove_w, $fn = 64);
    }
}