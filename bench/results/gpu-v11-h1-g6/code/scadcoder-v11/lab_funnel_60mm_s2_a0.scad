// Lab funnel - printed upright with wide opening at the top
// Units: mm. Wall thickness 1.6 mm throughout.

$fn = 64;

// ---- Dimensions ----
spout_od        = 10;    // outer diameter of straight spout
spout_id        = spout_od - 2 * 1.6;  // bore diameter (6.8 mm)
spout_h         = 20;    // spout height, z = 0 .. 20

cone_bottom_od  = spout_od;  // cone starts at spout diameter
cone_top_od     = 60;    // rim diameter at top of cone
cone_h          = 50 - 20; // cone height, z = 20 .. 50

eps             = 0.5;   // overlap for clean boolean cuts

// ---- Model ----
difference() {
    union() {
        // Spout
        cylinder(h = spout_h, d = spout_od);

        // Cone (expanded from bottom diameter to top diameter)
        rotate([0, 0, 0])
            linear_extrude(height = cone_h)
                circle(d = cone_bottom_od + (cone_top_od - cone_bottom_od) *
                       (z = [0 : cone_h]) / cone_h);
    }

    // Bottom cut - open bottom at z = 0
    translate([0, 0, -eps])
        cylinder(h = spout_h + 2 * eps, d = spout_id);
}