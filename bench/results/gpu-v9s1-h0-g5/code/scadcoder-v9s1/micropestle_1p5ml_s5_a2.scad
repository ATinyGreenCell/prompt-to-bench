// Pestle for grinding tissue inside a 1.5 mL microcentrifuge tube
// Printed standing upright: handle at the bottom, rounded tip at the top

// ---------- Dimensions (mm) ----------
handle_d      = 8;     // handle diameter
handle_h      = 45;    // handle length (z = 0 to 45)
cone_top_d    = 8;     // cone diameter where it meets the handle (z = 45)
cone_bottom_d = 3;     // cone diameter at its tip (z = 62)
cone_h        = 17;    // cone height (z = 45 to 62)
tip_r         = 3;     // tip sphere radius, centred at z = 62
groove_w      = 2;     // groove width along Z
groove_depth  = 1;     // groove depth into the handle wall
groove_z      = [10, 15, 20, 25]; // groove centre heights
eps           = 0.5;   // overshoot for clean boolean cuts

$fn = 96;

// ---------- Model ----------
difference() {
    union() {
        // Handle
        cylinder(d = handle_d, h = handle_h);
        // Cone (tapers from 8 mm at z = 45 to 3 mm at z = 62)
        translate([0, 0, handle_h])
            cylinder(d1 = cone_top_d, d2 = cone_bottom_d, h = cone_h);
        // Tip sphere
        translate([0, 0, cone_bottom_d])
            sphere(r = tip_r);
    }

    // Grooves, extended past the faces they cut
    for (z = groove_z)
        translate([0, 0, z - eps])
            cylinder(d = handle_d + 2 * eps, h = groove_w + 2 * eps);
}