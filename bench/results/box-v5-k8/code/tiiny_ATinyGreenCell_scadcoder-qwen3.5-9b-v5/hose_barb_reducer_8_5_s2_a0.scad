// Hose-barb reducer: joins 8 mm ID silicone tubing to 5 mm ID silicone tubing
// Print orientation: standing upright along +Z, base on XY plane

// ---------------- Parameters ----------------
$fn = 96;                 // curve resolution

// Tubing inner diameters
tubing1_id = 8;           // first tubing (8 mm ID)
tubing2_id = 5;           // second tubing (5 mm ID)

// Bore that runs straight through the part
bore_d = 3;

// Barb for 8 mm tubing (z = 0 to 20)
barb1_h = 10;             // height of each barb
barb1_d0 = 7.5;           // outer diameter at bottom of barb
barb1_d1 = 9.5;           // outer diameter at top of barb
barb1_n = 2;              // number of stacked barbs

// Collar (z = 20 to 25)
collar_d = 12;            // outer diameter of collar

// Barb for 5 mm tubing (z = 25 to 41)
barb2_h = 8;              // height of each barb
barb2_d0 = 6.5;           // outer diameter at bottom of barb
barb2_d1 = 5.0;           // outer diameter at top of barb
barb2_n = 2;              // number of stacked barbs

// Overcut so cutting shapes pass beyond the faces they cut
eps = 0.5;

// ---------------- Model ----------------
difference() {
    union() {
        // First tubing section: two barbs, stacked, sawtooth profile
        for (i = [0 : barb1_n - 1]) {
            translate([0, 0, i * barb1_h])
                cylinder(h = barb1_h, d1 = barb1_d0, d2 = barb1_d1);
        }

        // Collar section: simple cylinder
        translate([0, 0, 20])
            cylinder(h = 5, d = collar_d);

        // Second tubing section: two barbs, stacked, shrinking profile
        for (i = [0 : barb2_n - 1]) {
            translate([0, 0, 25 + i * barb2_h])
                cylinder(h = barb2_h, d1 = barb2_d0, d2 = barb2_d1);
        }
    }

    // Through-bore along Z
    translate([0, 0, -eps])
        cylinder(h = 41 + 2 * eps, d = bore_d);
}