// Funnel with spout - printed upright, wide opening at the top
// Units: mm. Wall thickness 1.6 mm throughout.

// ---------- Parameters ----------
spout_d        = 10;    // spout outer diameter
spout_bore     = spout_d - 2 * 1.6;  // spout bore (6.8 mm)
spout_h        = 20;    // spout height (z = 0 to 20)
cone_top_d     = 10;    // cone outer diameter at z = 20 (top of spout)
cone_rim_d     = 60;    // cone outer diameter at rim (z = 50)
cone_h         = cone_rim_d - cone_top_d;  // cone height (40 mm)
eps            = 0.5;   // cutter overshoot past faces

$fn = 64;

// ---------- Model ----------
union() {
    // Spout: tube from z = 0 to 20, open at both ends
    difference() {
        cylinder(d = spout_d, h = spout_h);
        translate([0, 0, -eps])
            cylinder(d = spout_bore, h = spout_h + 2 * eps);
    }

    // Cone: widens from 10 mm at z = 20 to 60 mm at z = 50, open top and bottom
    difference() {
        cylinder(d = cone_rim_d, h = cone_h, $fn = 64);
        translate([0, 0, spout_h - eps])
            cylinder(d = cone_top_d, h = cone_h + eps, $fn = 64);
    }
}