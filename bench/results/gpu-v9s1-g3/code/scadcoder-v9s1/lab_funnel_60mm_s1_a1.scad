// Small lab funnel, printed upright with wide opening at top
// Units: mm

$fn = 64;

// --- Dimensions ---
spout_od      = 10;    // spout outer diameter
spout_id      = spout_od - 2 * 1.6;  // spout bore (6.8)
spout_h       = 20;    // spout height (z = 0 to 20)
cone_top_d    = 10;    // cone diameter at spout junction (z = 20)
cone_rim_d    = 60;    // cone rim diameter (z = 50)
cone_h        = cone_rim_d - cone_top_d; // cone height (30)
wall          = 1.6;   // uniform wall thickness
eps           = 0.5;   // overlap / cut overshoot

// --- Model ---
union() {
    // Spout
    translate([0, 0, 0])
        cylinder(d = spout_od, h = spout_h);
    // Cone (overlaps spout by eps for a clean union)
    translate([0, 0, spout_h - eps])
        cylinder(d1 = cone_top_d, d2 = cone_rim_d, h = cone_h + eps);
}
difference() {
    // Through-bore: spout bore up to junction, then cone wall thickness
    translate([0, 0, -eps])
        cylinder(d1 = spout_id,
                 d2 = cone_rim_d - 2 * wall,
                 h = spout_h + cone_h + eps);
    // Open rim at top
    translate([0, 0, spout_h + cone_h - eps])
        cylinder(d = cone_rim_d + 2 * eps, h = eps);
}