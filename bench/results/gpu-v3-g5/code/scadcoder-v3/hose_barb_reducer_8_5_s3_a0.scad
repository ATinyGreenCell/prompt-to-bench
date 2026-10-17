// Straight hose-barb reducer: 8 mm tubing to 5 mm tubing
// Print orientation: upright along Z, resting on XY plane at z = 0

$fn = 96;

// ---- Dimensions (mm) ----
collar_d      = 12;    // collar outer diameter
bore_d        = 3;     // through-bore diameter
barb_8_bottom = 7.5;   // 8 mm barb OD at bottom
barb_8_top    = 9.5;   // 8 mm barb OD at top
barb_5_bottom = 6.5;   // 5 mm barb OD at bottom
barb_5_top    = 5.0;   // 5 mm barb OD at top
eps           = 0.5;   // cutter overshoot

// ---- Model ----
difference() {
    union() {
        // 8 mm barbs, stacked
        for (z = [0, 10])
            translate([0, 0, z])
                linear_extrude(height = 10)
                    polygon(points = [[barb_8_bottom, barb_8_bottom],
                                       [barb_8_top, barb_8_bottom],
                                       [barb_8_top, barb_8_top],
                                       [barb_8_bottom, barb_8_top]]);
        // collar
        translate([0, 0, 20])
            cylinder(d = collar_d, h = 5);
        // 5 mm barbs, stacked
        for (z = [25, 33])
            translate([0, 0, z])
                linear_extrude(height = 8)
                    polygon(points = [[barb_5_bottom, barb_5_bottom],
                                       [barb_5_top, barb_5_bottom],
                                       [barb_5_top, barb_5_top],
                                       [barb_5_bottom, barb_5_top]]);
    }
    // through-bore, full length
    translate([0, 0, -eps])
        cylinder(d = bore_d, h = 41 + 2 * eps);
}