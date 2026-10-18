// Small lab funnel - printed upright, open top and bottom
// Units: mm. One complete part, no external libraries.

// ---- Parameters ----
spout_od      = 10;    // spout outer diameter
spout_length  = 20;    // spout runs from z = 0 to z = 20
cone_bottom_d = 10;    // cone outer diameter at z = 20 (spout top)
cone_top_d    = 60;    // cone outer diameter at rim, z = 50
wall          = 1.6;   // uniform wall thickness
eps           = 0.5;   // cutter overshoot past faces

$fn = 128;             // smoothness of curved shapes

// ---- Derived ----
spout_id = spout_od - 2 * wall;   // bore diameter of spout (6.8 mm)
cone_h   = 50 - 20;               // cone height (30 mm)

// ---- Model ----
union() {
    // Spout: straight tube from z = 0 to z = 20
    difference() {
        cylinder(d = spout_od, h = spout_length);
        translate([0, 0, -eps])
            cylinder(d = spout_id, h = spout_length + 2 * eps);
    }

    // Cone: widens from 10 mm at z = 20 to 60 mm at z = 50
    translate([0, 0, 20])
        linear_extrude(height = cone_h)
            circle(d = cone_bottom_d + 2 * wall);   // inner curve of cone
    translate([0, 0, 20])
        linear_extrude(height = cone_h + eps)
            circle(d = cone_top_d + 2 * wall);      // outer curve of cone
}