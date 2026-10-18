// Lab funnel - printed upright, wide opening at the top
// Units: mm. Wall thickness 1.6 mm throughout.

$fn = 64;

// ---- Parameters ----
spout_od      = 10;    // outer diameter of spout
spout_id      = spout_od - 2 * 1.6;  // spout bore (6.8 mm)
spout_h       = 20;    // spout height (z = 0 .. 20)

cone_bottom_d = spout_od;  // cone outer diameter at z = 20
cone_top_d    = 60;    // cone rim outer diameter at z = 50
cone_h        = 50 - 20; // cone height (z = 20 .. 50)

eps           = 0.5;   // overlap for clean cuts

// ---- Model ----
difference() {
    union() {
        // Spout
        cylinder(h = spout_h, d = spout_od);

        // Cone: outer surface from spout diameter up to rim
        translate([0, 0, spout_h - eps])
            cylinder(h = cone_h + eps, d1 = cone_bottom_d, d2 = cone_top_d);
    }

    // Central bore through the full height
    translate([0, 0, -eps])
        cylinder(h = spout_h + cone_h + 2 * eps, d = spout_id);
}