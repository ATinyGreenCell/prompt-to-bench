// Hose-barb reducer: 8 mm ID -> 5 mm ID silicone tubing
// Print orientation: standing upright along +Z, centred on origin in X/Y

$fn = 96;

// ---- Dimensions (mm) ----
id_large      = 8;     // 8 mm tubing inner diameter
id_small      = 5;     // 5 mm tubing inner diameter
bore          = 3;     // through-bore diameter
barb_h_large  = 10;    // height of each 8 mm barb
barb_h_small  = 8;     // height of each 5 mm barb
collar_d      = 12;    // cylindrical collar diameter (z = 20 to 25)
overlap       = 0.5;   // overlap between stacked barbs and into collar

// ---- Derived ----
od_large_bot = 7.5;    // 8 mm barb outer diameter at bottom
od_large_top = 9.5;    // 8 mm barb outer diameter at top
od_small_bot = 6.5;    // 5 mm barb outer diameter at bottom
od_small_top = 5.0;    // 5 mm barb outer diameter at top

// ---- Model ----
union() {
    // 8 mm tubing end (z = 0 to 20)
    for (s = [-1, 1])
        translate([0, 0, s * overlap])
            linear_extrude(height = barb_h_large + overlap)
                circle(d = s < 0 ? od_large_bot : od_large_top);

    // Collar (z = 20 to 25)
    translate([0, 0, 20])
        cylinder(d = collar_d, h = 5);

    // 5 mm tubing end (z = 25 to 41)
    for (s = [-1, 1])
        translate([0, 0, s * overlap + 25])
            linear_extrude(height = barb_h_small + overlap)
                circle(d = s < 0 ? od_small_bot : od_small_top);

    // Through-bore
    translate([0, 0, -1])
        cylinder(d = bore, h = barb_h_large * 2 + collar_d + barb_h_small + 2);
}