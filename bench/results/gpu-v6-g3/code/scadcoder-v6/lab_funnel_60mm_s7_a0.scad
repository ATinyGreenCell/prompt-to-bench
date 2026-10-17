// Lab funnel - printed upright, open at top and bottom
// Units: mm

$fn = 96;

// --- Dimensions ---
spout_od      = 10;    // spout outer diameter
spout_id      = spout_od - 2 * 1.6;  // spout bore (6.8 mm)
spout_h       = 20;    // spout height (z = 0 to 20)
cone_bottom_d = spout_od;  // cone starts at spout diameter (z = 20)
cone_top_d    = 60;    // cone rim diameter (z = 50)
wall          = 1.6;   // uniform wall thickness
eps           = 0.5;   // cutter overshoot

difference() {
    union() {
        // Spout
        cylinder(d = spout_od, h = spout_h);
        // Cone
        translate([0, 0, spout_h])
            cylinder(d1 = cone_bottom_d, d2 = cone_top_d, h = cone_top_d - spout_h);
    }
    // Through-bore: spout + cone interior (extended past both faces)
    translate([0, 0, -eps])
        linear_extrude(height = spout_h + cone_top_d - spout_h + 2 * eps)
            circle(d = spout_id);
}