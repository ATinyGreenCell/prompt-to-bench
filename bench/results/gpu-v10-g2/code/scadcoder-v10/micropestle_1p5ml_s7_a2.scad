// Tissue-pestle for 1.5 mL microcentrifuge tubes
// Print orientation: standing upright on the bed (z = 0), centred on the origin in X and Y.
// Units: millimetres.

$fn = 96;

// ---- Dimensions ----
handle_d      = 8;    // handle diameter (also cone base diameter)
handle_h      = 45;   // handle height (z = 0 to z = 45)
cone_d        = 3;    // cone tip diameter (at z = 62)
cone_top_z    = 62;   // z where the cone meets the rounded tip
tip_d         = 3;    // rounded tip diameter (sphere)
tip_z         = 62;   // sphere centre height (z = cone_top_z)
groove_count  = 4;    // number of circumferential grooves on the handle
groove_w      = 2;    // groove width (in Z)
groove_depth  = 1;    // groove depth (in radial thickness / X)
groove_z      = [10, 15, 20, 25]; // groove centre heights
eps           = 0.5;  // overshoot for clean boolean cuts

// ---- Model ----
difference() {
    union() {
        // (1) Cylindrical handle
        cylinder(d = handle_d, h = handle_h);

        // (2) Tapering cone: 8 mm at z = 45 -> 3 mm at z = 62
        translate([0, 0, handle_h])
            cylinder(d1 = handle_d, d2 = cone_d, h = cone_top_z - handle_h);

        // (3) Rounded tip: 3 mm diameter sphere centred at z = 62
        translate([0, 0, tip_z - tip_d / 2])
            sphere(d = tip_d);
    }

    // Grip grooves, cut fully through the handle wall
    for (g = [0 : groove_count - 1]) {
        rotate([0, 0, groove_z[g] < 20 ? 90 : -90])
            translate([0, -eps, groove_z[g]])
                cube([handle_d / 2 + eps, groove_w, handle_h + 2 * eps]);
    }
}