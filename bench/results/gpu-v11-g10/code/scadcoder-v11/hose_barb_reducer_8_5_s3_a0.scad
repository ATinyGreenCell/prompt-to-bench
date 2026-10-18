// Straight hose-barb reducer: 8 mm tubing (barbs) -> 5 mm tubing (barbs)
// Print orientation: standing upright along Z, centred on origin in X/Y

$fn = 64;

// ---- Dimensions (mm) ----
small_id      = 8;    // inner diameter of the larger (8 mm) tubing
large_id      = 5;    // inner diameter of the smaller (5 mm) tubing
bore          = 3;    // through-bore diameter
barb_h_8      = 10;   // height of each 8 mm barb
collar_h      = 5;    // height of the 12 mm collar (z = 20 to 25)
barb_h_5      = 8;    // height of each 5 mm barb
eps           = 0.5;  // overshoot for clean boolean cuts

// ---- Derived ----
x = bore / 2 + 1;  // radial offset of the through-bore from the axis
z0 = 0;
z1 = z0 + 2 * barb_h_8;   // top of the 8 mm barbs (20)
z2 = z1 + collar_h;       // top of the collar (25)
z3 = z2 + 2 * barb_h_5;   // top of the 5 mm barbs (41)

// ---- Model ----
difference() {
    union() {
        // 8 mm tubing barbs: sawtooth profile, stacked
        for (s = [-1, 1])
            translate([0, 0, z0 + s * barb_h_8])
                linear_extrude(height = eps)
                    polygon([
                        [-9.5 / 2, -x], [-9.5 / 2, x], [9.5 / 2, x], [9.5 / 2, -x]
                    ]);

        // 8 mm tubing barbs: sawtooth profile, stacked
        for (s = [-1, 1])
            translate([0, 0, z1 + s * barb_h_8])
                linear_extrude(height = eps)
                    polygon([
                        [-7.5 / 2, -x], [-7.5 / 2, x], [7.5 / 2, x], [7.5 / 2, -x]
                    ]);

        // Cylindrical collar (z = 20 to 25)
        translate([0, 0, z2 - eps])
            cylinder(h = collar_h + 2 * eps, d = 12);

        // 5 mm tubing barbs: shrinking profile, stacked
        for (s = [-1, 1])
            translate([0, 0, z3 - barb_h_5 + s * barb_h_5])
                linear_extrude(height = eps)
                    polygon([
                        [-6.5 / 2, -x], [-6.5 / 2, x], [5 / 2, x], [5 / 2, -x]
                    ]);
    }

    // Full-length 3 mm bore
    translate([0, 0, z0 - eps])
        cylinder(h = z3 - z0 + 2 * eps, d = bore);
}