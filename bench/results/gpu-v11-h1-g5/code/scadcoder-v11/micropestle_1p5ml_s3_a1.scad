// Tissue pestle for 1.5 mL microcentrifuge tube
// Print orientation: standing upright on the bed (z = 0)

$fn = 96;

// ---- Dimensions (mm) ----
handle_d      = 8;    // handle diameter
handle_h      = 45;   // handle height (z = 0 to 45)
cone_d_top    = 8;    // cone diameter at top (z = 62)
cone_d_bottom = 3;    // cone diameter at bottom (z = 45)
tip_d         = 3;    // tip sphere diameter
tip_z         = 62;   // tip sphere centre height
tube_id       = 16.5; // reference: 1.5 mL tube inner diameter

// ---- Grooves ----
groove_count  = 4;    // circumferential grooves
groove_w      = 2;    // groove width (Z)
groove_depth  = 1;    // groove depth into handle
groove_z      = [10, 15, 20, 25]; // groove centre heights

// ---- Model ----
difference() {
    union() {
        // Handle
        translate([0, 0, 0])
            cylinder(d = handle_d, h = handle_h);

        // Cone (z = 45 to 62)
        translate([0, 0, handle_h - 0.01])
            cylinder(h = tip_z - handle_h + 0.01,
                     d1 = cone_d_bottom,
                     d2 = cone_d_top);

        // Rounded tip sphere
        translate([0, 0, tip_z])
            sphere(d = tip_d);
    }

    // Grip grooves
    for (i = [0 : groove_count - 1]) {
        z = groove_z[i];
        translate([0, 0, z - groove_w / 2])
            rotate([0, 90, 0])
                cylinder(h = groove_depth,
                         d = handle_d - 2 * groove_depth);
    }
}