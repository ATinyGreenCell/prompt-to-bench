// Lab funnel - printed upright, open top and bottom
// Units: mm

$fn = 96;

// --- Dimensions ---
spout_od      = 10;    // spout outer diameter (z = 0 to 20)
spout_bore    = 6.8;   // spout bore (od - 2*wall)
cone_top_od   = 60;    // cone rim outer diameter (z = 50)
cone_bottom_od = 10;   // cone outer diameter at z = 20 (spout top)
wall          = 1.6;   // wall thickness everywhere
overlap       = 0.5;   // overlap between spout and cone for a clean union

// Derived
cone_h = 30;           // cone height (z = 20 to 50)

difference() {
    union() {
        // Straight spout
        cylinder(h = 20, d = spout_od);

        // Cone: widens from spout top diameter to rim diameter
        translate([0, 0, 20 - overlap])
            cylinder(h = cone_h + overlap,
                     d1 = cone_bottom_od,
                     d2 = cone_top_od);
    }

    // Through-bore: spout bore up to the cone, then a single cone bore to the rim
    translate([0, 0, wall])
        cylinder(h = cone_h + 2 * wall + overlap,
                 d1 = spout_bore,
                 d2 = cone_top_od - 2 * wall);
}