// Lab funnel - printed upright, open at top and bottom
// Units: mm

$fn = 96;

// --- Dimensions ---
spout_od      = 10;    // spout outer diameter
spout_id      = spout_od - 2 * 1.6;  // spout bore (6.8 mm)
spout_h       = 20;    // spout height (z = 0 to 20)
cone_bottom_d = spout_od;  // cone starts at spout diameter
cone_top_d    = 60;    // cone rim diameter
cone_h        = 30;    // cone height (z = 20 to 50)
wall          = 1.6;   // wall thickness
eps           = 0.5;   // cutter overshoot

difference() {
    union() {
        // Spout
        cylinder(d = spout_od, h = spout_h);
        // Cone
        translate([0, 0, spout_h])
            cylinder(d1 = cone_bottom_d, d2 = cone_top_d, h = cone_h);
    }
    // Bottom cutter (through spout)
    translate([0, 0, -eps])
        cylinder(d = spout_id, h = spout_h + 2 * eps);
    // Top cutter (open rim)
    translate([0, 0, spout_h + cone_h - eps])
        cylinder(d = cone_top_d, h = eps);
}