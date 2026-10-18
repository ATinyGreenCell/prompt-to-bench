// Small lab funnel, printed upright with wide opening at top
// Units: mm

// ---- Dimensions ----
spout_od      = 10;    // spout outer diameter
spout_id      = spout_od - 2 * 1.6;  // spout bore (6.8 mm)
spout_h       = 20;    // spout length (z = 0 to 20)
cone_top_od   = 60;    // funnel rim outer diameter (z = 50)
cone_bottom_od = spout_od; // cone starts at spout diameter (z = 20)
cone_h        = 30;    // cone height (z = 20 to 50)
wall          = 1.6;   // uniform wall thickness
eps           = 0.5;   // cutter overshoot past faces

$fn = 96;

// ---- Model ----
difference() {
    union() {
        // Spout tube
        cylinder(d = spout_od, h = spout_h);
        // Cone (slightly overlapping spout for a clean union)
        translate([0, 0, spout_h - 0.01])
            cylinder(d1 = cone_bottom_od, d2 = cone_top_od, h = cone_h + 0.01);
    }
    // Through-bore: spout bore extended up through the cone rim
    translate([0, 0, -eps])
        cylinder(d = spout_id, h = spout_h + cone_h + 2 * eps);
}