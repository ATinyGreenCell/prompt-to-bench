// Funnel with spout - printed upright, wide opening at the top
// Units: mm. Straight spout (tube) from z = 0 to z = 20, then a cone
// widens to the rim at z = 50. Wall 1.6 mm thick. Open top and bottom.

$fn = 64;

// ---- Dimensions ----
spout_d        = 10;   // spout outer diameter
spout_bore     = 6.8;  // spout bore (10 - 2*1.6)
spout_h        = 20;   // spout height (z = 0 to z = 20)
cone_top_d     = 10;   // cone outer diameter at z = 20 (top of spout)
cone_rim_d     = 60;   // cone outer diameter at the rim (z = 50)
wall           = 1.6;  // wall thickness, spout and cone
cone_h         = 30;   // cone height (z = 20 to z = 50)
eps            = 0.5;  // cutter overshoot past faces

// ---- Derived ----
rim_r          = cone_rim_d / 2;
spout_r        = spout_d / 2;
cone_top_r     = cone_top_d / 2;
bore_r         = spout_bore / 2;

// ---- Model ----
difference() {
    union() {
        // Spout: cylinder, z = 0 to 20
        cylinder(h = spout_h, r = spout_r);

        // Cone: z = 20 to 50, diameter grows 10 -> 60
        translate([0, 0, spout_h])
            cylinder(h = cone_h, r1 = cone_top_r, r2 = rim_r);
    }

    // Bore through the spout (full height)
    translate([0, 0, -eps])
        cylinder(h = spout_h + 2 * eps, r = bore_r);

    // Open top rim cut
    translate([0, 0, spout_h + cone_h])
        cylinder(h = eps, r = rim_r - wall);   // open at z = 50

    // Open bottom end of spout
    translate([0, 0, -eps])
        cylinder(h = spout_h + 2 * eps, r = spout_r - wall);   // open at z = 0
}