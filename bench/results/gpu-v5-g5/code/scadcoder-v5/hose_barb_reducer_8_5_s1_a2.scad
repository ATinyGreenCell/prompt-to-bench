// Straight hose-barb reducer: joins 8 mm ID silicone tubing to 5 mm ID silicone tubing
// Print orientation: standing upright along +Z, centred on origin in X/Y
// Units: mm. All cutting shapes extend past faces to avoid coplanar surfaces.

// ---------------- Parameters ----------------
reducer_d        = 12;   // collar outer diameter (z = 20 to 25)
barb8_base_d     = 7.5;  // 8 mm tubing barb outer diameter at bottom
barb8_top_d      = 9.5;  // 8 mm tubing barb outer diameter at top
barb8_height     = 10;   // 8 mm tubing barb height
barb8_start_z    = 0;    // 8 mm tubing barb stack start height
barb8_step_d     = barb8_top_d - barb8_base_d;  // sawtooth rise (7.5 -> 9.5)

barb5_base_d     = 6.5;  // 5 mm tubing barb outer diameter at bottom
barb5_top_d      = 5.0;  // 5 mm tubing barb outer diameter at top
barb5_height     = 8;    // 5 mm tubing barb height
barb5_start_z    = 25;   // 5 mm tubing barb stack start height
barb5_step_d     = barb5_top_d - barb5_base_d;  // sawtooth fall (6.5 -> 5.0)

bore_d           = 3;    // through-bore diameter (full length)
eps              = 0.5;  // overshoot for clean boolean cuts
$fn              = 96;   // curve resolution

// ---------------- Model ----------------
difference() {
    union() {
        // 8 mm tubing barbs: two stacked, sawtooth profile
        for (i = [0 : 1])
            translate([0, 0, barb8_start_z + i * barb8_height])
                linear_extrude(height = barb8_height)
                    polygon([
                        [0, 0],
                        [barb8_base_d / 2, 0],
                        [barb8_base_d / 2, barb8_step_d],
                        [barb8_top_d / 2, barb8_step_d],
                        [barb8_top_d / 2, 0]
                    ]);

        // Cylindrical collar (z = 20 to 25)
        translate([0, 0, 20])
            cylinder(d = reducer_d, h = 5);

        // 5 mm tubing barbs: two stacked, sawtooth profile
        for (i = [0 : 1])
            translate([0, 0, barb5_start_z + i * barb5_height])
                linear_extrude(height = barb5_height)
                    polygon([
                        [0, 0],
                        [barb5_base_d / 2, 0],
                        [barb5_base_d / 2, barb5_step_d],
                        [barb5_top_d / 2, barb5_step_d],
                        [barb5_top_d / 2, 0]
                    ]);
    }

    // Through-bore along Z
    translate([0, 0, -eps])
        cylinder(d = bore_d, h = 41 + 2 * eps);
}