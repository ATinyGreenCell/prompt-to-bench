// Pestle for grinding tissue inside a 1.5 mL microcentrifuge tube
// Print orientation: standing upright on the bed (z = 0)

// ---------------- Parameters ----------------
handle_d      = 8;    // handle diameter (mm)
handle_h      = 45;   // handle height, z = 0 to 45 (mm)
cone_top_d    = 8;    // cone diameter at top (seam with handle) (mm)
cone_bottom_d = 3;    // cone diameter at bottom (mm)
cone_h        = 17;   // cone height, z = 45 to 62 (mm)
tip_d         = 3;    // sphere tip diameter (mm)
tip_z         = 62;   // sphere centre height (mm)
groove_count  = 4;    // number of circumferential grooves
groove_w      = 2;    // groove width along Z (mm)
groove_depth  = 1;    // groove depth from surface (mm)
eps           = 0.5;  // cutter overshoot past faces (mm)
$fn           = 96;   // curve resolution

// ---------------- Model ----------------
difference() {
    union() {
        // (1) Cylindrical handle
        cylinder(d = handle_d, h = handle_h);

        // (2) Tapering cone: 8 mm at z = 45 -> 3 mm at z = 62
        translate([0, 0, handle_h])
            cylinder(d1 = cone_top_d, d2 = cone_bottom_d, h = cone_h);

        // (3) Rounded tip: 3 mm sphere centred at z = 62
        translate([0, 0, tip_z])
            sphere(d = tip_d);
    }

    // Grip grooves, centred at z = 10, 15, 20, 25
    for (i = [0 : groove_count - 1]) {
        rotate([0, 0, i * 360 / groove_count])
            translate([0, -groove_depth, groove_w * (i < groove_count - 1 ? i + 1 : 0)])
                cube([handle_d + 2 * groove_depth, groove_w, eps]);
    }
}