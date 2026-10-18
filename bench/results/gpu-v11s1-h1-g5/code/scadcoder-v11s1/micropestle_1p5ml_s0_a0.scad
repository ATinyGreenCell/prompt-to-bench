// Tissue-pestle for 1.5 mL microcentrifuge tube
// Print orientation: standing upright on the bed (z = 0), building up in +Z.

// ---------------- Parameters ----------------
handle_d      = 8;    // handle diameter (mm)
handle_h      = 45;   // handle height, z = 0 .. 45 (mm)

cone_top_d    = 8;    // cone diameter at z = 45 (mm)
cone_bottom_d = 3;    // cone diameter at z = 62 (mm)
cone_top_z    = 45;   // cone top height (mm)
cone_bottom_z = 62;   // cone bottom height (mm)

tip_d         = 3;    // rounded tip diameter (mm)
tip_cz        = 62;   // tip sphere centre height (mm)

groove_count  = 4;    // number of circumferential grip grooves
groove_w      = 2;    // groove width (mm)
groove_depth  = 1;    // groove depth (mm)
groove_z      = [10, 15, 20, 25]; // groove centre heights (mm)

eps           = 0.5;  // cutter overshoot past faces (mm)
$fn           = 96;   // curve resolution

// ---------------- Model ----------------
difference() {
    union() {
        // (1) Cylindrical handle
        cylinder(d = handle_d, h = handle_h);

        // (2) Tapered cone: 8 mm at z = 45 down to 3 mm at z = 62
        translate([0, 0, cone_top_z])
            cylinder(h = cone_bottom_z - cone_top_z, d1 = cone_top_d, d2 = cone_bottom_d);

        // (3) Rounded tip: 3 mm sphere centred at z = 62
        translate([0, 0, tip_cz])
            sphere(d = tip_d);
    }

    // Grip grooves cut into the handle, circumferential around Z
    for (z = groove_z)
        translate([0, 0, z])
            linear_extrude(height = groove_w)
                circle(d = groove_depth * 2);
}