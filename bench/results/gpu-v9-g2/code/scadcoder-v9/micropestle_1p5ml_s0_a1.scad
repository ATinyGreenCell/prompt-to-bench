// Pestle for grinding tissue inside a 1.5 mL microcentrifuge tube
// Print orientation: standing upright on the bed (z = 0), building up in +Z

// ---------------- Parameters ----------------
handle_d      = 8;     // handle diameter (mm)
handle_h      = 45;    // handle height (mm), z = 0 to 45
cone_top_d    = 8;     // cone diameter at top (z = 45) (mm)
cone_bottom_d = 3;     // cone diameter at bottom (z = 62) (mm)
cone_h        = 17;    // cone height (mm)
tip_r         = 1.5;   // tip sphere radius (mm)
tip_z         = 62;    // tip sphere centre height (mm)
groove_count  = 4;     // number of circumferential grooves
groove_w      = 2;     // groove width along Z (mm)
groove_d      = 1;     // groove depth (mm)
groove_z      = [10, 15, 20, 25]; // groove centre heights (mm)
eps           = 0.5;   // cutter overshoot past faces (mm)

$fn = 96;

// ---------------- Model ----------------
difference() {
    union() {
        // Handle
        cylinder(d = handle_d, h = handle_h);

        // Cone: tapers from 8 mm at z = 45 to 3 mm at z = 62
        translate([0, 0, handle_h])
            cylinder(d1 = cone_top_d, d2 = cone_bottom_d, h = cone_h);

        // Rounded tip: 3 mm diameter sphere centred at z = 62
        translate([0, 0, tip_z])
            sphere(r = tip_r);
    }

    // Grooves
    for (z = groove_z)
        rotate([0, 0, 0])
            translate([0, -1, z - groove_w / 2])
                cube([handle_d / 2, groove_w + eps, groove_d + eps]);
}