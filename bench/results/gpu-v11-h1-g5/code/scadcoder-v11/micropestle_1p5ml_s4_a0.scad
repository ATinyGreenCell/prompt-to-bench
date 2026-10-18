// Tissue-pestle for 1.5 mL microcentrifuge tube
// Print orientation: standing upright on the bed (z = 0)

$fn = 96;

// ---- Dimensions (mm) ----
handle_d      = 8;    // handle diameter (z = 0 to 45)
handle_h      = 45;   // handle height
cone_top_d    = 3;    // cone diameter at top (z = 62)
cone_bottom_d = 8;    // cone diameter at bottom (z = 45)
tip_d         = 3;    // sphere tip diameter
tip_z         = 62;   // sphere centre height
groove_count  = 4;    // circumferential grooves
groove_w      = 2;    // groove width (Z)
groove_depth  = 1;    // groove depth into handle
groove_z      = [10, 15, 20, 25]; // groove centre heights

// ---- Model ----
difference() {
    union() {
        // Handle
        cylinder(d = handle_d, h = handle_h);
        // Cone
        translate([0, 0, handle_h - 0.01])
            cylinder(d1 = cone_bottom_d, d2 = cone_top_d, h = tip_z - handle_h + 0.01);
        // Tip sphere
        translate([0, 0, tip_z])
            sphere(d = tip_d);
    }
    // Grooves
    for (z = groove_z)
        translate([0, 0, z - groove_w / 2])
            cylinder(d = handle_d + 2, h = groove_w, depth = groove_depth);
}