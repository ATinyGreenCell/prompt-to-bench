// Pestle for grinding tissue inside a 1.5 mL microcentrifuge tube
// Print orientation: standing upright, handle at the bottom

// ---------------- Parameters ----------------
handle_d      = 8;     // handle diameter
handle_h      = 45;    // handle height (z = 0 to 45)

cone_top_d    = 8;     // cone diameter at top of handle (z = 45)
cone_bottom_d = 3;     // cone diameter at tip base (z = 62)
cone_h        = 17;    // cone height (62 - 45)

tip_d         = 3;     // sphere tip diameter
tip_z         = 62;    // sphere centre height

groove_d      = 2;     // groove width in Z
groove_depth  = 1;     // groove depth into handle
groove_z      = [10, 15, 20, 25]; // groove centre heights

eps           = 0.5;   // cutter overshoot past faces
$fn           = 96;    // curve resolution

// ---------------- Model ----------------
difference() {
    union() {
        // Handle: cylinder from z = 0 to 45
        cylinder(d = handle_d, h = handle_h);

        // Cone: 8 mm at z = 45 tapering to 3 mm at z = 62
        translate([0, 0, handle_h])
            cylinder(d1 = cone_top_d, d2 = cone_bottom_d, h = cone_h);

        // Rounded tip: 3 mm sphere centred at z = 62
        translate([0, 0, tip_z])
            sphere(d = tip_d);
    }

    // Grip grooves: circumferential cuts into the handle
    for (gz = groove_z)
        translate([0, 0, gz])
            cylinder(d = handle_d + 2 * eps, h = groove_d, depth = groove_depth);
}