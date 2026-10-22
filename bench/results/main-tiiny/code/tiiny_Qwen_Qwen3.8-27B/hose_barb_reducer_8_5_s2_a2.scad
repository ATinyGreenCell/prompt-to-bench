// Hose-barb reducer: 8 mm ID silicone tubing (bottom) to 5 mm ID (top)
// Printed upright, rotationally symmetric about Z, 3 mm bore through full length.
// Centred on the origin in X and Y.

// ---- Global ----
$fn = 64;

// ---- Bore ----
bore_d = 3.0;          // straight through-bore diameter

// ---- 8 mm tubing barbs (z = 0..20) ----
barb8_h   = 10.0;      // height of each 8 mm barb
barb8_bot = 7.5;       // outer diameter at barb bottom
barb8_top = 9.5;       // outer diameter at barb top (before step-down)
n8        = 2;         // number of 8 mm barbs

// ---- Collar (z = 20..25) ----
collar_h  = 5.0;       // collar height
collar_d  = 12.0;      // collar outer diameter

// ---- 5 mm tubing barbs (z = 25..41) ----
barb5_h   = 8.0;       // height of each 5 mm barb
barb5_bot = 6.5;       // outer diameter at barb bottom
barb5_top = 5.0;       // outer diameter at barb top (before step-up)
n5        = 2;         // number of 5 mm barbs

// ---- Derived ----
z0 = 0;
z1 = z0 + n8 * barb8_h;                 // 20
z2 = z1 + collar_h;                     // 25
z3 = z2 + n5 * barb5_h;                 // 41

// Sawtooth profile (radius vs z), closed polygon in the XZ plane.
// Points are (x = radius, y = z).
profile = [
    [0, 0],
    [barb8_bot/2, 0],
    [barb8_top/2, barb8_h],
    [barb8_bot/2, barb8_h],
    [barb8_top/2, 2*barb8_h],
    [collar_d/2,  2*barb8_h],
    [collar_d/2,  2*barb8_h + collar_h],
    [barb5_bot/2, 2*barb8_h + collar_h],
    [barb5_top/2, 2*barb8_h + collar_h + barb5_h],
    [barb5_bot/2, 2*barb8_h + collar_h + barb5_h],
    [barb5_top/2, 2*barb8_h + collar_h + 2*barb5_h],
    [0, 2*barb8_h + collar_h + 2*barb5_h]
];

// Build the rotationally symmetric body, then subtract the bore.
// The whole part is translated so it is centred on the origin in X and Y.
translate([-collar_d/2, -collar_d/2, 0]) {
    difference() {
        rotate_extrude($fn)
            polygon(profile);

        // Bore: 3 mm diameter, extended 1 mm past both ends to avoid coplanar faces.
        cylinder(h = z3 + 2, d = bore_d, $fn = $fn);
    }
}