// Hose-barb reducer: 8 mm ID silicone tubing (bottom) to 5 mm ID silicone tubing (top)
// Printed upright, rotationally symmetric about Z, 3 mm bore through full length.

// ---- Global ----
$fn = 64;

// ---- Bore ----
bore_d = 3;          // straight through-bore diameter
bore_r = bore_d / 2;

// ---- 8 mm tubing barbs (bottom, z 0..20) ----
barb8_h   = 10;      // height of each 8 mm barb
barb8_bot = 7.5;     // outer diameter at barb bottom
barb8_top = 9.5;     // outer diameter at barb top (sawtooth peak)
n8        = 2;      // number of 8 mm barbs

// ---- Collar (z 20..25) ----
collar_d  = 12;      // collar outer diameter
collar_h  = 5;       // collar height

// ---- 5 mm tubing barbs (top, z 25..41) ----
barb5_h   = 8;       // height of each 5 mm barb
barb5_bot = 6.5;     // outer diameter at barb bottom
barb5_top = 5.0;     // outer diameter at barb top (sawtooth peak)
n5        = 2;      // number of 5 mm barbs

// ---- Derived ----
z8_start  = 0;
z8_end    = z8_start + n8 * barb8_h;          // 20
zcollar   = z8_end;
z5_start  = zcollar + collar_h;               // 25
z5_end    = z5_start + n5 * barb5_h;         // 41
total_h   = z5_end;

// Sawtooth profile for a single 8 mm barb (local z 0..barb8_h)
// bottom radius = barb8_bot/2, top radius = barb8_top/2, then step back to bottom radius.
profile8 = [
    [barb8_bot/2, 0],
    [barb8_top/2, barb8_h],
    [barb8_bot/2, barb8_h],
    [barb8_bot/2, 0]
];

// Sawtooth profile for a single 5 mm barb (local z 0..barb5_h)
// bottom radius = barb5_bot/2, top radius = barb5_top/2, then step back to bottom radius.
profile5 = [
    [barb5_bot/2, 0],
    [barb5_top/2, barb5_h],
    [barb5_bot/2, barb5_h],
    [barb5_bot/2, 0]
];

// ---- Build the solid ----
difference() {
    union() {
        // 8 mm barbs (bottom)
        for (i = [0 : n8 - 1]) {
            translate([0, 0, z8_start + i * barb8_h])
                rotate_extrude(profile8);
        }

        // Collar
        translate([0, 0, zcollar])
            cylinder(h = collar_h, d = collar_d, $fn = $fn);

        // 5 mm barbs (top)
        for (i = [0 : n5 - 1]) {
            translate([0, 0, z5_start + i * barb5_h])
                rotate_extrude(profile5);
        }
    }

    // Bore: extends 1 mm past both ends so no faces are coplanar
    translate([0, 0, -1])
        cylinder(h = total_h + 2, d = bore_d, $fn = $fn);
}