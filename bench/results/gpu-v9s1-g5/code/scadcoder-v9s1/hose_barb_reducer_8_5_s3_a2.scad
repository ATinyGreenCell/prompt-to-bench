// Hose-barb reducer: 8 mm ID -> 5 mm ID
// Print orientation: standing upright along +Z

$fn = 64;

// ---- Dimensions (mm) ----
id_8      = 8;    // 8 mm tubing inner diameter
id_5      = 5;    // 5 mm tubing inner diameter
bore      = 3;    // central through-bore diameter
barb_h8   = 10;   // height of each 8 mm barb
barb_h5   = 8;    // height of each 5 mm barb
collar_d  = 12;   // cylindrical collar diameter
z_20      = 20;   // start of collar
z_25      = 25;   // end of collar / start of 5 mm barbs
z_41      = 41;   // overall length

eps       = 0.5;  // overshoot for clean cuts

// ---- Derived ----
od_8_bottom = 7.5;
od_8_top    = 9.5;
od_5_bottom = 6.5;
od_5_top    = 5.0;

module central_bore() {
    translate([0, 0, -eps])
        cylinder(d = bore, h = z_41 + 2 * eps);
}

module barbs_8() {
    for (z = [0, barb_h8])
        translate([0, 0, z])
            linear_extrude(height = eps)
                polygon([
                    [0, od_8_bottom],
                    [od_8_top, od_8_top],
                    [od_8_bottom, od_8_bottom]
                ]);
}

module barbs_5() {
    for (z = [z_25, z_25 + barb_h5])
        translate([0, 0, z])
            linear_extrude(height = eps)
                polygon([
                    [0, od_5_bottom],
                    [od_5_top, od_5_top],
                    [od_5_bottom, od_5_bottom]
                ]);
}

difference() {
    union() {
        // 8 mm tubing section
        translate([0, 0, 0])
            linear_extrude(height = z_20)
                circle(d = od_8_bottom);
        // barbs for 8 mm tubing
        for (z = [0, barb_h8])
            translate([0, 0, z])
                cylinder(d1 = od_8_bottom, d2 = od_8_top, h = eps);
        // collar
        translate([0, 0, z_20])
            cylinder(d = collar_d, h = z_25 - z_20);
        // barbs for 5 mm tubing
        for (z = [z_25, z_25 + barb_h5])
            translate([0, 0, z])
                cylinder(d1 = od_5_bottom, d2 = od_5_top, h = eps);
        // 5 mm tubing section
        translate([0, 0, z_25 + barb_h5])
            linear_extrude(height = z_41 - (z_25 + barb_h5))
                circle(d = od_5_bottom);
    }
    // through-bore
    central_bore();
}