// Tissue pestle for 1.5 mL microcentrifuge tube
// Print orientation: handle down on the bed (z = 0), tip up (+Z)

$fn = 64;

// ---- Dimensions (mm) ----
handle_d      = 8;    // handle diameter
handle_h      = 45;   // handle height (z = 0 to 45)
cone_d1       = 8;    // cone diameter at z = 45
cone_d2       = 3;    // cone diameter at z = 62
cone_top_z    = 62;   // cone top height
tip_r         = 1.5;  // tip sphere radius (3 mm diameter)
tip_cz        = 62;   // tip sphere centre height
groove_count  = 4;    // number of circumferential grooves
groove_w      = 2;    // groove width in Z
groove_depth  = 1;    // groove depth into handle
groove_z      = [10, 15, 20, 25]; // groove centre heights

eps = 0.5;            // overshoot for clean boolean cuts

// ---- Model ----
difference() {
    union() {
        // Handle
        cylinder(d = handle_d, h = handle_h);
        // Cone (slightly overlapping handle for a solid union)
        translate([0, 0, handle_h - 0.01])
            cylinder(d1 = cone_d1, d2 = cone_d2, h = cone_top_z - handle_h + 0.01);
        // Tip
        translate([0, 0, tip_cz])
            sphere(r = tip_r);
    }
    // Grooves
    for (g = [0 : groove_count - 1]) {
        translate([0, 0, groove_z[g]])
            cylinder(d = handle_d + 2 * eps, h = groove_w);
    }
}