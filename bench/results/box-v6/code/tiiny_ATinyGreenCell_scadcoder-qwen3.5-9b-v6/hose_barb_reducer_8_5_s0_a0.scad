// Straight hose-barb reducer: 8 mm tubing -> 5 mm tubing
// Print orientation: standing upright along Z, centred on origin in X/Y

$fn = 96;

// ---- Dimensions (mm) ----
reducer_d     = 12;   // collar diameter (8 mm -> 5 mm transition)
reducer_h     = 5;    // collar height (z = 20 to 25)
first_barb_h  = 10;   // 8 mm barb height
first_barb_od = 9.5;  // 8 mm barb top outer diameter
second_barb_h = 8;    // 5 mm barb height
second_barb_od = 5.0; // 5 mm barb top outer diameter
bore_d        = 3;    // through-bore diameter

eps = 0.5;            // overshoot for clean boolean cuts

// ---- Model ----
difference() {
    union() {
        // 8 mm tubing barbs (z = 0 to 20)
        for (z = [0, 10])
            translate([0, 0, z])
                cylinder(h = first_barb_h,
                          r = [first_barb_od / 2, 7.5 / 2],
                          $fn = 96);

        // Collar (z = 20 to 25)
        translate([0, 0, 20])
            cylinder(h = reducer_h, d = reducer_d, $fn = 96);

        // 5 mm tubing barbs (z = 25 to 41)
        for (z = [25, 33])
            translate([0, 0, z])
                cylinder(h = second_barb_h,
                          r = [second_barb_od / 2, 6.5 / 2],
                          $fn = 96);
    }

    // Through-bore along Z
    translate([0, 0, -eps])
        cylinder(h = 41 + 2 * eps, d = bore_d, $fn = 96);
}