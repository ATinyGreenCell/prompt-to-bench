// Tissue pestle for 1.5 mL microcentrifuge tube
// Print orientation: standing upright on the bed (z = 0)

$fn = 96;

// ---- Dimensions (mm) ----
handle_d      = 8;    // handle diameter (z = 0 to 45)
handle_h      = 45;   // handle height
cone_top_d    = 8;    // cone diameter at z = 45
cone_tip_d    = 3;    // cone diameter at z = 62
cone_h        = 62 - 45; // cone height (17)
tip_d         = 3;    // sphere diameter, centred at z = 62
groove_w      = 2;    // groove width (Z)
groove_depth  = 1;    // groove depth into handle
groove_z      = [10, 15, 20, 25]; // groove centre heights
eps           = 0.5;  // cutter overshoot

difference() {
    union() {
        // Handle
        cylinder(d = handle_d, h = handle_h);
        // Cone (tangent to handle at z = 45)
        translate([0, 0, 45])
            cylinder(h = cone_h, d1 = cone_top_d, d2 = cone_tip_d);
        // Rounded tip
        translate([0, 0, 62])
            sphere(d = tip_d);
    }
    // Circumferential grip grooves
    for (z = groove_z)
        translate([0, 0, z])
            cylinder(h = groove_w, d = handle_d - 2 * groove_depth);
}