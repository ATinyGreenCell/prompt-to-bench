// Tissue-pestle for 1.5 mL microcentrifuge tube
// Print orientation: handle down on the bed (z = 0), tip up (+Z)

$fn = 64;

// ---- Dimensions (mm) ----
handle_d      = 8;    // handle diameter
handle_h      = 45;   // handle height (z = 0 .. 45)
cone_d_bottom = 8;    // cone diameter at z = 45
cone_d_top    = 3;    // cone diameter at z = 62
tip_d         = 3;    // sphere diameter (centred at z = 62)
groove_w      = 2;    // circumferential groove width (Z)
groove_depth  = 1;    // groove depth into handle
groove_zs     = [10, 15, 20, 25]; // groove centre heights

eps = 0.5;            // overshoot for clean boolean cuts

// ---- Model ----
difference() {
    union() {
        // Handle
        cylinder(d = handle_d, h = handle_h);
        // Cone (overlaps slightly into handle for a solid union)
        translate([0, 0, handle_h - 0.01])
            cylinder(d1 = cone_d_bottom, d2 = cone_d_top, h = cone_d_top - cone_d_bottom + 0.01);
        // Rounded tip
        translate([0, 0, handle_h + (cone_d_top - tip_d) / 2])
            sphere(d = tip_d);
    }
    // Grip grooves
    for (z = groove_zs)
        translate([0, 0, z])
            cube([handle_d, handle_d, groove_w]);
}