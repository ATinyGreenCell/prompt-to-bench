// Pestle for grinding tissue in a 1.5 mL microcentrifuge tube
// Printed upright: handle at the bottom, tip pointing up.

$fn = 96;

// ---- Dimensions (mm) ----
handle_d      = 8;    // handle diameter
handle_h      = 45;   // handle height (z = 0 .. 45)
cone_top_d    = 8;    // cone diameter at its bottom
cone_bottom_d = 3;   // cone diameter at its top
cone_h        = 17;   // cone height (z = 45 .. 62)
tip_d         = 3;    // tip sphere diameter (centred at z = 62)
groove_w      = 2;    // groove width (in Z)
groove_depth  = 1;    // groove depth from the outer surface
groove_zs     = [10, 15, 20, 25]; // centre heights of the 4 grooves

eps           = 0.5;  // overshoot for clean boolean cuts

difference() {
    union() {
        // Handle
        cylinder(d = handle_d, h = handle_h);
        // Cone
        translate([0, 0, handle_h - 0.01])
            cylinder(d1 = cone_top_d, d2 = cone_bottom_d, h = cone_h + 0.01);
        // Rounded tip
        translate([0, 0, cone_h - 0.01])
            sphere(d = tip_d, center = [0, 0, handle_h + cone_h / 2]);
    }

    // Circumferential grooves for grip
    for (z = groove_zs)
        translate([0, 0, z])
            cylinder(d = handle_d + 2 * groove_depth, h = groove_w);
}