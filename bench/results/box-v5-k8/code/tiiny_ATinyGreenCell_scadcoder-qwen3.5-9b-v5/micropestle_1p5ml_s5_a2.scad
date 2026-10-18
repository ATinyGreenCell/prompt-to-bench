// Pestle for grinding tissue inside a 1.5 mL microcentrifuge tube
// Print orientation: standing upright, handle at the bottom

// ---- Dimensions (mm) ----
handle_d        = 8;     // handle diameter
handle_top_z    = 45;     // top of handle / bottom of cone
cone_top_d      = 3;      // cone diameter at its top (tip of cone)
tip_r           = 3;      // radius of the rounded tip sphere
tip_centre_z    = 62;     // centre height of the tip sphere
groove_w        = 2;      // groove width (Z)
groove_depth    = 1;      // groove depth (into the handle)
groove_z        = [10, 15, 20, 25]; // groove centre heights
eps             = 0.5;    // cutter overshoot past faces

$fn = 96;

// ---- Model ----
difference() {
    union() {
        // (1) Cylindrical handle
        cylinder(d = handle_d, h = handle_top_z);

        // (2) Tapering cone: 8 mm at z = 45 to 3 mm at z = 62
        translate([0, 0, handle_top_z])
            cylinder(h = tip_centre_z - handle_top_z,
                     r1 = handle_d / 2,
                     r2 = cone_top_d / 2);

        // (3) Rounded tip: 3 mm diameter sphere centred at z = 62
        translate([0, 0, tip_centre_z])
            sphere(r = tip_r);
    }

    // Grip grooves, circumferential, 2 mm wide in Z and 1 mm deep
    for (gz = groove_z)
        translate([0, 0, gz])
            rotate([0, 90, 0])
                cylinder(h = groove_w, d = groove_depth * 2 + eps, $fn = 64);
}