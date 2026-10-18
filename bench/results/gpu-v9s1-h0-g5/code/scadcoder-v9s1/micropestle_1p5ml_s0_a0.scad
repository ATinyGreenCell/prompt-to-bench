// Pestle for grinding tissue inside a 1.5 mL microcentrifuge tube
// Print orientation: standing upright on the XY plane, building up +Z

// ---------------- Parameters ----------------
handle_d      = 8;    // handle diameter (mm), z = 0 to 45
handle_h      = 45;   // handle height (mm)
cone_top_d    = 8;    // cone top diameter at z = handle_h (mm)
cone_bottom_d = 3;    // cone tip diameter at z = 62 (mm)
cone_h        = 17;   // cone height (mm), z = 45 to 62
tip_d         = 3;    // sphere tip diameter (mm), centred at z = 62
tip_z         = 62;   // sphere centre height (mm)
groove_count  = 4;    // number of circumferential grooves
groove_w      = 2;    // groove width (mm), in Z
groove_depth  = 1;    // groove depth (mm)
groove_z      = [10, 15, 20, 25]; // groove centre heights (mm)
eps           = 0.5;  // cutter overshoot past faces (mm)

$fn = 96;

// ---------------- Model ----------------
difference() {
    union() {
        // (1) Cylindrical handle
        cylinder(d = handle_d, h = handle_h);

        // (2) Cone: 8 mm at z = 45 tapering to 3 mm at z = 62
        translate([0, 0, handle_h])
            cylinder(d1 = cone_top_d, d2 = cone_bottom_d, h = cone_h);

        // (3) Rounded tip: 3 mm sphere centred at z = 62
        translate([0, 0, tip_z])
            sphere(d = tip_d);
    }

    // Grip grooves, cut through the handle (extend past top face)
    for (z = groove_z)
        translate([0, 0, z])
            rotate([0, 90, 0])
                cylinder(d = groove_w, h = groove_depth, center = true);
}