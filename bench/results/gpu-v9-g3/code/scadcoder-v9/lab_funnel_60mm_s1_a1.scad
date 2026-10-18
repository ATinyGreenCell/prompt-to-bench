// Lab funnel - printed upright, open top and bottom
// Units: mm

// ---- Parameters ----
spout_od      = 10;    // spout outer diameter
spout_length  = 20;    // spout runs from z = 0 to z = 20
cone_top_d    = 60;    // cone rim diameter at z = 50
cone_bottom_d = 10;    // cone diameter where it meets the spout (z = 20)
wall          = 1.6;   // wall thickness everywhere
eps           = 0.5;   // cutter overshoot past faces

$fn = 96;

// ---- Model ----
difference() {
    union() {
        // Straight spout (tube)
        cylinder(d = spout_od, h = spout_length);
        // Cone from z = 20 to z = 50
        translate([0, 0, spout_length])
            cylinder(d1 = cone_bottom_d, d2 = cone_top_d, h = cone_top_d - cone_bottom_d);
    }
    // Through-bore: spout bore + cone bore (open bottom)
    translate([0, 0, -eps])
        cylinder(h = spout_length + 2 * eps, d = spout_od - 2 * wall);
    translate([0, 0, spout_length - eps])
        cylinder(h = (cone_top_d - cone_bottom_d) + 2 * eps,
                 d1 = cone_bottom_d - 2 * wall,
                 d2 = cone_top_d - 2 * wall);
}