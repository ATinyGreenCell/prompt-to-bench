// Tissue-grinding pestle for 1.5 mL microcentrifuge tube
// Print orientation: standing upright on the bed (z = 0), building +Z.

// ---------------- Parameters ----------------
handle_d      = 8;     // handle diameter (cone base diameter)
handle_h      = 45;    // handle height (z = 0 to 45)
cone_top_d    = 3;     // cone tip diameter at z = 62
cone_bottom_d = 8;     // cone base diameter at z = 45
cone_h        = 17;    // cone height (z = 45 to 62)
tip_r         = 1.5;   // rounded tip radius (3 mm diameter sphere)
tip_z         = 62;    // sphere centre height
groove_count  = 4;     // number of circumferential grooves
groove_w      = 2;     // groove width along Z
groove_d      = 1;     // groove depth from surface
groove_z      = [10, 15, 20, 25]; // groove centre heights
eps           = 0.5;   // cutter overshoot past faces
$fn           = 96;    // curve resolution

// ---------------- Model ----------------
difference() {
    union() {
        // (1) Cylindrical handle
        cylinder(d = handle_d, h = handle_h);

        // (2) Tapering cone (8 mm -> 3 mm)
        translate([0, 0, handle_h])
            cylinder(d1 = cone_bottom_d, d2 = cone_top_d, h = cone_h);

        // (3) Rounded tip: 3 mm diameter sphere centred at z = 62
        translate([0, 0, tip_z])
            sphere(r = tip_r);
    }

    // Grip grooves, cut fully through the handle
    for (z = groove_z)
        translate([0, 0, z])
            rotate([0, 90, 0])
                cylinder(d = groove_d, h = groove_w, center = true);
}