// Funnel - printed upright, open at top and bottom
// Units: mm

$fn = 64;

// Spout
spout_d      = 10;    // outer diameter
spout_bore   = 6.8;   // bore diameter (wall 1.6)
spout_h      = 20;    // length

// Cone
cone_top_d   = 60;    // rim diameter
cone_h       = 30;    // height from z = 20 to rim

// Cut clearance
eps          = 0.5;   // extension past faces

difference() {
    union() {
        // Spout
        cylinder(d = spout_d, h = spout_h);
        // Cone
        cylinder(d1 = spout_d, d2 = cone_top_d, h = cone_h);
    }
    // Through-bore
    translate([0, 0, -eps])
        cylinder(d = spout_bore, h = spout_h + cone_h + 2 * eps);
}