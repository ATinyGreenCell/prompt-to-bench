// Lab funnel - printed upright, open at top and bottom
// Units: mm

$fn = 64;

// --- Dimensions ---
spout_od      = 10;   // spout outer diameter
spout_id      = spout_od - 2 * 1.6;  // spout bore (6.8)
spout_h       = 20;   // spout height (z = 0 to 20)
cone_top_d    = 10;   // cone diameter at z = 20
cone_rim_d    = 60;   // cone rim diameter at z = 50
cone_h        = 30;   // cone height (z = 20 to 50)
wall          = 1.6;  // wall thickness

total_h = spout_h + cone_h;  // 50

difference() {
    union() {
        // Spout
        cylinder(d = spout_od, h = spout_h);
        // Cone (from top diameter down to rim)
        translate([0, 0, spout_h])
            cylinder(d1 = cone_top_d, d2 = cone_rim_d, h = cone_h);
    }
    // Through-bore: spout bore up to cone start, then 60 mm hole at rim
    translate([0, 0, spout_h])
        cylinder(d = cone_rim_d + 0.8, h = 0.4);  // thin wall above rim
    cylinder(d = spout_id, h = spout_h - 0.8);   // bore ends below cone
}