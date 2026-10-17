// Pestle for grinding tissue in a 1.5 mL microcentrifuge tube
// Printed upright: handle at the bottom, tip pointing up.

$fn = 96;

// ---- Dimensions (mm) ----
handle_d      = 8;    // handle diameter
handle_h      = 45;   // handle height (z = 0 .. 45)
cone_h        = 17;   // cone height (z = 45 .. 62)
cone_top_d    = 3;    // cone tip diameter
tip_d         = 3;    // rounded tip diameter
groove_count  = 4;    // number of circumferential grooves
groove_w      = 2;    // groove width (Z)
groove_depth  = 1;    // groove depth from outer surface
groove_zs     = [10, 15, 20, 25]; // groove centre heights

eps           = 0.5;  // overcut for clean differences

difference() {
    union() {
        // Handle
        cylinder(d = handle_d, h = handle_h);
        // Cone
        translate([0, 0, handle_h])
            cylinder(d1 = handle_d, d2 = cone_top_d, h = cone_h);
        // Rounded tip (overlaps slightly into cone for a smooth blend)
        translate([0, 0, handle_h + cone_h - 0.01])
            sphere(d = tip_d);
    }

    // Grip grooves
    for (z = groove_zs)
        translate([0, 0, z])
            cylinder(d = handle_d + 2 * eps, h = groove_w);
}