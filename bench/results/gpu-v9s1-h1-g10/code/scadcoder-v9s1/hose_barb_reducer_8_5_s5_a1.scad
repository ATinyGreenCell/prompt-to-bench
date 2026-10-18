// Hose-barb reducer: joins 8 mm ID tubing to 5 mm ID tubing
// Print orientation: standing upright along +Z, centred on origin in X/Y

$fn = 96;

// ---- Dimensions (mm) ----
id_t8      = 8;    // inner diameter of 8 mm tubing
id_t5      = 5;    // inner diameter of 5 mm tubing
bore       = 3;    // central through-bore diameter
barb_h8    = 10;   // height of each 8 mm barb
od8_bottom = 7.5;  // outer diameter of 8 mm barb at bottom
od8_top    = 9.5;  // outer diameter of 8 mm barb at top
collar_d   = 12;   // diameter of cylindrical collar
collar_h   = 5;    // height of collar (z = 20 to 25)
barb_h5    = 8;    // height of each 5 mm barb
od5_bottom = 6.5;  // outer diameter of 5 mm barb at bottom
od5_top    = 5.0;  // outer diameter of 5 mm barb at top
len8       = 20;   // length of 8 mm barb section (z = 0 to 20)
len5       = 16;   // length of 5 mm barb section (z = 25 to 41)
eps        = 0.5;  // overshoot for clean cuts

// ---- Derived ----
od8_step = max(0.01, od8_top - od8_bottom);  // avoid zero in linear extrude
od5_step = max(0.01, od5_bottom - od5_top);

// ---- Model ----
difference() {
    union() {
        // 8 mm tubing barbs (z = 0 to 20)
        for (s = [-1, 1])
            translate([0, 0, s * (len8 / 2 - eps)])
                linear_extrude(height = len8 + 2 * eps)
                    polygon([
                        [od8_bottom / 2, -barb_h8 / 2],
                        [od8_bottom / 2,  barb_h8 / 2],
                        [od8_top / 2,   barb_h8 / 2],
                        [od8_top / 2,   -barb_h8 / 2]
                    ]);

        // Collar (z = 20 to 25)
        translate([0, 0, len8 - collar_h])
            cylinder(d = collar_d, h = collar_h);

        // 5 mm tubing barbs (z = 25 to 41)
        for (s = [-1, 1])
            translate([0, 0, s * (len5 / 2 - eps) + len8 + collar_h])
                linear_extrude(height = len5 + 2 * eps)
                    polygon([
                        [od5_bottom / 2, -barb_h5 / 2],
                        [od5_bottom / 2,  barb_h5 / 2],
                        [od5_top / 2,    barb_h5 / 2],
                        [od5_top / 2,    -barb_h5 / 2]
                    ]);
    }

    // Central through-bore
    translate([0, 0, -eps])
        cylinder(d = bore, h = len8 + collar_h + len5 + 2 * eps);
}