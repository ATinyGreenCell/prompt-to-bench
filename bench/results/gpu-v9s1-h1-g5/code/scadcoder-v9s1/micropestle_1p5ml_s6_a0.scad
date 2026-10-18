// Pestle for grinding tissue inside a 1.5 mL microcentrifuge tube
// Print orientation: standing upright on the bed (z = 0)

// ---------------- Parameters ----------------
handle_d      = 8;    // handle diameter (mm), z = 0 .. 45
handle_h      = 45;   // handle height (mm)
cone_top_d    = 8;    // cone diameter at top (mm), z = 45
cone_tip_d    = 3;    // cone diameter at tip (mm), z = 62
sphere_d      = 3;    // tip sphere diameter (mm), centred at z = 62
groove_count  = 4;    // number of circumferential grooves
groove_w      = 2;    // groove width (mm), measured in Z
groove_depth  = 1;    // groove depth (mm)
groove_z      = [10, 15, 20, 25]; // groove centre heights (mm)
eps           = 0.5;  // overshoot for clean boolean cuts (mm)

$fn = 96;             // curve resolution

// ---------------- Model ----------------
difference() {
    union() {
        // (1) Cylindrical handle
        cylinder(d = handle_d, h = handle_h);

        // (2) Tapering cone: 8 mm at z = 45 down to 3 mm at z = 62
        translate([0, 0, 45])
            cylinder(d1 = cone_top_d, d2 = cone_tip_d, h = 62 - 45);

        // (3) Rounded tip: 3 mm sphere centred at z = 62
        translate([0, 0, 62])
            sphere(d = sphere_d);
    }

    // Grip grooves, cut through the handle wall
    // Each groove runs around the axis, 2 mm tall and 1 mm deep
    for (z = groove_z)
        translate([0, 0, z - groove_w / 2])
            rotate([0, 90, 0])
                cylinder(d = handle_d + 2 * eps, h = groove_depth, center = true);
}