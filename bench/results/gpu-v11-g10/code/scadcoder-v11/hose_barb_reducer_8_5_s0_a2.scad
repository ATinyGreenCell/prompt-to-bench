// Hose-barb reducer: 8 mm tubing (barbs) to 5 mm tubing (barbs)
// Print orientation: standing upright along Z

$fn = 64;

// ---- Dimensions (mm) ----
tube_8_d      = 8;    // inner diameter of 8 mm tubing
tube_5_d      = 5;    // inner diameter of 5 mm tubing
bore_d        = 3;    // through-bore diameter
barb_h_8      = 10;   // height of each 8 mm barb
barb_od_8_bot = 7.5;  // outer diameter of 8 mm barb at bottom
barb_od_8_top = 9.5;  // outer diameter of 8 mm barb at top
barb_count_8  = 2;    // number of 8 mm barbs (stacked)

collar_d      = 12;   // collar diameter
collar_h      = 5;    // collar height (z = 20 to 25)

barb_h_5      = 8;    // height of each 5 mm barb
barb_od_5_bot = 6.5;  // outer diameter of 5 mm barb at bottom
barb_od_5_top = 5.0;  // outer diameter of 5 mm barb at top
barb_count_5  = 2;    // number of 5 mm barbs (stacked)

eps           = 0.5;  // overshoot for clean cuts

// ---- Derived ----
z_8 = 20;             // bottom of collar
z_5 = z_8 + collar_h; // bottom of 5 mm barbs (z = 25)

// ---- Model ----
difference() {
    union() {
        // 8 mm barbs: sawtooth profile, stacked
        for (i = [0 : barb_count_8 - 1])
            translate([0, 0, i * barb_h_8])
                linear_extrude(height = barb_h_8)
                    polygon([
                        [0, barb_od_8_bot / 2],
                        [0, -barb_od_8_bot / 2],
                        [barb_od_8_top / 2, 0]
                    ]);

        // Collar
        translate([0, 0, z_8])
            cylinder(d = collar_d, h = collar_h);

        // 5 mm barbs: conical then stepped back out, stacked
        for (i = [0 : barb_count_5 - 1])
            translate([0, 0, z_5 + i * barb_h_5])
                linear_extrude(height = barb_h_5)
                    polygon([
                        [0, barb_od_5_bot / 2],
                        [0, -barb_od_5_bot / 2],
                        [barb_od_5_top / 2, 0]
                    ]);
    }

    // Through bore
    translate([0, 0, -eps])
        cylinder(d = bore_d, h = z_5 + collar_h + barb_count_5 * barb_h_5 + 2 * eps);
}