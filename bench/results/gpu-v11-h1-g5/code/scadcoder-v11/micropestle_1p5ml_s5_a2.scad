// Tissue pestle for 1.5 mL microcentrifuge tube
// Print orientation: standing upright on the bed (z = 0)

$fn = 96;

// ---- Dimensions (mm) ----
handle_d      = 8;    // handle diameter
handle_h      = 45;   // handle height (z = 0 to 45)
cone_d_top    = 8;    // cone diameter at top (z = 45)
cone_d_tip    = 3;    // cone diameter at tip (z = 62)
tip_r         = 1.5;  // rounded tip radius (sphere centre at z = 62)
groove_count  = 4;    // circumferential grip grooves
groove_w      = 2;    // groove width (Z)
groove_depth  = 1;    // groove depth into handle
groove_z      = [10, 15, 20, 25]; // groove centre heights

// ---- Model ----
difference() {
    union() {
        // Handle
        translate([0, 0, 0])
            cylinder(d = handle_d, h = handle_h);

        // Cone (tapers from d_top at z = handle_h to d_tip at z = handle_h + cone_h)
        translate([0, 0, handle_h])
            cylinder(h = 17, d1 = cone_d_top, d2 = cone_d_tip);

        // Rounded tip: sphere centred at z = 62
        translate([0, 0, 62])
            sphere(r = tip_r);
    }

    // Grip grooves
    for (z = groove_z)
        translate([0, 0, z - groove_w / 2])
            rotate_extrude()
                translate([handle_d / 2, 0, 0])
                    circle(r = groove_depth, $fn = 64);
}