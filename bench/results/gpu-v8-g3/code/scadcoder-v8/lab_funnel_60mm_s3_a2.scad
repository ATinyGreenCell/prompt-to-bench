// Small lab funnel - printed upright, open top and bottom
// Units: mm. Wall thickness 1.6 mm throughout.

$fn = 96;

// ---- Dimensions ----
spout_od      = 10;    // spout outer diameter (z = 0 to 20)
spout_len     = 20;    // spout length (z = 0 to 20)
cone_bottom_d = 10;    // cone outer diameter at z = 20
cone_top_d    = 60;    // cone outer diameter at rim (z = 50)
wall          = 1.6;   // wall thickness
eps           = 0.5;   // cutter overshoot past faces

// ---- Derived ----
spout_id = spout_od - 2 * wall;   // bore diameter (6.8 mm)
cone_h   = 50 - 20;               // cone height (30 mm)

difference() {
    union() {
        // Spout (tube)
        cylinder(d = spout_od, h = spout_len);

        // Cone: hull between spout top and rim
        hull() {
            translate([0, 0, spout_len])
                cylinder(d = cone_bottom_d, h = 0.01);
            cylinder(d = cone_top_d, h = cone_h);
        }
    }

    // Bottom outlet bore (through spout)
    translate([0, 0, -eps])
        cylinder(d = spout_id, h = spout_len + 2 * eps);

    // Rim: open top, no lid
    translate([0, 0, 50])
        cylinder(d = cone_top_d + 2 * wall, h = eps);
}