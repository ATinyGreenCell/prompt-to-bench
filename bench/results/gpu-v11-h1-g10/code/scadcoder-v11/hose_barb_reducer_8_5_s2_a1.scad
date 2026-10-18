// Hose-barb reducer: 8 mm ID tubing to 5 mm ID tubing
// Print orientation: standing upright along Z

$fn = 64;

// ---- Dimensions (mm) ----
tube_8_d      = 8;    // inner diameter of larger tubing
tube_5_d      = 5;    // inner diameter of smaller tubing
wall          = 2;    // wall thickness for both barbs

barb_8_h      = 20;   // height of 8 mm barbs
barb_8_od     = 7.5;  // outer diameter at bottom of 8 mm barb
barb_8_top_od = 9.5;  // outer diameter at top of 8 mm barb

collar_d      = 12;   // diameter of cylindrical collar
collar_h      = 5;    // height of collar (z = 20 to 25)

barb_5_h      = 8;    // height of 5 mm barbs
barb_5_od     = 6.5;  // outer diameter at bottom of 5 mm barb
barb_5_top_od = 5.0;  // outer diameter at top of 5 mm barb

bore_d        = 3;    // through-bore diameter
eps           = 0.5;  // cutter overshoot past faces

// ---- Derived ----
barb_8_r_bottom = barb_8_od / 2;
barb_8_r_top    = barb_8_top_od / 2;
slope_8        = (barb_8_r_top - barb_8_r_bottom) / barb_8_h;

barb_5_r_bottom = barb_5_od / 2;
barb_5_r_top    = barb_5_top_od / 2;
slope_5        = (barb_5_r_top - barb_5_r_bottom) / barb_5_h;

// ---- Model ----
difference() {
    union() {
        // 8 mm barbs (z = 0 to 20), stacked
        for (i = [0 : 1])
            translate([0, 0, i * barb_8_h])
                linear_extrude(height = barb_8_h)
                    polygon(points = [
                        [-barb_8_r_bottom, 0],
                        [ barb_8_r_bottom, 0],
                        [ barb_8_r_top,   barb_8_h],
                        [-barb_8_r_top,   barb_8_h]
                    ]);

        // Collar (z = 20 to 25)
        translate([0, 0, barb_8_h])
            cylinder(d = collar_d, h = collar_h);

        // 5 mm barbs (z = 25 to 41), stacked
        for (i = [0 : 1])
            translate([0, 0, barb_8_h + collar_h + i * barb_5_h])
                linear_extrude(height = barb_5_h)
                    polygon(points = [
                        [-barb_5_r_bottom, 0],
                        [ barb_5_r_bottom, 0],
                        [ barb_5_r_top,   barb_5_h],
                        [-barb_5_r_top,   barb_5_h]
                    ]);
    }

    // Through-bore
    translate([0, 0, -eps])
        cylinder(d = bore_d, h = barb_5_h + eps);
}