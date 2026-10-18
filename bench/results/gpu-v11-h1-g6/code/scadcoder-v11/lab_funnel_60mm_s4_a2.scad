// Lab funnel - printed upright, wide opening at the top
// Units: mm

// ---- Parameters ----
spout_od     = 10;    // spout outer diameter
spout_h      = 20;    // spout height (z = 0 to 20)
cone_top_od  = 60;    // cone outer diameter at rim
cone_rim_z   = 50;    // rim height of funnel
wall         = 1.6;   // wall thickness everywhere
eps          = 0.5;   // overlap for clean booleans
$fn          = 128;   // curve resolution

// ---- Derived ----
spout_id = spout_od - 2 * wall;   // 6.8 mm bore
cone_bot_od = spout_od;           // cone starts at spout diameter

// ---- Model ----
difference() {
    union() {
        // Spout
        cylinder(d = spout_od, h = spout_h);

        // Cone (slightly overlapping spout for a solid union)
        translate([0, 0, spout_h - eps])
            cylinder(d1 = cone_bot_od, d2 = cone_top_od, h = cone_rim_z - spout_h + eps);
    }

    // Bottom cut - open bottom, liquid runs straight through
    translate([0, 0, -eps])
        cylinder(d = spout_id, h = spout_h + 2 * eps);
}