// Pestle for grinding tissue inside a 1.5 mL microcentrifuge tube
// Printed standing upright: handle at the bottom, tip at the top

// ---- Dimensions (mm) ----
handle_d      = 8;    // handle diameter
handle_h      = 45;   // handle height (z = 0 to 45)
cone_top_d    = 8;    // cone base diameter (at z = 45)
cone_tip_d    = 3;    // cone tip diameter (at z = 62)
cone_top_z    = 62;   // z where cone meets sphere
tip_d         = 3;    // sphere tip diameter
tip_z         = 62;   // sphere centre height
groove_count  = 4;    // number of circumferential grooves
groove_w      = 2;    // groove width in Z
groove_depth  = 1;    // groove depth from surface
groove_z      = [10, 15, 20, 25]; // groove centre heights

// ---- Modelling helpers ----
eps = 0.5;            // overshoot for clean boolean cuts
$fn = 96;             // curve resolution

// ---- Part ----
difference() {
    union() {
        // Handle
        cylinder(d = handle_d, h = handle_h);
        // Cone (tapers from 8 mm at z = 45 to 3 mm at z = 62)
        translate([0, 0, handle_h])
            cylinder(d1 = cone_top_d, d2 = cone_tip_d, h = cone_top_z - handle_h);
        // Rounded tip: 3 mm sphere centred at z = 62
        translate([0, 0, tip_z])
            sphere(d = tip_d);
    }
    // Grip grooves, cut through the handle only
    for (z = groove_z)
        translate([0, 0, z - groove_w / 2])
            cylinder(d = handle_d + 2 * eps, h = groove_w);
}