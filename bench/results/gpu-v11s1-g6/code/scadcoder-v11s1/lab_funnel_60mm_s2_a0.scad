// Lab funnel - printed upright, spout down
// Units: mm

$fn = 64;

// --- Spout (tube) ---
spout_od     = 10;    // outer diameter of spout
spout_length = 20;    // z = 0 to z = 20
spout_wall   = 1.6;   // wall thickness -> bore = 6.8 mm

// --- Cone ---
cone_bottom_d = 10;   // outer diameter at z = 20 (spout top)
cone_top_d    = 60;   // outer diameter at rim, z = 50
cone_top_z    = 50;   // rim height

// --- Cutting overlap ---
eps = 0.5;            // extension past cut faces

difference() {
    union() {
        // Spout
        cylinder(d = spout_od, h = spout_length);

        // Cone (slightly overlapping the spout for a clean union)
        translate([0, 0, spout_length - 0.01])
            cylinder(d1 = cone_bottom_d,
                     d2 = cone_top_d,
                     h  = cone_top_z - spout_length + 0.01);
    }

    // Hollow out the spout bore (through the full length)
    translate([0, 0, -eps])
        cylinder(d = spout_od - 2 * spout_wall, h = spout_length + 2 * eps);

    // Open the top: cylinder of the rim diameter from the top down
    translate([0, 0, cone_top_z - eps])
        cylinder(d = cone_top_d, h = eps);
}