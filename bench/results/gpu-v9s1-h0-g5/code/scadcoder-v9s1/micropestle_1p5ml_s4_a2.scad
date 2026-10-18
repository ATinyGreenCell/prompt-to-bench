// Pestle for grinding tissue inside a 1.5 mL microcentrifuge tube
// Printed standing upright: handle at the bottom, cone and tip on top.

$fn = 96;

// ---- Dimensions (mm) ----
handle_d      = 8;     // handle diameter (z = 0 to 45)
handle_h      = 45;    // handle height
cone_top_d    = 8;     // cone diameter at top of handle (z = 45)
cone_bottom_d = 3;     // cone diameter at bottom (z = 62)
sphere_d      = 3;     // tip sphere diameter
tip_z         = 62;    // sphere centre height
groove_count  = 4;     // number of circumferential grooves
groove_w      = 2;     // groove width in Z
groove_depth  = 1;     // groove depth from surface
overlap       = 0.5;   // overlap between adjacent groove blocks

// ---- Model ----
difference() {
    union() {
        // Handle
        cylinder(d = handle_d, h = handle_h);
        // Cone (tapers over a short stub to avoid a sharp edge)
        translate([0, 0, handle_h - 0.5])
            cylinder(d1 = cone_top_d, d2 = cone_bottom_d, h = 1.5);
        // Tip sphere
        translate([0, 0, tip_z])
            sphere(d = sphere_d);
    }
    // Grooves, centred at z = 10, 15, 20, 25
    for (i = [0 : groove_count - 1]) {
        z = 10 + i * 5;
        translate([0, 0, z - groove_w / 2])
            cylinder(d = handle_d + 2 * groove_depth, h = groove_w, $fn = 96);
    }
}