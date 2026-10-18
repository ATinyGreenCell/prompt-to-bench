// Pestle for grinding tissue inside a 1.5 mL microcentrifuge tube
// Print orientation: standing upright on the bed, builds up +Z

$fn = 96;

// ---- Dimensions (mm) ----
handle_d      = 8;    // handle diameter
handle_h      = 45;   // handle height (z = 0 to 45)
cone_top_d    = 8;    // cone top diameter (at handle junction)
cone_tip_d    = 3;    // cone tip diameter (at z = 62)
tip_d         = 3;    // sphere tip diameter
tip_z         = 62;   // sphere centre height

groove_count  = 4;    // number of circumferential grooves
groove_w      = 2;    // groove width in Z
groove_depth  = 1;    // groove depth from outer surface
groove_z      = [10, 15, 20, 25]; // groove centre heights

eps           = 0.5;  // overshoot for clean cuts / unions

// ---- Model ----
difference() {
    union() {
        // Handle
        cylinder(d = handle_d, h = handle_h);

        // Cone (tapers from 8 mm at z = 45 to 3 mm at z = 62)
        translate([0, 0, 45])
            cylinder(d1 = handle_d, d2 = cone_tip_d, h = tip_z - 45);

        // Rounded tip (sphere centred at z = 62)
        translate([0, 0, tip_z])
            sphere(d = tip_d);
    }

    // Grip grooves
    for (z = groove_z)
        translate([0, 0, z - groove_w / 2])
            cylinder(d = handle_d + 2 * eps, h = groove_w);
}