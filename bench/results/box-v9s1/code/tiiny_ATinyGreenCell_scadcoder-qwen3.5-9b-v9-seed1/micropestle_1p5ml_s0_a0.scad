// Pestle for 1.5 mL microcentrifuge tube
// Print orientation: standing upright on the bed (z = 0)

// ---- Dimensions (mm) ----
handle_d      = 8;     // handle diameter (z = 0 to 45)
handle_h      = 45;    // handle height
cone_top_d    = 8;     // cone diameter at z = 45
cone_bottom_d = 3;     // cone diameter at z = 62
cone_h        = 17;    // cone height (62 - 45)
tip_d         = 3;     // sphere tip diameter
tip_z         = 62;    // sphere centre height
eps           = 0.5;   // cutter overshoot

$fn = 64;

// ---- Model ----
difference() {
    union() {
        // Handle
        cylinder(d = handle_d, h = handle_h);
        // Cone
        translate([0, 0, handle_h])
            cylinder(d1 = cone_top_d, d2 = cone_bottom_d, h = cone_h);
        // Rounded tip
        translate([0, 0, tip_z])
            sphere(d = tip_d);
    }
    // Grip grooves
    for (g = [10, 15, 20, 25])
        translate([0, 0, g - eps])
            cylinder(d = handle_d + 2 * eps, h = eps, $fn = 64);
}