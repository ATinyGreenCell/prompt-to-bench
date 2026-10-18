// Lab funnel - printed upright, open top and bottom
// Units: mm

$fn = 64;

// --- Dimensions ---
spout_od      = 10;   // spout outer diameter
spout_length  = 20;   // spout runs from z = 0 to z = 20
cone_top_d    = 60;   // cone rim diameter at z = 50
cone_bottom_d = 10;   // cone diameter at z = 20 (spout top)
wall          = 1.6;  // wall thickness everywhere

// Derived
spout_id = spout_od - 2 * wall;  // bore diameter = 6.8

// --- Model ---
union() {
    // Straight spout
    translate([0, 0, 0])
        cylinder(d = spout_od, h = spout_length);

    // Cone from z = 20 to z = 50
    translate([0, 0, spout_length])
        cylinder(d1 = cone_bottom_d, d2 = cone_top_d, h = cone_top_d - spout_length);
}

// --- Cut out bore (through the whole part) ---
translate([0, 0, -1])
    cylinder(d = spout_id, h = cone_top_d + 2);