// Small lab funnel – printed upright, wide opening at top, straight through bore.
// All dimensions in millimetres.

// ---- Named dimensions (measured with calipers) ----
spout_od   = 10.0;   // spout outer diameter
spout_h    = 20.0;   // spout height (z = 0 to z = 20)
cone_od    = 60.0;   // cone outer diameter at the rim (z = 50)
cone_h     = 30.0;   // cone height (z = 20 to z = 50)
wall       = 1.6;    // uniform wall thickness
bore_d     = spout_od - 2*wall;   // 6.8 mm straight bore
total_h    = spout_h + cone_h;    // 50 mm overall height

$fn = 64;            // smooth round holes / rims

// ---- Outer solid: straight spout + widening cone ----
module outer() { union() {
    // Straight spout, z = 0 to z = 20
    translate([0, 0, 0])
        cylinder(h = spout_h, d = spout_od, center = false);

    // Cone, z = 20 to z = 50 (10 mm OD -> 60 mm OD)
    translate([0, 0, spout_h])
        cylinder(h = cone_h, d1 = spout_od, d2 = cone_od, center = false);
} }

// ---- Bore: straight 6.8 mm tube running the full height, open top & bottom ----
// Extended 1 mm past each face so the cut is clean (no coplanar faces).
module bore() { translate([0, 0, -1])
    cylinder(h = total_h + 2, d = bore_d, center = false); }

// ---- Final funnel: outer solid minus the through-bore ----
difference() {
    outer();
    bore();
}