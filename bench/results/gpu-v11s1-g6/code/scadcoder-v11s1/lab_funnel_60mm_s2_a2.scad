// Small lab funnel, printed upright
// Units: mm

$fn = 64;

// --- Dimensions ---
spout_od      = 10;    // spout outer diameter
spout_len     = 20;    // spout length (z = 0 to 20)
spout_wall    = 1.6;   // wall thickness everywhere
cone_bottom_d = 10;    // cone outer diameter at z = 20
cone_top_d    = 60;    // rim outer diameter at z = 50
rim_z         = 50;    // rim height
eps           = 0.5;   // cutter overshoot

// --- Derived ---
spout_id = spout_od - 2 * spout_wall;   // 6.8 mm bore

difference() {
    union() {
        // Spout
        cylinder(d = spout_od, h = spout_len);
        // Cone (overlaps spout slightly for a clean union)
        translate([0, 0, spout_len - 0.01])
            cylinder(d1 = cone_bottom_d, d2 = cone_top_d, h = rim_z - spout_len + 0.01);
    }
    // Hollow the spout bore through the full length
    translate([0, 0, -eps])
        cylinder(d = spout_id, h = spout_len + 2 * eps);
    // Open the top rim
    translate([0, 0, rim_z - eps])
        cylinder(d1 = cone_top_d, d2 = cone_top_d + 2 * eps, h = eps);
}