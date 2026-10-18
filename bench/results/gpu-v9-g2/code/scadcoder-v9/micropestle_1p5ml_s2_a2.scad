// Tissue-grinding pestle for 1.5 mL microcentrifuge tube
// Print orientation: standing upright on the XY plane, building up +Z

// ---------------- Parameters ----------------
handle_d      = 8;    // handle diameter (z = 0 .. 45)
handle_h      = 45;   // handle height
cone_top_d    = 8;    // cone diameter at its bottom (z = 45)
cone_tip_d    = 3;    // cone diameter at its top (z = 62)
cone_h        = 17;   // cone height (62 - 45)
tip_r         = 1.5;  // tip sphere radius (centre at z = 62)
groove_count  = 4;    // number of circumferential grooves
groove_w      = 2;    // groove width along Z
groove_depth  = 1;    // groove depth into handle
groove_z      = [10, 15, 20, 25]; // groove centre heights
eps           = 0.5;  // overshoot for clean boolean cuts

$fn = 96;

// ---------------- Model ----------------
difference() {
    union() {
        // Handle
        cylinder(d = handle_d, h = handle_h);

        // Tapered cone (z = 45 .. 62)
        translate([0, 0, handle_h])
            cylinder(d1 = cone_tip_d, d2 = cone_top_d, h = cone_h);

        // Rounded tip: sphere centred at z = 62
        translate([0, 0, handle_h + cone_h])
            sphere(r = tip_r);
    }

    // Grip grooves, cut through the handle
    for (z = groove_z)
        translate([0, 0, z - groove_w / 2])
            cylinder(d = handle_d + 2 * groove_depth, h = groove_w + eps);
}