// Lab funnel - printed upright, open top and bottom
// Units: mm

$fn = 64;

// --- Dimensions ---
spout_od      = 10;   // spout outer diameter
spout_id      = spout_od - 2 * 1.6;  // spout bore (6.8)
spout_h       = 20;   // spout height (z = 0 to 20)
cone_top_d    = 10;   // cone diameter at spout junction (z = 20)
cone_rim_d    = 60;   // cone rim diameter (z = 50)
cone_h        = cone_rim_d - cone_top_d;  // cone height (40)
wall          = 1.6;  // wall thickness everywhere
eps           = 0.5;  // overshoot for clean cuts

difference() {
    union() {
        // Spout
        cylinder(d = spout_od, h = spout_h);
        // Cone (slightly overlapping the spout for a solid union)
        translate([0, 0, spout_h - 0.01])
            cylinder(d1 = cone_top_d, d2 = cone_rim_d, h = cone_h + 0.01);
    }
    // Through-bore: spout bore up to the cone, then cone wall thickness to rim
    translate([0, 0, -eps])
        cylinder(d = spout_id, h = spout_h + 2 * eps);
    // Cone bore (expands with the wall thickness)
    translate([0, 0, spout_h - 0.01])
        cylinder(d1 = cone_top_d - 2 * wall, d2 = cone_rim_d - 2 * wall, h = cone_h + 0.01);
}