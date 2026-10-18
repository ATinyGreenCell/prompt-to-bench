// Funnel - printed upright, open at top and bottom
// Units: mm

// ---- Parameters ----
spout_d        = 10;    // spout outer diameter
spout_bore     = 6.8;   // spout bore diameter (wall 1.6 mm)
spout_h        = 20;    // spout height (z = 0 to 20)
cone_top_d     = 60;    // cone rim outer diameter
cone_bottom_d  = 10;    // cone base outer diameter (at z = 20)
cone_h         = 30;    // cone height (z = 20 to 50)
wall           = 1.6;   // wall thickness everywhere
eps            = 0.5;   // cutter overshoot past faces

$fn = 96;

// ---- Model ----
difference() {
    union() {
        // Spout: cylinder from z = 0 to 20
        translate([0, 0, 0])
            cylinder(d = spout_d, h = spout_h);

        // Cone: from d = 10 at z = 20 to d = 60 at z = 50
        translate([0, 0, spout_h])
            cylinder(d1 = cone_bottom_d, d2 = cone_top_d, h = cone_h);
    }

    // Through-bore: cylinder along full height (z = 0 to 50)
    translate([0, 0, -eps])
        cylinder(d = spout_bore, h = spout_h + cone_h + 2 * eps);
}