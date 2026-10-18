// Pestle for grinding tissue inside a 1.5 mL microcentrifuge tube
// Print orientation: standing upright on the bed (z = 0), centred on the origin in X and Y.
// Units: millimetres.

// ---------------- Parameters ----------------
handle_d      = 8;    // handle diameter (also cone base diameter)
handle_h      = 45;   // handle height (z = 0 to z = 45)
cone_d        = 3;    // cone tip diameter (at z = 62)
cone_top_z    = 62;   // z where the cone meets the rounded tip
tip_d         = 3;    // rounded tip diameter (sphere)
tip_z         = 62;   // sphere centre height (z = cone_top_z)

groove_count  = 4;    // number of circumferential grooves on the handle
groove_w      = 2;    // groove width (in Z)
groove_depth  = 1;    // groove depth (in radial direction)
groove_z      = [10, 15, 20, 25]; // groove centre heights

eps           = 0.5;  // overshoot for clean boolean cuts
$fn           = 96;   // curve resolution

// ---------------- Model ----------------
difference() {
    union() {
        // (1) Cylindrical handle: z = 0 to z = 45
        cylinder(d = handle_d, h = handle_h);

        // (2) Tapering cone: diameter 8 at z = 45, down to 3 at z = 62
        translate([0, 0, handle_h])
            cylinder(d1 = handle_d, d2 = cone_d, h = cone_top_z - handle_h);

        // (3) Rounded tip: 3 mm diameter sphere centred at z = 62
        translate([0, 0, tip_z - tip_d / 2])
            sphere(d = tip_d);
    }

    // Grip grooves: circumferential cuts into the handle
    for (g = groove_count - 1) {
        translate([0, 0, groove_z[g]])
            rotate([0, 90, 0])
                cylinder(d = groove_depth, h = groove_w, center = true);
    }
}