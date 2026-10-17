// Pestle for grinding tissue inside a 1.5 mL microcentrifuge tube
// Print orientation: standing upright, handle on the bed (z = 0)

// ---------------- Parameters ----------------
handle_d      = 8;    // handle diameter (mm)
handle_h      = 45;   // handle height (mm), z = 0 to 45
cone_d        = 8;    // cone base diameter at z = 45 (mm)
cone_tip_d    = 3;    // cone tip diameter at z = 62 (mm)
cone_top_z    = 62;   // cone top height (mm)
tip_d         = 3;    // sphere tip diameter (mm)
tip_z         = 62;   // sphere centre height (mm)
groove_count  = 4;    // number of circumferential grooves
groove_w      = 2;    // groove width (mm) in Z
groove_depth  = 1;    // groove depth (mm)
groove_zs     = [10, 15, 20, 25]; // groove centre heights (mm)
eps           = 0.5;  // cutter overshoot past faces (mm)
$fn           = 96;   // curve resolution

// ---------------- Model ----------------
difference() {
    union() {
        // Handle
        cylinder(d = handle_d, h = handle_h);

        // Cone: hull between handle top and cone tip
        hull() {
            translate([0, 0, handle_h - eps])
                cylinder(d = handle_d, h = eps);
            translate([0, 0, cone_top_z])
                cylinder(d = cone_tip_d, h = eps);
        }

        // Rounded tip: sphere centred at cone top
        translate([0, 0, tip_z])
            sphere(d = tip_d);
    }

    // Grip grooves cut into the handle
    for (z = groove_zs)
        translate([0, 0, z])
            rotate([0, 90, 0])
                cylinder(d = groove_w, h = groove_depth + 2 * eps, center = true);
}