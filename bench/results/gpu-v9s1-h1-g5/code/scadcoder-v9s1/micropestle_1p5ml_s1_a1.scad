// Pestle for 1.5 mL microcentrifuge tube
// Print orientation: standing upright, tip down

$fn = 96;

// ---- Dimensions (mm) ----
handle_d      = 8;    // handle diameter
handle_h      = 45;   // handle length (z = 0 to 45)
cone_top_d    = 8;    // cone base diameter (at handle junction)
cone_tip_d    = 3;    // cone tip diameter
tip_r         = 1.5;  // tip sphere radius
tip_z         = 62;   // tip sphere centre height
groove_count  = 4;    // number of circumferential grooves
groove_w      = 2;    // groove width (Z)
groove_depth  = 1;    // groove depth from surface
groove_z      = [10, 15, 20, 25]; // groove centre heights

eps = 0.5;            // overshoot for clean cuts

// ---- Model ----
difference() {
    union() {
        // Handle
        cylinder(d = handle_d, h = handle_h);
        // Cone (overlaps slightly into handle for a solid union)
        translate([0, 0, handle_h - 0.01])
            cylinder(d1 = cone_top_d, d2 = cone_tip_d, h = tip_z - handle_h + 0.01);
        // Tip sphere
        translate([0, 0, tip_z])
            sphere(r = tip_r);
    }
    // Grooves
    for (z = groove_z)
        translate([0, 0, z - groove_w / 2])
            rotate([0, 90, 0])
                cylinder(d = groove_depth + eps, h = groove_w + eps);
}