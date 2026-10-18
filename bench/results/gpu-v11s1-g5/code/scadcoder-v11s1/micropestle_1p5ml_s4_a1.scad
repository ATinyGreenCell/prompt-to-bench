// Tissue pestle for 1.5 mL microcentrifuge tube
// Print orientation: standing upright on the bed (z = 0), building upward.

// ---------------- Parameters ----------------
handle_d      = 8;    // handle diameter (mm)
handle_h      = 45;   // handle height, z = 0 to 45 (mm)

cone_d_bottom = 8;    // cone diameter at z = 45 (mm)
cone_d_top    = 3;    // cone diameter at z = 62 (mm)
cone_top_z    = 62;   // cone top height (mm)

tip_d         = 3;    // rounded tip diameter (mm)
tip_cz        = 62;   // tip sphere centre height (mm)

groove_count  = 4;    // number of circumferential grip grooves
groove_w      = 2;    // groove width (mm)
groove_depth  = 1;    // groove depth into handle (mm)
groove_z      = [10, 15, 20, 25]; // groove centre heights (mm)

eps           = 0.5;  // overshoot for clean boolean cuts (mm)

$fn = 96;             // curve resolution

// ---------------- Model ----------------
difference() {
    union() {
        // (1) Cylindrical handle
        cylinder(d = handle_d, h = handle_h);

        // (2) Cone: 8 mm at z = 45 to 3 mm at z = 62
        // start slightly inside the handle so the union is solidly fused
        translate([0, 0, handle_h - 0.01])
            cylinder(h = cone_top_z - handle_h + 0.01,
                     d1 = cone_d_bottom,
                     d2 = cone_d_top);

        // (3) Rounded tip: 3 mm sphere centred at z = 62
        translate([0, 0, tip_cz])
            sphere(d = tip_d);
    }

    // Grip grooves cut into the handle
    for (g = [0 : groove_count - 1]) {
        rotate([0, 0, g * 360 / groove_count])
            translate([0, -groove_w / 2, groove_z[g] - eps])
                cube([handle_d, groove_w, groove_w + 2 * eps]);
    }
}