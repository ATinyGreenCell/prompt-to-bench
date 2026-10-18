// Pestle for grinding tissue inside a 1.5 mL microcentrifuge tube
// Print orientation: standing upright on the XY plane, building up +Z

// ---- Dimensions (mm) ----
handle_d      = 8;     // handle diameter (z = 0 to 45)
handle_h      = 45;    // handle height
cone_top_d    = 8;     // cone diameter at top (z = 45)
cone_bottom_d = 3;     // cone diameter at tip (z = 62)
cone_h        = 62 - 45; // cone height (17)
tip_d         = 3;     // sphere tip diameter
tip_centre_z  = 62;    // sphere centre height
groove_count  = 4;     // number of circumferential grooves
groove_w      = 2;     // groove width in Z
groove_depth  = 1;     // groove depth from surface
groove_z      = [10, 15, 20, 25]; // groove centre heights

// ---- Modelling helpers ----
eps = 0.5;             // overshoot for clean boolean cuts
$fn = 96;              // curve resolution

// ---- Part ----
difference() {
    union() {
        // Handle
        cylinder(d = handle_d, h = handle_h);
        // Cone (tangent to handle at join)
        translate([0, 0, handle_h])
            cylinder(d1 = cone_bottom_d, d2 = cone_top_d, h = cone_h);
        // Rounded tip
        translate([0, 0, tip_centre_z])
            sphere(d = tip_d);
    }
    // Grip grooves
    for (z = groove_z)
        translate([0, 0, z - groove_w/2])
            cylinder(d = handle_d + 2 * groove_depth, h = groove_w);
}