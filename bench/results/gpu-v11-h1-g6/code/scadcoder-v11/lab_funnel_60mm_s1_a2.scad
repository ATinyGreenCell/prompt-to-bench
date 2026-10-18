// Lab funnel - printed upright, wide opening at the top
// Units: mm. Wall thickness 1.6 mm throughout.

$fn = 64;

// ---- Dimensions ----
spout_od      = 10;    // outer diameter of straight spout
spout_id      = spout_od - 2 * 1.6;  // spout bore (6.8 mm)
spout_h       = 20;    // spout length, z = 0 .. 20

cone_bottom_d = spout_od;               // cone starts at spout diameter
cone_top_d    = 60;                     // cone rim diameter
cone_h        = 50 - 20;                // cone height (30 mm)

eps = 0.5;             // cutter overshoot past faces

// ---- Model ----
difference() {
    union() {
        // Straight spout
        cylinder(h = spout_h, d = spout_od);

        // Cone, overlapping slightly into the spout for a clean union
        translate([0, 0, spout_h - 0.01])
            cylinder(h = cone_h, d1 = cone_bottom_d, d2 = cone_top_d);
    }

    // Bottom exit hole through the spout
    translate([0, 0, -eps])
        cylinder(h = spout_h + 2 * eps, d = spout_id);
}