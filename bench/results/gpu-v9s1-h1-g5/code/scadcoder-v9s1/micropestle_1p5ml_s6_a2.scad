// Pestle for grinding tissue inside a 1.5 mL microcentrifuge tube
// Print orientation: standing upright (handle on bed)

// ---------- Dimensions ----------
handle_d      = 8;    // handle diameter
handle_h      = 45;   // handle height (z = 0 to 45)
cone_top_d    = 8;    // cone diameter at top (z = 45)
cone_tip_d    = 3;    // cone diameter at tip (z = 62)
sphere_d      = 3;    // tip sphere diameter
tip_z         = 62;   // sphere centre height
groove_count  = 4;    // number of circumferential grooves
groove_w      = 2;    // groove width in Z
groove_depth  = 1;    // groove depth from surface
eps           = 0.5;  // overshoot for clean cuts

$fn = 96;

// ---------- Model ----------
difference() {
    union() {
        // Handle
        cylinder(d = handle_d, h = handle_h);
        // Cone (z = 45 to 62)
        translate([0, 0, handle_h])
            cylinder(d1 = cone_top_d, d2 = cone_tip_d, h = tip_z - handle_h);
        // Tip sphere
        translate([0, 0, tip_z])
            sphere(d = sphere_d);
    }
    // Grooves, centred at z = 10, 15, 20, 25
    for (i = [0 : groove_count - 1]) {
        z = 10 + i * 5 - groove_w / 2;
        translate([0, 0, z])
            rotate([0, 90, 0])
                cylinder(d = groove_depth + eps, h = handle_d + 2 * eps);
    }
}