// Pestle for grinding tissue inside a 1.5 mL microcentrifuge tube
// Print orientation: standing upright, handle at the bottom

// ---------------- Parameters ----------------
handle_d      = 8;     // handle diameter (mm)
handle_top_z  = 45;     // top of handle / bottom of cone (mm)
cone_top_d    = 3;      // cone diameter at tip (mm)
cone_top_z    = 62;     // cone tip height (mm)
tip_d         = 3;      // sphere diameter for rounded tip (mm)
tip_centre_z  = 62;     // sphere centre height (mm)
groove_d      = 2;      // groove width in Z (mm)
groove_depth  = 1;      // groove depth into handle (mm)
groove_z      = [10, 15, 20, 25]; // groove centre heights (mm)
eps           = 0.5;    // overcut for clean differences (mm)
$fn           = 96;     // curve resolution

// ---------------- Model ----------------
difference() {
    union() {
        // Handle: cylinder from z = 0 to z = 45
        cylinder(d = handle_d, h = handle_top_z);

        // Cone: 8 mm at z = 45 tapering to 3 mm at z = 62
        translate([0, 0, handle_top_z])
            linear_extrude(height = cone_top_z - handle_top_z)
                circle(d1 = handle_d, d2 = cone_top_d);

        // Rounded tip: 3 mm sphere centred at z = 62
        translate([0, 0, tip_centre_z])
            sphere(d = tip_d);
    }

    // Grip grooves: 4 circumferential cuts, 2 mm wide and 1 mm deep
    for (g = groove_z)
        translate([0, 0, g])
            rotate([0, 90, 0])
                cylinder(d = groove_d, h = groove_depth + eps, $fn = 64);
}