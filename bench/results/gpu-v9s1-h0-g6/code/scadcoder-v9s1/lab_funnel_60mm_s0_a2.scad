// Small lab funnel - printed upright, open at top and bottom
// Units: mm

// ---- Parameters ----
spout_od      = 10;    // spout outer diameter
spout_id      = spout_od - 2 * 1.6;  // spout bore (6.8)
spout_h       = 20;    // spout height (z = 0 to 20)
cone_top_d    = 10;    // cone diameter where it meets the spout (z = 20)
cone_rim_d    = 60;    // cone rim diameter (z = 50)
cone_h        = cone_rim_d - cone_top_d;  // cone height (30)
wall          = 1.6;   // wall thickness everywhere
eps           = 0.5;   // cutter overshoot past faces

$fn = 96;

// ---- Model ----
difference() {
    union() {
        // Spout (tube)
        cylinder(d = spout_od, h = spout_h);
        // Cone - extended slightly below spout_top so the union fuses cleanly
        translate([0, 0, spout_h - 0.01])
            cylinder(d1 = cone_top_d, d2 = cone_rim_d, h = cone_h + 0.01);
    }
    // Through-bore: spout bore up to cone start, then cone wall thickness to rim
    translate([0, 0, spout_h - 0.01])
        cylinder(d1 = spout_id, d2 = cone_rim_d - 2 * wall, h = cone_h + 0.01);
}