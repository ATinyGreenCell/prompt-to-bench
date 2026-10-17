// Pestle for grinding tissue inside a 1.5 mL microcentrifuge tube
// Print orientation: standing upright, handle on the bed (z = 0)

// ---------------- Parameters ----------------
handle_d      = 8;    // handle diameter (mm)
handle_h      = 45;   // handle height (mm), z = 0 .. 45
cone_h        = 17;   // cone height (mm), z = 45 .. 62
tip_d         = 3;    // tip diameter (mm), sphere centred at z = 62
groove_count  = 4;    // number of circumferential grooves
groove_w      = 2;    // groove width (mm) in Z
groove_depth  = 1;    // groove depth (mm) into handle
groove_z      = [10, 15, 20, 25]; // groove centre heights (mm)
eps           = 0.5;  // cutter overshoot past faces (mm)
$fn           = 96;   // curve resolution

// ---------------- Model ----------------
difference() {
    union() {
        // (1) Cylindrical handle
        cylinder(d = handle_d, h = handle_h);

        // (2) Tapered cone: 8 mm at z = 45 to 3 mm at z = 62
        translate([0, 0, handle_h])
            cylinder(d1 = handle_d, d2 = tip_d, h = cone_h);

        // (3) Rounded tip: 3 mm diameter sphere centred at z = 62
        translate([0, 0, handle_h + cone_h])
            sphere(d = tip_d);
    }

    // Grip grooves, cut through the full diameter, centred at specified z
    for (z = groove_z)
        translate([0, 0, z])
            rotate([0, 90, 0])
                cylinder(d = groove_w, h = handle_d + 2 * eps, center = true);
}