// Pestle for 1.5 mL microcentrifuge tube (print upright, handle at bottom)

$fn = 64;

handle_d      = 8;    // handle diameter
handle_h      = 45;   // handle height (z = 0 to 45)
cone_top_d    = 3;    // cone diameter at top
cone_top_z    = 62;   // z at top of cone
tip_d         = 3;    // spherical tip diameter
tip_z         = 62;   // sphere centre z
groove_w      = 2;    // groove width (Z)
groove_depth  = 1;    // groove radial depth
groove_zs     = [10, 15, 20, 25]; // groove centre heights

eps = 0.5;            // cutter overshoot

difference() {
    union() {
        // handle
        cylinder(d = handle_d, h = handle_h);
        // tapered cone
        translate([0, 0, handle_h])
            cylinder(d1 = handle_d, d2 = cone_top_d, h = cone_top_z - handle_h);
        // rounded tip
        translate([0, 0, tip_z])
            sphere(d = tip_d);
    }

    // circumferential grooves
    for (z = groove_zs)
        translate([0, 0, z - groove_w / 2])
            difference() {
                cylinder(d = handle_d + 2 * eps, h = groove_w);
                translate([0, 0, -0.01])
                    cylinder(d = handle_d - 2 * groove_depth, h = groove_w + 0.02);
            }
}