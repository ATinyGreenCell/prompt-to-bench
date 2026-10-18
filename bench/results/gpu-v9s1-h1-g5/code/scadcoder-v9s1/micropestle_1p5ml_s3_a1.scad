// Pestle for 1.5 mL microcentrifuge tube
// Print orientation: standing upright, tip upward

$fn = 96;

// ---- Dimensions (mm) ----
handle_d      = 8;    // handle diameter
handle_h      = 45;   // handle height (z = 0 to 45)
cone_top_d    = 8;    // cone base diameter (z = 45)
cone_tip_d    = 3;    // cone tip diameter (z = 62)
sphere_d      = 3;    // tip sphere diameter (centre at z = 62)
groove_count  = 4;    // number of circumferential grooves
groove_w      = 2;    // groove width along Z
groove_depth  = 1;    // groove depth from surface
groove_z      = [10, 15, 20, 25]; // groove centre heights
overlap       = 0.5;  // overlap for smooth handle/cone union

// ---- Model ----
difference() {
    union() {
        // Handle
        cylinder(d = handle_d, h = handle_h);
        // Cone (overlaps handle for a smooth transition)
        translate([0, 0, handle_h - overlap])
            cylinder(d1 = cone_top_d, d2 = cone_tip_d, h = overlap + (62 - 45));
        // Tip sphere
        translate([0, 0, 62 - sphere_d / 2])
            sphere(d = sphere_d);
    }
    // Grooves
    for (z = groove_z)
        translate([0, 0, z - groove_w / 2])
            cylinder(d = handle_d + 2 * groove_depth, h = groove_w);
}