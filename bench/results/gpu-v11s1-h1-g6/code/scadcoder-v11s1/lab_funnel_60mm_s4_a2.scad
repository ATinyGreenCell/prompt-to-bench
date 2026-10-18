// Small lab funnel, printed upright (wide opening at top)
// All dimensions in mm

// ---- Parameters ----
spout_od      = 10;    // spout outer diameter
spout_h       = 20;    // spout height (z = 0 to 20)
cone_od_top   = 60;    // cone outer diameter at rim
cone_h        = 30;    // cone height (z = 20 to 50)
wall          = 1.6;   // wall thickness everywhere
eps           = 0.5;   // overshoot for clean cuts

$fn = 128;

// ---- Derived ----
bore = spout_od - 2 * wall;   // 6.8 mm spout bore

// ---- Model ----
difference() {
    union() {
        // Spout
        cylinder(h = spout_h, d = spout_od);
        // Cone (slightly overlapping spout for a solid union)
        translate([0, 0, spout_h - 0.01])
            cylinder(h = cone_h + 0.01, d1 = spout_od, d2 = cone_od_top);
    }
    // Through-bore from bottom up past the rim
    translate([0, 0, -eps])
        cylinder(h = spout_h + cone_h + 2 * eps, d = bore);
}