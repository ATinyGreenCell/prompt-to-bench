// Hose-barb reducer: 8 mm ID silicone tubing (bottom) to 5 mm ID (top)
// Printed upright, rotationally symmetric about Z, 3 mm bore through full length.

// ---- Global ----
$fn = 64;

// ---- Bore ----
bore_d = 3.0;                 // 3 mm bore, straight through full length

// ---- 8 mm tubing barbs (z = 0..20) ----
barb8_h      = 10.0;          // height of each 8 mm barb
barb8_od_bot = 7.5;           // outer diameter at barb base (bottom)
barb8_od_top = 9.5;           // outer diameter at barb tip (top)
n_barb8      = 2;             // two stacked barbs

// ---- Collar (z = 20..25) ----
collar_d = 12.0;              // collar outer diameter
collar_h = 5.0;               // collar height (20 -> 25)

// ---- 5 mm tubing barbs (z = 25..41) ----
barb5_h      = 8.0;           // height of each 5 mm barb
barb5_od_bot = 6.5;           // outer diameter at barb base (bottom)
barb5_od_top = 5.0;           // outer diameter at barb tip (top)
n_barb5      = 2;             // two stacked barbs

// ---- Sawtooth profile (one barb, in the r-z plane, r >= 0) ----
// 8 mm barb: r grows 3.75 -> 4.75, then steps straight back to 3.75.
// 5 mm barb: r shrinks 3.25 -> 2.50, then steps straight out to 3.25.
profile8 = [
    [barb8_od_bot/2, 0],
    [barb8_od_top/2, barb8_h],
    [barb8_od_bot/2, barb8_h]
];
profile5 = [
    [barb5_od_bot/2, 0],
    [barb5_od_top/2, barb5_h],
    [barb5_od_bot/2, barb5_h]
];

// ---- Build the solid ----
difference() {
    union() {
        // 8 mm barbs, stacked from z = 0
        for (i = [0 : n_barb8 - 1]) {
            translate([0, 0, i * barb8_h])
                rotate_extrude($fn) profile8;
        }

        // Collar, z = 20..25
        translate([0, 0, n_barb8 * barb8_h])
            cylinder(h = collar_h, d = collar_d, $fn = $fn);

        // 5 mm barbs, stacked from z = 25
        for (i = [0 : n_barb5 - 1]) {
            translate([0, 0, n_barb8 * barb8_h + collar_h + i * barb5_h])
                rotate_extrude($fn) profile5;
        }
    }

    // Bore: 3 mm through the full length, extended 1 mm past each face
    cylinder(h = 41 + 2, d = bore_d, $fn = $fn);
}