// Pestle for grinding tissue inside a 1.5 mL microcentrifuge tube
// Print orientation: standing upright, handle at the bottom

// ---- Dimensions (mm) ----
handle_d        = 8;     // handle diameter
handle_top_z    = 45;     // z where handle ends / cone begins
cone_top_d      = 3;      // cone diameter at its top (z = 62)
tip_d           = 3;      // sphere diameter for the rounded tip
tip_centre_z    = 62;     // sphere centre height
groove_w        = 2;      // groove width (Z)
groove_depth    = 1;      // groove depth (into the handle)
groove_z        = [10, 15, 20, 25]; // groove centre heights
eps             = 0.5;    // cutter overshoot past faces

$fn = 96;

// ---- Model ----
difference() {
    union() {
        // (1) Cylindrical handle, z = 0 to 45
        cylinder(d = handle_d, h = handle_top_z);

        // (2) Cone, z = 45 to 62 (8 mm -> 3 mm)
        translate([0, 0, handle_top_z])
            cylinder(d1 = handle_d, d2 = cone_top_d, h = tip_centre_z - handle_top_z);

        // (3) Rounded tip: 3 mm sphere centred at z = 62
        translate([0, 0, tip_centre_z])
            sphere(d = tip_d);
    }

    // Grip grooves, circumferential, 2 mm wide, 1 mm deep
    for (gz = groove_z)
        translate([0, 0, gz])
            rotate([0, 90, 0])
                cylinder(d = groove_depth, h = groove_w, $fn = 96);
}