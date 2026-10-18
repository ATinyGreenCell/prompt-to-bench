// Small lab funnel - printed upright, open top and bottom
// Units: mm

$fn = 96;

// --- Dimensions ---
spout_od      = 10;    // spout outer diameter
spout_len     = 20;    // spout length (z = 0 to 20)
cone_bottom_d = 10;    // cone outer diameter at z = 20
cone_top_d    = 60;    // cone outer diameter at rim (z = 50)
wall          = 1.6;   // wall thickness everywhere

// --- Derived ---
spout_id = spout_od - 2 * wall;   // bore diameter (6.8 mm)
total_h  = spout_len + (cone_top_d - cone_bottom_d) / 2; // 50 mm

difference() {
    union() {
        // Spout
        cylinder(d = spout_od, h = spout_len);
        // Cone from z = 20 to z = 50
        translate([0, 0, spout_len])
            cylinder(d1 = cone_bottom_d, d2 = cone_top_d, h = total_h - spout_len);
    }
    // Bottom hole through the spout
    translate([0, 0, -1])
        cylinder(d = spout_id, h = spout_len + 2);
    // Cone opening at the top
    translate([0, 0, total_h - 0.01])
        cylinder(d1 = cone_top_d, h = 0.02);
}