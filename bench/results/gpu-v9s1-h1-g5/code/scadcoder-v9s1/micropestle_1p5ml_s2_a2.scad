// Pestle for grinding tissue inside a 1.5 mL microcentrifuge tube
// Print orientation: standing upright on the bed (z = 0)

// ---------------- Parameters ----------------
handle_d      = 8;    // handle diameter (mm)
handle_h      = 45;   // handle height (mm), z = 0 to 45

cone_top_d    = 8;    // cone diameter at handle junction (mm)
cone_bottom_d = 3;    // cone diameter at tip top (mm)
cone_h        = 17;   // cone height (mm), z = 45 to 62

tip_r         = 3;    // rounded tip radius (mm), centred at z = 62
tip_h         = 6;    // tip height above centre (mm)

groove_count  = 4;    // number of circumferential grooves
groove_w      = 2;    // groove width (mm), in Z
groove_depth  = 1;    // groove depth (mm)
groove_z      = [10, 15, 20, 25]; // groove centre heights (mm)

eps           = 0.5;  // overshoot for clean cuts (mm)

$fn = 96;             // curve resolution

// ---------------- Model ----------------
difference() {
    union() {
        // Handle
        cylinder(d = handle_d, h = handle_h);

        // Cone: from handle diameter down to tip top diameter
        translate([0, 0, handle_h])
            cylinder(d1 = cone_top_d, d2 = cone_bottom_d, h = cone_h);

        // Rounded tip: sphere centred at z = 62
        translate([0, 0, tip_h])
            sphere(r = tip_r);
    }

    // Grooves cut into the handle, extended past the faces they span
    for (i = [0 : groove_count - 1]) {
        z = groove_z[i];
        translate([0, 0, z - eps])
            cylinder(d = groove_depth, h = groove_w + 2 * eps);
    }
}