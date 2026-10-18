// Tissue-pestle for 1.5 mL microcentrifuge tubes
// Print orientation: standing upright on the bed (z = 0), building up +Z

$fn = 96;

// ---- Dimensions (mm) ----
handle_d      = 8;    // handle diameter
handle_h      = 45;   // handle height (z = 0..45)
cone_d_top    = 8;    // cone diameter at its bottom (z = 45)
cone_d_tip    = 3;    // cone diameter at its top (z = 62)
tip_d         = 3;    // rounded tip diameter
tip_z         = 62;   // tip centre height
groove_count  = 4;    // number of circumferential grooves
groove_w      = 2;    // groove width (in Z)
groove_depth  = 1;    // groove depth
groove_z      = [10, 15, 20, 25]; // groove centre heights
eps           = 0.5;  // cutter overshoot past faces

// ---- Model ----
difference() {
    union() {
        // Handle
        cylinder(d = handle_d, h = handle_h);

        // Cone (z = 45..62)
        translate([0, 0, handle_h])
            cylinder(d1 = cone_d_top, d2 = cone_d_tip, h = tip_z - handle_h);

        // Rounded tip (z = 62)
        translate([0, 0, tip_z])
            sphere(d = tip_d);
    }

    // Grip grooves
    for (g = groove_count) {
        translate([0, -groove_w / 2, groove_z[g - 1] - eps])
            cube([handle_d + 2 * eps, groove_w, groove_w + 2 * eps]);
    }
}