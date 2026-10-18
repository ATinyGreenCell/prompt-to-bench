// Small lab funnel - printed upright, open top and bottom
// Units: mm

$fn = 96;

// --- Dimensions ---
spout_od      = 10;    // spout outer diameter
spout_h       = 20;    // spout height (z = 0 to 20)
cone_bottom_d = 10;    // cone outer diameter at spout junction (z = 20)
cone_top_d    = 60;    // cone rim outer diameter (z = 50)
wall          = 1.6;   // uniform wall thickness
eps           = 0.5;   // cutter overshoot past faces

total_h = spout_h + (cone_top_d - cone_bottom_d) / 2; // 50 mm

// --- Model ---
difference() {
    union() {
        // Spout (tube)
        cylinder(d = spout_od, h = spout_h);
        // Cone from spout junction to rim
        translate([0, 0, spout_h])
            cylinder(d1 = cone_bottom_d, d2 = cone_top_d, h = total_h - spout_h);
    }
    // Bottom hole through spout
    translate([0, 0, -eps])
        cylinder(d = spout_od - 2 * wall, h = spout_h + 2 * eps);
    // Cone opening at top rim
    translate([0, 0, total_h - eps])
        cylinder(d1 = cone_top_d - 2 * wall, h = eps);
}