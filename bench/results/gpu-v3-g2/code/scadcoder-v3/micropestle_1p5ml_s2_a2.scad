// Pestle for grinding tissue in a 1.5 mL microcentrifuge tube
// Printed upright: handle at the bottom, tip pointing up.

$fn = 96;

// ---- Dimensions (mm) ----
handle_d      = 8;    // handle diameter
handle_top_z  = 45;   // handle height / cone start
tip_min_d     = 3;    // cone tip diameter / sphere diameter
tip_centre_z  = 62;   // sphere centre height
groove_count  = 4;    // number of circumferential grooves
groove_w      = 2;    // groove width (Z)
groove_d      = 1;    // groove depth from outer surface
groove_zs     = [10, 15, 20, 25]; // groove centre heights

eps           = 0.5;  // cutter overshoot

difference() {
    union() {
        // Handle
        cylinder(d = handle_d, h = handle_top_z);
        // Cone
        translate([0, 0, handle_top_z])
            cylinder(d1 = handle_d, d2 = tip_min_d, h = tip_centre_z - handle_top_z);
        // Rounded tip
        translate([0, 0, tip_centre_z - 1.5])
            sphere(d = tip_min_d);
    }

    // Grip grooves
    for (z = groove_zs)
        translate([0, 0, z])
            cylinder(d = handle_d + 2 * groove_d, h = groove_w, $fn = 96);
}