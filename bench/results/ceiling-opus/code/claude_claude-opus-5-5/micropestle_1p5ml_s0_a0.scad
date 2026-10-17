// Pestle for 1.5 mL microcentrifuge tube - printed upright
$fn = 96;

// Handle
handle_d      = 8;    // handle diameter
handle_h      = 45;   // handle top z

// Cone
cone_top_d    = 3;    // cone diameter at top
cone_top_z    = 62;   // cone top z

// Tip
tip_d         = 3;    // tip sphere diameter (centred at cone_top_z)

// Grip grooves
groove_w      = 2;    // groove width in Z
groove_depth  = 1;    // groove radial depth
groove_z      = [10, 15, 20, 25]; // groove centre heights

eps = 0.5;            // overcut for clean differences

difference() {
    union() {
        // (1) Handle
        cylinder(d = handle_d, h = handle_h);
        // (2) Cone
        translate([0, 0, handle_h])
            cylinder(d1 = handle_d, d2 = cone_top_d, h = cone_top_z - handle_h);
        // (3) Rounded tip
        translate([0, 0, cone_top_z])
            sphere(d = tip_d);
    }
    // Circumferential grip grooves
    for (z = groove_z)
        translate([0, 0, z - groove_w / 2])
            difference() {
                cylinder(d = handle_d + 2 * eps, h = groove_w);
                translate([0, 0, -eps])
                    cylinder(d = handle_d - 2 * groove_depth, h = groove_w + 2 * eps);
            }
}