// Lab funnel - printed upright, wide opening at the top, open at both ends
// Units: mm. Straight spout (tube) from z = 0 to z = 20, then a cone
// widens to a 60 mm rim at z = 50. Wall thickness 1.6 mm everywhere.

// ---------------- Parameters ----------------
spout_d        = 10;    // spout outer diameter
spout_bore     = spout_d - 2 * 1.6;  // spout bore (6.8 mm)
spout_h        = 20;    // spout height (z = 0 to z = 20)
cone_top_d     = 10;    // cone top diameter, same as spout outer diameter
cone_bottom_d  = 60;    // cone rim diameter at the top (z = 50)
cone_h         = 50 - 20;  // cone height (z = 20 to z = 50)
wall           = 1.6;   // wall thickness, spout and cone
eps            = 0.5;   // cutter overshoot past faces

$fn = 96;               // smoothness for curved surfaces

// ---------------- Model ----------------
difference() {
    union() {
        // Spout: cylinder, z = 0 to z = 20
        cylinder(d = spout_d, h = spout_h);

        // Cone: 10 mm outer diameter at z = 20, 60 mm outer diameter at z = 50
        // (centre-to-centre height = cone_h = 30 mm)
        linear_extrude(height = cone_h)
            cylinder(d = cone_top_d, h = cone_h + 0.001);  // tiny overlap into spout
    }

    // Bore through the spout (constant 6.8 mm)
    translate([0, 0, -eps])
        cylinder(d = spout_bore, h = spout_h + 2 * eps);

    // Open top rim: cut the upper wall so the cone is open at z = 50
    translate([0, 0, spout_h + cone_h - wall - eps])
        cylinder(d = cone_bottom_d + 2 * eps, h = wall + 2 * eps);
}