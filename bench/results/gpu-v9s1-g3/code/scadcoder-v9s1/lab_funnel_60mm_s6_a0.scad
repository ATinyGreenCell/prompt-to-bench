// Lab funnel - printed upright, open at top and bottom
// Units: mm

$fn = 64;

// Spout (tube)
spout_od    = 10;   // outer diameter of spout
spout_id    = spout_od - 2 * 1.6;  // bore diameter (1.6 mm wall)
spout_h     = 20;   // spout height (z = 0 to 20)

// Cone
cone_od_top = 60;   // rim outer diameter (z = 50)
cone_od_bot = spout_od; // cone starts at spout diameter (z = 20)
cone_h      = 30;   // cone height (z = 20 to 50)

// Cut overshoot
eps = 0.5;          // extension past cut faces

union() {
    // Spout body
    difference() {
        cylinder(d = spout_od, h = spout_h);
        translate([0, 0, -eps])
            cylinder(d = spout_id, h = spout_h + 2 * eps);
    }

    // Cone (slightly overlapping the spout for a clean union)
    translate([0, 0, spout_h - 0.01])
        linear_extrude(height = cone_h + 0.01)
            polygon([
                [0, cone_od_bot / 2],
                [cone_od_top / 2, cone_h]
            ]);

    // Top rim thickened for strength
    translate([0, 0, spout_h + cone_h - 2])
        cylinder(d = cone_od_top, h = 3);
}