// Lab funnel - printed upright, open at top and bottom
// Units: mm

// ---- Parameters ----
spout_od      = 10;    // spout outer diameter
spout_len     = 20;    // spout length (z = 0 to 20)
cone_od_top   = 60;    // cone rim outer diameter (z = 50)
cone_od_bot   = 10;    // cone base outer diameter (z = 20)
wall          = 1.6;   // wall thickness everywhere
eps           = 0.5;   // cutter overshoot past faces

$fn = 96;

// ---- Model ----
difference() {
    union() {
        // Straight spout
        cylinder(d = spout_od, h = spout_len);
        // Cone from z = 20 to z = 50
        translate([0, 0, spout_len])
            cylinder(d1 = cone_od_bot, d2 = cone_od_top, h = cone_od_top - cone_od_bot);
    }
    // Bore: spout 6.8 mm, cone 56 mm at rim
    translate([0, 0, -eps])
        cylinder(d = spout_od - 2 * wall, h = spout_len + 2 * eps);
    translate([0, 0, spout_len - eps])
        cylinder(d1 = cone_od_bot - 2 * wall, d2 = cone_od_top - 2 * wall,
                 h = cone_od_top - cone_od_bot + eps);
}