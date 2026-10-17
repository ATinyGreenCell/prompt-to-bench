// Tissue-pestle for 1.5 mL microcentrifuge tube
// Print orientation: standing upright, handle on the bed

// ---------- Parameters ----------
handle_d      = 8;     // handle diameter (mm)
handle_h      = 45;    // handle height (mm)
cone_top_d    = 8;     // cone diameter at top of handle (mm)
cone_tip_d    = 3;     // cone diameter at tip (mm)
cone_top_z    = 45;    // cone top height (mm)
cone_tip_z    = 62;    // cone tip height (mm)
tip_d         = 3;     // rounded tip diameter (mm)
tip_centre_z  = 62;    // tip sphere centre height (mm)
groove_w      = 2;     // groove width (mm)
groove_depth  = 1;     // groove depth (mm)
groove_z      = [10, 15, 20, 25]; // groove centre heights (mm)
eps           = 0.5;   // cutter overshoot past faces (mm)

$fn = 96;

// ---------- Model ----------
difference() {
    union() {
        // Handle
        cylinder(d = handle_d, h = handle_h);
        // Cone (tapers from 8 to 3 mm)
        translate([0, 0, cone_top_z])
            cylinder(d1 = cone_top_d, d2 = cone_tip_d, h = cone_tip_z - cone_top_z);
        // Rounded tip (3 mm sphere centred at z = 62)
        translate([0, 0, tip_centre_z])
            sphere(d = tip_d);
    }
    // Grip grooves, cut fully through the handle
    for (z = groove_z)
        translate([0, 0, z])
            rotate([0, 90, 0])
                cylinder(d = groove_w, h = handle_d + 2 * groove_depth, d2 = groove_depth * 2);
}