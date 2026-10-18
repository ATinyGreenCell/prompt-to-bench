// Tubing hose-barb reducer: joins 8 mm ID silicone tubing to 5 mm ID silicone tubing
// Print orientation: standing upright along +Z, resting on z = 0

// ---------------- Parameters ----------------
// Barbs for 8 mm tubing (z = 0 to 20)
barb_8_h      = 10;   // barb height
barb_8_d0     = 7.5;  // outer diameter at bottom of barb
barb_8_d1     = 9.5;  // outer diameter at top of barb
barb_8_n      = 2;    // number of stacked barbs

// Collar (z = 20 to 25)
collar_d      = 12;    // collar outer diameter

// Barbs for 5 mm tubing (z = 25 to 41)
barb_5_h      = 8;     // barb height
barb_5_d0     = 6.5;   // outer diameter at bottom of barb
barb_5_d1     = 4.5;   // outer diameter at top of barb
barb_5_n      = 2;     // number of stacked barbs

// Through bore
bore_d        = 3;     // through-bore diameter

// ---------------- Model ----------------
difference() {
    union() {
        // 8 mm tubing barbs, stacked, sawtooth profile
        for (i = [0 : barb_8_n - 1]) {
            translate([0, 0, i * barb_8_h])
                cylinder(h = barb_8_h, d1 = barb_8_d0, d2 = barb_8_d1);
        }

        // Cylindrical collar
        translate([0, 0, 20])
            cylinder(h = 5, d = collar_d);

        // 5 mm tubing barbs, stacked, shrinking profile
        for (i = [0 : barb_5_n - 1]) {
            translate([0, 0, 25 + i * barb_5_h])
                cylinder(h = barb_5_h, d1 = barb_5_d0, d2 = barb_5_d1);
        }
    }

    // Through bore, extended past both end faces
    translate([0, 0, -1])
        cylinder(h = 42, d = bore_d);
}