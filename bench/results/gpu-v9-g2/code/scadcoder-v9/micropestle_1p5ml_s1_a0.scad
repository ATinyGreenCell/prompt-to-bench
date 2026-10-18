// Tissue-grinding pestle for a 1.5 mL microcentrifuge tube
// Print orientation: standing upright on the XY plane, building up +Z

// ---------------- Parameters ----------------
handle_d      = 8;    // handle diameter (z = 0 .. 45)
handle_h      = 45;   // handle height
cone_d_top    = 8;    // cone diameter at its base (z = 45)
cone_d_bot    = 3;    // cone diameter at its tip (z = 62)
cone_h        = cone_d_bot + 2 * (handle_d - cone_d_bot) / 2; // 19: cone height from 8mm to 3mm
tip_r         = 1.5;  // tip sphere radius (centre at z = 62)
groove_count  = 4;    // number of circumferential grooves
groove_w      = 2;    // groove width along Z
groove_d      = 1;    // groove depth from surface
groove_z      = [10, 15, 20, 25]; // groove centre heights
eps           = 0.5;  // overshoot for clean boolean cuts

$fn = 96;

// ---------------- Model ----------------
difference() {
    union() {
        // Handle
        cylinder(d = handle_d, h = handle_h);
        // Tapered cone (45deg walls: radius drops by 1mm per 1mm height)
        translate([0, 0, handle_h])
            cylinder(d1 = cone_d_top, d2 = cone_d_bot, h = cone_h);
        // Rounded tip: sphere centred at z = 62
        translate([0, 0, 62 - tip_r])
            sphere(r = tip_r);
    }

    // Grip grooves, cut fully through the handle
    for (z = groove_z)
        translate([0, 0, z - groove_w / 2])
            rotate([0, 90, 0])
                cylinder(d = groove_d, h = groove_w + eps);
}