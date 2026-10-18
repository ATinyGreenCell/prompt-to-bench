// Tissue-grinding pestle for a 1.5 mL microcentrifuge tube
// Print orientation: standing upright on the bed (z = 0), building upward.

// ---------------- Parameters ----------------
handle_d      = 8;    // handle diameter (mm)
handle_h      = 45;   // handle height (mm), z = 0 to 45
cone_top_d    = 8;    // cone diameter at the handle/cone junction (z = 45)
cone_bottom_d = 3;    // cone diameter at its apex (z = 62)
cone_h        = 17;   // cone height (mm), 62 - 45
tip_r         = 1.5;  // rounded tip radius (mm), 3 mm diameter
tip_h         = 1.5;  // tip height (mm), z = 62 to 63.5
groove_count  = 4;    // number of circumferential grip grooves
groove_w      = 2;    // groove width (mm) along Z
groove_depth  = 1;    // groove depth (mm) into the handle wall
groove_z      = [10, 15, 20, 25]; // groove centre heights (mm)
eps           = 0.5;  // overshoot for clean boolean cuts (mm)

$fn = 96;             // smoothness of curved surfaces

// ---------------- Model ----------------
difference() {
    // Main body: handle + cone + rounded tip
    union() {
        // Handle: z = 0 to 45
        cylinder(d = handle_d, h = handle_h);

        // Cone: z = 45 to 62 (apex at cone_bottom_d)
        translate([0, 0, handle_h])
            cylinder(d1 = cone_top_d, d2 = cone_bottom_d, h = cone_h);

        // Rounded tip: z = 62 to 63.5
        translate([0, 0, handle_h + cone_h - tip_h])
            cylinder(r = tip_r, h = tip_h, $fn = 96);
    }

    // Grip grooves cut into the handle wall
    for (g = [0 : groove_count - 1]) {
        translate([0, 0, groove_z[g] - groove_w / 2])
            cylinder(d = handle_d + 2 * eps, h = groove_w);
    }
}