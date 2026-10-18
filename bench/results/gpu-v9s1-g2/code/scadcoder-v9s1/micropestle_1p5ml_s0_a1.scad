// Pestle for grinding tissue inside a 1.5 mL microcentrifuge tube
// Print orientation: standing upright on the bed, builds up +Z

$fn = 96;

// ---- Dimensions (mm) ----
handle_d      = 8;    // handle diameter
handle_h      = 45;   // handle length (z = 0 to 45)
cone_top_d    = 8;    // cone diameter where it meets the handle
cone_bottom_d = 3;    // cone tip diameter (z = 62)
cone_h        = 17;   // cone height (z = 45 to 62)
sphere_d      = 3;    // rounded tip sphere diameter
sphere_z      = 62;   // sphere centre height

groove_count  = 4;    // number of circumferential grooves
groove_w      = 2;    // groove width along Z
groove_depth  = 1;    // groove depth into the handle
groove_z      = [10, 15, 20, 25]; // groove centre heights

eps           = 0.5;  // overshoot for clean boolean cuts

// ---- Model ----
difference() {
    union() {
        // Handle
        cylinder(d = handle_d, h = handle_h);
        // Cone (tapers from 8 mm at z = 45 to 3 mm at z = 62)
        translate([0, 0, handle_h])
            cylinder(d1 = cone_top_d, d2 = cone_bottom_d, h = cone_h);
        // Rounded tip (sphere centred at z = 62)
        translate([0, 0, sphere_z])
            sphere(d = sphere_d);
    }
    // Grip grooves cut into the handle
    for (z = groove_z)
        translate([0, 0, z - groove_w / 2])
            cylinder(d = handle_d + 2 * eps, h = groove_w);
}