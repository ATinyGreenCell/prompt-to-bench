// Pestle for grinding tissue inside a 1.5 mL microcentrifuge tube
// Print orientation: standing upright, handle at the bottom

// ---- Dimensions (mm) ----
handle_d        = 8;     // handle diameter
handle_top_z    = 45;    // top of handle / start of cone
cone_top_d      = 3;     // cone diameter at tip
sphere_d        = 3;     // tip sphere diameter
groove_w        = 2;     // groove width (Z)
groove_depth    = 1;     // groove depth (radial)
groove_centres  = [10, 15, 20, 25]; // groove centre heights
eps             = 0.5;   // cutter overshoot past faces

$fn = 96;

// ---- Model ----
difference() {
    union() {
        // Handle
        cylinder(d = handle_d, h = handle_top_z);
        // Cone (8 mm -> 3 mm over 45..62 mm)
        translate([0, 0, handle_top_z])
            cylinder(d1 = handle_d, d2 = cone_top_d, h = handle_top_z + 17);
        // Rounded tip: 3 mm sphere centred at z = 62
        translate([0, 0, handle_top_z + 17])
            sphere(d = sphere_d);
    }

    // Grip grooves, cut fully through the handle
    for (z = groove_centres)
        translate([0, 0, z])
            cylinder(d = handle_d + 2 * eps, h = groove_w, depth = groove_depth);
}