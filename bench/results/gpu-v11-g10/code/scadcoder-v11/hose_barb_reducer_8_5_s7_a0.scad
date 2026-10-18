// Straight hose-barb reducer: 8 mm tubing (barbs) -> 5 mm tubing (barbs)
// Print orientation: standing upright along Z, centred on origin in X/Y

$fn = 64;

// ---- Dimensions (mm) ----
bore      = 3;    // central through-bore diameter
barb8_h   = 10;   // height of each 8 mm barb
barb8_od  = 7.5;  // outer diameter of 8 mm barb at bottom (z = 0)
barb8_top = 9.5;  // outer diameter of 8 mm barb at top (z = 10)
collar_d  = 12;   // diameter of cylindrical collar
collar_h  = 5;    // height of collar (z = 20 to 25)
barb5_h   = 8;    // height of each 5 mm barb
barb5_od  = 6.5;  // outer diameter of 5 mm barb at bottom (z = 25)
barb5_top = 5.0;  // outer diameter of 5 mm barb at top (z = 33)
overlap   = 0.5;  // overlap/extension for clean boolean cuts

total_h = barb8_h + collar_h + barb5_h;  // 23 mm overall

// ---- Model ----
difference() {
    union() {
        // Lower section: two stacked 8 mm barbs (sawtooth profile)
        for (s = [-1, 1])
            translate([0, 0, 0])
                linear_extrude(height = barb8_h)
                    polygon(points = [
                        [-barb8_od / 2, s * (barb8_od - barb8_top) / 2],
                        [ barb8_od / 2, s * (barb8_od - barb8_top) / 2],
                        [ barb8_top / 2, s * 0],
                        [-barb8_top / 2, s * 0]
                    ]);

        // Collar
        translate([0, 0, barb8_h])
            cylinder(d = collar_d, h = collar_h);

        // Upper section: two stacked 5 mm barbs (shrinking profile)
        for (s = [-1, 1])
            translate([0, 0, barb8_h + collar_h])
                linear_extrude(height = barb5_h)
                    polygon(points = [
                        [-barb5_od / 2, s * 0],
                        [ barb5_od / 2, s * 0],
                        [ barb5_top / 2, s * (barb5_od - barb5_top) / 2],
                        [-barb5_top / 2, s * (barb5_od - barb5_top) / 2]
                    ]);
    }

    // Central through-bore
    translate([0, 0, -overlap])
        cylinder(d = bore, h = total_h + 2 * overlap);
}