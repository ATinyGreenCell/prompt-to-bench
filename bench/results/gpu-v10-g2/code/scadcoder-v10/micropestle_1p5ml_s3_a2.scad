// Tissue-pestle for 1.5 mL microcentrifuge tubes
// Print orientation: standing upright on the bed (z = 0)

// ---------------- Parameters ----------------
handle_d      = 8;    // handle diameter (mm)
handle_h      = 45;   // handle height (mm), z = 0..45
cone_d_top    = 8;    // cone diameter at its base, same as handle (mm)
cone_d_tip    = 3;    // cone diameter at its tip (mm)
cone_top_z    = 45;   // cone base height (mm)
cone_tip_z    = 62;   // cone tip height (mm)
tip_d         = 3;    // rounded tip sphere diameter (mm)
tip_z         = 62;   // sphere centre height (mm)
groove_count  = 4;    // number of circumferential grip grooves
groove_w      = 2;    // groove width (mm), measured along Z
groove_depth  = 1;    // groove depth (mm), cut into the handle
cut_extra     = 0.5;  // overshoot of cutters past faces (mm)

$fn = 96;             // curve resolution

// ---------------- Model ----------------
difference() {
    union() {
        // (1) Cylindrical handle
        cylinder(d = handle_d, h = handle_h);

        // (2) Tapering cone: 8 mm at z = 45 down to 3 mm at z = 62
        translate([0, 0, cone_top_z])
            cylinder(d1 = cone_d_top, d2 = cone_d_tip, h = cone_tip_z - cone_top_z);

        // (3) Rounded tip: 3 mm sphere centred at z = 62
        translate([0, 0, tip_z - tip_d / 2])
            sphere(d = tip_d);
    }

    // Grip grooves, centred at z = 10, 15, 20, 25
    for (i = [0 : groove_count - 1]) {
        z_c = 10 + i * 5;
        translate([0, 0, z_c - groove_w / 2])
            cylinder(d = handle_d + 2 * cut_extra, h = groove_w, center = true);
    }
}