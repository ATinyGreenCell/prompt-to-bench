// Small lab funnel - printed upright, wide opening at the top
// All dimensions in millimetres

// ---- Parameters ----
spout_od      = 10;    // spout outer diameter (z = 0 to 20)
spout_len     = 20;    // spout length
spout_wall    = 1.6;   // spout wall thickness -> bore 6.8 mm

cone_top_d    = 60;    // cone outer diameter at rim (z = 50)
cone_bottom_d = 10;    // cone outer diameter at z = 20

total_h       = 50;    // overall height of part

eps           = 0.5;   // overlap for clean boolean cuts

$fn = 128;

// ---- Model ----
difference() {
    union() {
        // Straight spout
        cylinder(d = spout_od, h = spout_len);

        // Cone on top of spout (slightly overlapping for a solid union)
        translate([0, 0, spout_len - eps])
            cylinder(h = total_h - spout_len + eps,
                     d1 = spout_od,
                     d2 = cone_top_d);
    }

    // Central bore through the full height (liquid channel)
    translate([0, 0, -eps])
        cylinder(h = total_h + 2 * eps, d = spout_od - 2 * spout_wall);
}