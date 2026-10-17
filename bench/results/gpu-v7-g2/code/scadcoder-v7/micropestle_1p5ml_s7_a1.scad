// Pestle for 1.5 mL microcentrifuge tube
// Print orientation: standing upright, handle on the bed

// ---- Dimensions (mm) ----
handle_d      = 8;     // handle diameter
handle_h      = 45;    // handle height (z = 0 to 45)
cone_start_d  = 8;     // cone diameter at z = 45
cone_end_d    = 3;     // cone diameter at z = 62
cone_h        = 17;    // cone height (62 - 45)
tip_d         = 3;     // tip sphere diameter
tip_z         = 62;    // tip sphere centre height
groove_w      = 2;     // groove width (Z)
groove_depth  = 1;     // groove depth from surface
groove_z      = [10, 15, 20, 25]; // groove centre heights
overcut       = 0.5;   // cutter overshoot past faces

$fn = 96;

// ---- Model ----
union() {
    // Handle
    cylinder(d = handle_d, h = handle_h);

    // Cone (tapered from 8 mm to 3 mm)
    translate([0, 0, handle_h])
        cylinder(d1 = cone_start_d, d2 = cone_end_d, h = cone_h);

    // Rounded tip (sphere centred at z = 62)
    translate([0, 0, tip_z - tip_d / 2])
        sphere(d = tip_d);
}

// ---- Grip grooves ----
for (z = groove_z)
    translate([0, 0, z - groove_w / 2])
        cylinder(d = groove_depth * 2, h = groove_w, $fn = 64);