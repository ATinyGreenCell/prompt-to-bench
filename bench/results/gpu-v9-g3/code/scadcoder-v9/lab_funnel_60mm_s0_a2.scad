// Lab funnel - printed upright, open at top and bottom
// Units: mm

$fn = 64;

// --- Dimensions ---
spout_od      = 10;    // spout outer diameter
spout_length  = 20;    // spout runs from z = 0 to z = 20
cone_top_d    = 60;    // cone outer diameter at rim (z = 50)
cone_bottom_d = 10;    // cone outer diameter at base (z = 20)
wall          = 1.6;   // wall thickness everywhere
cut_extra     = 0.5;   // overshoot for clean cuts

// Derived
spout_id = spout_od - 2 * wall;   // bore diameter (6.8 mm)
rim_d    = cone_top_d;
base_d   = cone_bottom_d;
cone_h   = 50 - 20;               // cone height

difference() {
    union() {
        // Straight spout
        cylinder(d = spout_od, h = spout_length);
        // Cone from z = 20 to z = 50
        translate([0, 0, 20])
            cylinder(d1 = base_d, d2 = rim_d, h = cone_h);
    }
    // Through-bore: spout + extended cone section
    translate([0, 0, -cut_extra])
        cylinder(d = spout_id, h = spout_length + 2 * cut_extra);
    translate([0, 0, 20 - cut_extra])
        cylinder(d1 = base_d - 2 * wall,
                 d2 = rim_d - 2 * wall,
                 h = cone_h + cut_extra);
}