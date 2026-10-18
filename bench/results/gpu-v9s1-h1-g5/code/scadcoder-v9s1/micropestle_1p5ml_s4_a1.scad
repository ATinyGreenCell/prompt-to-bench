// Pestle for 1.5 mL microcentrifuge tube
// Print orientation: standing upright on the bed (z = 0)

// ---------- Parameters ----------
handle_d      = 8;    // handle diameter (mm)
handle_h      = 45;   // handle height (mm), z = 0 to 45
cone_d        = 3;    // tip diameter (mm), reached at z = 62
tip_z         = 62;   // tip sphere centre height (mm)
tip_r         = cone_d / 2; // tip radius (mm)
groove_count  = 4;    // number of circumferential grooves
groove_w      = 2;    // groove width along Z (mm)
groove_depth  = 1;    // groove depth (mm)
groove_z      = [10, 15, 20, 25]; // groove centre heights (mm)
eps           = 0.5;  // overshoot for clean cuts (mm)

$fn = 96;

// ---------- Model ----------
difference() {
    union() {
        // Handle
        cylinder(d = handle_d, h = handle_h);

        // Cone: 8 mm diameter at z = 45 tapering to 3 mm at z = 62
        translate([0, 0, handle_h])
            cylinder(d1 = handle_d, d2 = cone_d, h = tip_z - handle_h);

        // Rounded tip: 3 mm diameter sphere centred at z = 62
        translate([0, 0, tip_z - tip_r])
            sphere(r = tip_r);
    }

    // Grip grooves, each extending past the faces it cuts
    for (g = [0 : groove_count - 1]) {
        z = groove_z[g];
        translate([0, 0, z - groove_w / 2 - eps])
            cylinder(d = handle_d + 2 * eps, h = groove_w + 2 * eps);
    }
}