// Tissue pestle for 1.5 mL microcentrifuge tube
// Print orientation: standing upright on the bed (z = 0)

$fn = 96;

// ---- Dimensions (mm) ----
handle_d      = 8;    // handle diameter
handle_h      = 45;   // handle height (z = 0 to 45)
cone_top_d    = 8;    // cone diameter at z = 45
cone_bottom_d = 3;    // cone diameter at z = 62
tip_d         = 3;    // sphere diameter
tip_z         = 62;   // sphere centre height
groove_count  = 4;    // circumferential grip grooves
groove_w      = 2;    // groove width (Z)
groove_depth  = 1;    // groove depth into handle
groove_z      = [10, 15, 20, 25]; // groove centre heights

// ---- Model ----
difference() {
    union() {
        // Handle
        cylinder(d = handle_d, h = handle_h);
        // Cone
        translate([0, 0, handle_h])
            cylinder(h = tip_z - handle_h, d1 = cone_top_d, d2 = cone_bottom_d);
        // Rounded tip
        translate([0, 0, tip_z])
            sphere(d = tip_d);
    }
    // Grip grooves
    for (z = groove_z)
        translate([0, 0, z - groove_w / 2])
            cylinder(h = groove_w, d = handle_d - 2 * groove_depth);
}