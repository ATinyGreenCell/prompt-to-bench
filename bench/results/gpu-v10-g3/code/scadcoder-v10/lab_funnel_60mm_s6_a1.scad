// Small lab funnel - printed upright, open at top and bottom
// Units: mm. Wall thickness: 1.6. No supports needed.

$fn = 64;

// --- Dimensions ---
spout_od      = 10;   // spout outer diameter
spout_id      = spout_od - 2 * 1.6;  // spout bore (6.8)
spout_length  = 20;   // spout runs from z = 0 to z = 20
cone_bottom_d = 10;   // cone starts at spout diameter (z = 20)
cone_top_d    = 60;   // cone rim diameter (z = 50)
cone_top_z    = 50;   // rim height
overlap       = 0.01; // small overlap so the two solids fuse cleanly

// --- Model ---
union() {
    // Straight spout
    cylinder(d = spout_od, h = spout_length);

    // Cone: bottom diameter at z = spout_length, top diameter at z = cone_top_z
    translate([0, 0, spout_length - overlap])
        cylinder(d1 = cone_bottom_d, d2 = cone_top_d, h = cone_top_z - spout_length + overlap);
}