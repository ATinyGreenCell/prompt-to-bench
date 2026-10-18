// Lab funnel - printed upright with wide opening at top
// Straight spout from z = 0 to z = 20, cone from z = 20 to z = 50

// ---- Dimensions (mm) ----
spout_od      = 10;    // spout outer diameter
spout_h       = 20;    // spout height (z = 0 to 20)
cone_od_top   = 60;    // cone outer diameter at rim (z = 50)
cone_od_bot   = 10;    // cone outer diameter at base (z = 20)
total_h       = 50;    // funnel top rim height
wall          = 1.6;   // wall thickness everywhere

eps           = 0.5;   // overlap for clean boolean cuts
$fn           = 128;   // curve resolution

// ---- Derived ----
bore = spout_od - 2 * wall;   // 6.8 mm bore in spout

// ---- Model ----
difference() {
    union() {
        // Spout
        cylinder(h = spout_h, d = spout_od);
        // Cone (slightly extended into spout for a solid union)
        translate([0, 0, spout_h - eps])
            cylinder(h = total_h - spout_h + eps, d1 = cone_od_bot, d2 = cone_od_top);
    }
    // Through-bore along Z
    translate([0, 0, -eps])
        cylinder(h = total_h + 2 * eps, d = bore);
}