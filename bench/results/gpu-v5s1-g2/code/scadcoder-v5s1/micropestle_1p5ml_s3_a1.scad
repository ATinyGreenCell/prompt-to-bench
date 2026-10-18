// Pestle for grinding tissue in a 1.5 mL microcentrifuge tube
// Print orientation: standing upright, handle at the bottom

// ---------------- Parameters ----------------
handle_d        = 8;     // handle diameter (mm)
handle_h        = 45;    // handle height, z = 0 to 45 (mm)
cone_start_d    = 8;     // cone diameter at z = 45 (mm)
cone_end_d      = 3;     // cone diameter at z = 62 (mm)
cone_top_z      = 62;    // cone top height (mm)
tip_d           = 3;     // rounded tip diameter (mm)
tip_centre_z    = 62;    // tip sphere centre height (mm)
groove_count    = 4;     // number of circumferential grooves
groove_w        = 2;     // groove width in Z (mm)
groove_depth    = 1;     // groove depth from surface (mm)
groove_z        = [10, 15, 20, 25]; // groove centre heights (mm)
eps             = 0.5;   // cutter overshoot past faces (mm)
$fn             = 96;    // curve resolution

// ---------------- Model ----------------
difference() {
    union() {
        // (1) Cylindrical handle
        cylinder(d = handle_d, h = handle_h);

        // (2) Tapering cone
        translate([0, 0, handle_h])
            cylinder(d1 = cone_start_d, d2 = cone_end_d, h = cone_top_z - handle_h);

        // (3) Rounded tip sphere
        translate([0, 0, tip_centre_z])
            sphere(d = tip_d);
    }

    // Grip grooves, each extending past the top and bottom faces
    for (z = groove_z)
        translate([0, 0, z - groove_w / 2])
            cylinder(d = handle_d + 2 * groove_depth, h = groove_w + 2 * eps, $fn = 64);
}