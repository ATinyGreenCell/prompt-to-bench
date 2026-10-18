// Hose-barb reducer: 8 mm ID tubing (z = 0..20) to 5 mm ID tubing (z = 25..41)
// Print orientation: standing upright along +Z, centred on origin in X/Y
// Units: mm

// ---------------- Parameters ----------------
bore          = 3;    // through-bore diameter (full length)
barb_8_od_bot = 7.5;  // outer diameter of 8 mm barbs at bottom (z = 0)
barb_8_od_top = 9.5;  // outer diameter of 8 mm barbs at top (z = 20)
barb_8_h      = 10;   // height of each 8 mm barb
barb_8_n      = 2;    // number of 8 mm barbs (stacked)

collar_od     = 12;   // outer diameter of cylindrical collar (z = 20..25)
collar_h      = 5;    // collar height

barb_5_od_bot = 6.5;  // outer diameter of 5 mm barbs at bottom (z = 25)
barb_5_od_top = 5.0;  // outer diameter of 5 mm barbs at top (z = 41)
barb_5_h      = 8;    // height of each 5 mm barb
barb_5_n      = 2;    // number of 5 mm barbs (stacked)

eps           = 0.5;  // overlap / extension for clean boolean cuts
$fn           = 96;   // curve resolution

// ---------------- Derived ----------------
z0      = 0;                    // start of 8 mm barbs
z20     = z0 + barb_8_h * 2;    // top of 8 mm barbs (10 mm each, stacked)
z25     = z20 + collar_h;       // top of collar
z41     = z25 + barb_5_h * 2;   // top of 5 mm barbs (8 mm each, stacked)

// ---------------- Model ----------------
difference() {
    union() {
        // 8 mm tubing barbs (sawtooth profile, stacked)
        for (i = [0 : barb_8_n - 1]) {
            translate([0, 0, z0 + i * barb_8_h])
                linear_extrude(height = barb_8_h)
                    polygon([
                        [0, -barb_8_od_bot / 2],
                        [0,  barb_8_od_bot / 2],
                        [0,  barb_8_od_top / 2]
                    ]);
        }

        // Cylindrical collar (z = 20..25)
        translate([0, 0, z20])
            cylinder(d = collar_od, h = collar_h);

        // 5 mm tubing barbs (tapered, stacked)
        for (i = [0 : barb_5_n - 1]) {
            translate([0, 0, z25 + i * barb_5_h])
                linear_extrude(height = barb_5_h)
                    polygon([
                        [0, -barb_5_od_bot / 2],
                        [0,  barb_5_od_bot / 2],
                        [0,  barb_5_od_top / 2]
                    ]);
        }
    }

    // Full-length through-bore
    translate([0, 0, -eps])
        cylinder(d = bore, h = z41 + 2 * eps);
}