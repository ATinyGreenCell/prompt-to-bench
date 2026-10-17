// Tissue-pestle for 1.5 mL microcentrifuge tube
// Print orientation: standing upright, handle down

// ---- Dimensions (mm) ----
handle_d      = 8;     // handle diameter
handle_h      = 45;    // handle height (z = 0 to 45)
cone_top_d    = 8;     // cone diameter at top of handle (z = 45)
cone_tip_d    = 3;     // cone diameter at z = 62
tip_r         = 1.5;   // tip sphere radius (3 mm diameter)
tip_z         = 62;    // tip sphere centre height
groove_w      = 2;     // groove width (Z)
groove_depth  = 1;     // groove depth
groove_z      = [10, 15, 20, 25]; // groove centre heights
eps           = 0.5;   // cutter overshoot past faces

$fn = 96;

// ---- Model ----
difference() {
    union() {
        // Handle
        cylinder(d = handle_d, h = handle_h);
        // Cone (tapers from 8 mm at z = 45 to 3 mm at z = 62)
        translate([0, 0, handle_h])
            cylinder(d1 = cone_top_d, d2 = cone_tip_d, h = tip_z - handle_h);
        // Rounded tip: 3 mm diameter sphere centred at z = 62
        translate([0, 0, tip_z])
            sphere(r = tip_r);
    }
    // Grip grooves, cut fully through (extend past bottom face)
    for (z = groove_z)
        translate([0, 0, z])
            cylinder(d = handle_d + 2 * eps, h = groove_w, depth = groove_depth);
}