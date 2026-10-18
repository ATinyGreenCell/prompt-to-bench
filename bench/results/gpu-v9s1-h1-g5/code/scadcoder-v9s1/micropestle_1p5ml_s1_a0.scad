// Pestle for grinding tissue inside a 1.5 mL microcentrifuge tube
// Printed standing upright (z = 0 at the bottom)

// ---------------- Parameters ----------------
handle_d      = 8;    // handle diameter (mm)
handle_h      = 45;   // handle height (mm), z = 0 to 45
cone_top_d    = 8;    // cone base diameter at z = 45 (mm)
cone_tip_d    = 3;    // cone tip diameter at z = 62 (mm)
cone_top_z    = 45;   // cone top / handle top (mm)
cone_tip_z    = 62;   // cone tip / sphere centre (mm)
tip_d         = 3;    // rounded tip diameter (mm)
groove_count  = 4;    // number of circumferential grooves
groove_w      = 2;    // groove width (mm), in Z
groove_depth  = 1;    // groove depth (mm)
groove_z      = [10, 15, 20, 25]; // groove centre heights (mm)
eps           = 0.5;  // overshoot for clean boolean cuts (mm)

$fn = 96;             // curve resolution

// ---------------- Model ----------------
difference() {
    union() {
        // (1) Cylindrical handle
        cylinder(d = handle_d, h = handle_h);

        // (2) Cone: tapers from 8 mm at z = 45 to 3 mm at z = 62
        translate([0, 0, cone_top_z])
            cylinder(d1 = cone_top_d, d2 = cone_tip_d, h = cone_tip_z - cone_top_z);

        // (3) Rounded tip: 3 mm sphere centred at z = 62
        translate([0, 0, cone_tip_z])
            sphere(d = tip_d);
    }

    // Grip grooves, cut through the handle wall
    for (z = groove_z)
        translate([0, 0, z - groove_w / 2])
            rotate([0, 90, 0])
                cylinder(d = groove_depth + eps, h = groove_w + eps);
}