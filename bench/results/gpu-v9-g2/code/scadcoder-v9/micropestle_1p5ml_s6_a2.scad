// Pestle for grinding tissue inside a 1.5 mL microcentrifuge tube
// Print orientation: standing upright on the bed (z = 0)

$fn = 96;

// ---- Dimensions (mm) ----
handle_d      = 8;    // handle diameter
handle_h      = 45;   // handle height (z = 0 to 45)
cone_d_bottom = 8;    // cone diameter at bottom (z = 45)
cone_d_top    = 3;    // cone diameter at top (z = 62)
tip_r         = 1.5;  // tip sphere radius (centred at z = 62)
groove_w      = 2;    // groove width in Z
groove_d      = 1;    // groove depth
groove_z      = [10, 15, 20, 25]; // groove centre heights

eps = 0.5;            // overshoot for clean cuts

// ---- Model ----
difference() {
    union() {
        // Handle
        cylinder(d = handle_d, h = handle_h);
        // Cone (slight overlap into handle for a clean union)
        translate([0, 0, handle_h - eps])
            cylinder(d1 = cone_d_bottom, d2 = cone_d_top, h = cone_d_top + eps);
        // Tip sphere
        translate([0, 0, tip_r])
            sphere(r = tip_r);
    }
    // Grooves
    for (i = [0 : 3]) {
        rotate([0, 0, i * 90])
            translate([0, -groove_d, groove_z[i]])
                cube([handle_d + 2 * eps, groove_w, eps]);
    }
}