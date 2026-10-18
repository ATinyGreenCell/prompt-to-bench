// Straight hose-barb reducer
// Print orientation: standing upright along Z

$fn = 96;

// ---- Dimensions (mm) ----
id_large      = 8;     // inner diameter of 8 mm tubing
id_small      = 5;     // inner diameter of 5 mm tubing
bore          = 3;     // through-bore diameter
barb_h        = 10;    // barb height (both tubing sizes)
od_large      = 9.5;   // 8 mm barb outer diameter at top
od_small      = 6.5;   // 5 mm barb outer diameter at top
collar_d      = 12;    // collar diameter
collar_h      = 5;     // collar height
eps           = 0.5;   // cutter overshoot

// ---- Derived ----
z0 = 0;                // start of barbs (8 mm)
z1 = barb_h;           // end of 8 mm barbs
z2 = z1 + collar_h;    // end of collar
z3 = z2 + barb_h;      // end of 5 mm barbs

// ---- Model ----
difference() {
    union() {
        // 8 mm tubing barbs: sawtooth profile, stacked
        for (i = [0 : 1])
            translate([0, 0, z0 + i * barb_h])
                linear_extrude(height = barb_h)
                    polygon([
                        [od_large / 2, 0],
                        [od_large / 2, barb_h / 2],
                        [(od_large + od_small) / 2, barb_h],
                        [(od_large + od_small) / 2, barb_h / 2]
                    ]);

        // Collar
        translate([0, 0, z2 - collar_h])
            cylinder(d = collar_d, h = collar_h);

        // 5 mm tubing barbs: shrinking profile, stacked
        for (i = [0 : 1])
            translate([0, 0, z3 - i * barb_h])
                linear_extrude(height = barb_h)
                    polygon([
                        [od_small / 2, 0],
                        [(od_small + id_small) / 2, barb_h / 2],
                        [id_small / 2, barb_h]
                    ]);
    }

    // Through-bore
    translate([0, 0, z0 - eps])
        cylinder(d = bore, h = z3 + 2 * eps);
}