// Lab funnel - printed upright, open at top and bottom
// Units: mm

// ---- Parameters ----
spout_od      = 10;    // spout outer diameter
spout_h       = 20;    // spout height (z = 0 to 20)
cone_bottom_d = 10;    // cone outer diameter at z = 20 (matches spout)
cone_top_d    = 60;    // cone outer diameter at rim (z = 50)
wall          = 1.6;   // wall thickness everywhere
eps           = 0.5;   // cutter overshoot past faces

$fn = 96;

// ---- Derived ----
spout_id = spout_od - 2 * wall;   // bore diameter (6.8 mm)
cone_h   = 50 - 20;               // cone height (30 mm)

// ---- Model ----
difference() {
    union() {
        // Spout: straight tube from z = 0 to 20
        cylinder(d = spout_od, h = spout_h);

        // Cone: widens from 10 mm at z = 20 to 60 mm at z = 50
        translate([0, 0, spout_h])
            cylinder(d = cone_bottom_d, h = cone_h);
    }

    // Bottom cutter: open the spout bore through z = 0
    translate([0, 0, -eps])
        cylinder(d = spout_id, h = spout_h + 2 * eps);

    // Top cutter: open the funnel rim at z = 50
    translate([0, 0, 50 + eps])
        cylinder(d = cone_top_d, h = eps);
}