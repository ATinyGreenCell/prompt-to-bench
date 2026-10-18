// Tissue pestle for 1.5 mL microcentrifuge tube
// Print orientation: handle down on the bed (z = 0), tip up (+Z)

$fn = 64;

// ---- Dimensions (mm) ----
handle_d      = 8;    // handle diameter
handle_h      = 45;   // handle height (z = 0 to 45)
cone_d_bottom = 8;    // cone diameter at z = 45
cone_d_top    = 3;    // cone diameter at z = 62
tip_d         = 3;    // sphere diameter (centred at z = 62)
tip_z         = 62;   // sphere centre height

groove_count  = 4;    // number of circumferential grip grooves
groove_w      = 2;    // groove width along Z
groove_depth  = 1;    // groove depth into handle
groove_z      = [10, 15, 20, 25]; // groove centre heights

eps           = 0.5;  // overshoot for clean boolean cuts

// ---- Model ----
difference() {
    union() {
        // Handle
        cylinder(d = handle_d, h = handle_h);

        // Cone (overlaps slightly into handle for a solid union)
        translate([0, 0, handle_h - 0.01])
            cylinder(d1 = cone_d_bottom, d2 = cone_d_top, h = cone_d_top - handle_h + 0.01);

        // Rounded tip
        translate([0, 0, tip_z])
            sphere(d = tip_d);
    }

    // Grip grooves cut into the handle
    for (z = groove_z)
        translate([0, 0, z - eps])
            cylinder(d = handle_d, h = groove_w, depth = groove_depth + eps);
}