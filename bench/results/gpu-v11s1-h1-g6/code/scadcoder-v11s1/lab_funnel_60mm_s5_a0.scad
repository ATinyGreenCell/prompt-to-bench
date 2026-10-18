// Small lab funnel, printed upright: spout at the bottom, wide rim at the top
// All dimensions in millimetres

// ---- Parameters ----
spout_od      = 10;    // outer diameter of straight spout
spout_length  = 20;    // spout runs from z = 0 to z = 20
cone_bottom_d = 10;    // cone outer diameter at z = 20 (matches spout)
cone_top_d    = 60;    // cone outer diameter at rim (z = 50)
rim_z         = 50;    // height of funnel rim
wall          = 1.6;   // wall thickness everywhere

eps            = 0.5;   // overshoot for clean boolean cuts
$fn            = 128;   // curve resolution

// ---- Derived ----
spout_id = spout_od - 2 * wall;   // 6.8 mm bore
cone_h   = rim_z - spout_length;  // 30 mm cone height

// ---- Model ----
difference() {
    union() {
        // Straight spout tube
        cylinder(d = spout_od, h = spout_length);

        // Cone: from spout top up to the rim
        translate([0, 0, spout_length])
            cylinder(d1 = cone_bottom_d, d2 = cone_top_d, h = cone_h);
    }

    // Bottom exit: bore through the spout end at z = 0
    translate([0, 0, -eps])
        cylinder(d = spout_id, h = spout_length + 2 * eps);
}