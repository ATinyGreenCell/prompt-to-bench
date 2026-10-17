// Tissue-pestle for 1.5 mL microcentrifuge tube
// Print orientation: standing upright, handle on the bed

// ---- Dimensions (mm) ----
handle_d      = 8;     // handle diameter
handle_h      = 45;    // handle height (z = 0 to 45)
cone_top_d    = 8;     // cone diameter at top of handle (z = 45)
cone_tip_d    = 3;     // cone diameter at tip (z = 62)
tip_r         = 1.5;   // rounded tip radius (sphere centred at z = 62)
groove_w      = 2;     // groove width (Z)
groove_depth  = 1;     // groove depth from handle surface
groove_z      = [10, 15, 20, 25]; // groove centre heights

eps           = 0.5;   // cutter overshoot past faces
$fn           = 96;    // curve resolution

// ---- Model ----
difference() {
    union() {
        // Handle
        cylinder(d = handle_d, h = handle_h);
        // Tapering cone (z = 45 to 62)
        translate([0, 0, handle_h])
            cylinder(d1 = cone_top_d, d2 = cone_tip_d, h = cone_tip_d - cone_top_d + eps);
        // Rounded tip
        translate([0, 0, handle_h + cone_tip_d - cone_top_d])
            sphere(r = tip_r);
    }
    // Grip grooves
    for (z = groove_z)
        translate([0, 0, z])
            cylinder(d = handle_d + 2 * eps, h = groove_w, depth = groove_depth);
}