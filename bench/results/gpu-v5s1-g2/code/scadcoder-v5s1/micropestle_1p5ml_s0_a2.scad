// Pestle for grinding tissue in a 1.5 mL microcentrifuge tube
// Print orientation: standing upright, handle on the bed (z = 0)

// ---------------- Parameters ----------------
handle_d      = 8;     // handle diameter (mm)
handle_h      = 45;    // handle height (mm)
cone_start_d  = 8;     // cone diameter at top of handle (mm)
cone_end_d    = 3;     // cone diameter at cone tip (mm)
cone_top_z    = 62;    // cone tip height (mm)
tip_d         = 3;     // rounded tip diameter (mm)
tip_z         = 62;    // rounded tip centre height (mm)
groove_w      = 2;     // groove width (mm)
groove_depth  = 1;     // groove depth (mm)
groove_z      = [10, 15, 20, 25]; // groove centre heights (mm)
eps           = 0.5;   // cutter overshoot past faces (mm)
$fn           = 96;    // curve resolution

// ---------------- Model ----------------
difference() {
    union() {
        // Handle
        cylinder(d = handle_d, h = handle_h);
        // Cone (tapers over the cone_top_z range)
        translate([0, 0, handle_h])
            cylinder(d1 = cone_start_d, d2 = cone_end_d, h = cone_top_z - handle_h + 0.01);
        // Rounded tip
        translate([0, 0, tip_z])
            sphere(d = tip_d);
    }
    // Grip grooves
    for (z = groove_z)
        translate([0, 0, z])
            cylinder(d = handle_d - 2 * groove_depth, h = groove_w + 2 * eps, center = true);
}