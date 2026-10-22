// Straight hose-barb reducer: 8 mm ID silicone tubing (bottom) to 5 mm ID (top)
// Printed upright, rotationally symmetric about Z, 3 mm bore through full length.

// ---- Global ----
$fn = 64;

// ---- Bore ----
bore_d = 3;          // straight through-bore diameter (mm)

// ---- 8 mm tubing barbs (bottom, z 0..20) ----
barb8_h   = 10;      // height of each 8 mm barb (mm)
barb8_od0 = 7.5;     // outer diameter at barb bottom (mm)
barb8_od1 = 9.5;     // outer diameter at barb top (mm)
n8 = 2;              // number of 8 mm barbs stacked

// ---- Collar (z 20..25) ----
collar_d = 12;       // collar outer diameter (mm)
collar_h = 5;        // collar height (mm)

// ---- 5 mm tubing barbs (top, z 25..41) ----
barb5_h   = 8;       // height of each 5 mm barb (mm)
barb5_od0 = 6.5;     // outer diameter at barb bottom (mm)
barb5_od1 = 5.0;     // outer diameter at barb top (mm)
n5 = 2;              // number of 5 mm barbs stacked

// ---- Derived ----
z0 = 0;                          // base of part
z8 = n8 * barb8_h;              // top of 8 mm barbs = 20
zc = z8 + collar_h;             // top of collar = 25
z5 = zc + n5 * barb5_h;         // top of 5 mm barbs = 41
ztop = z5;                      // overall height = 41

// ---- Sawtooth profile (2D, revolved about Z) ----
// x = radius, y = height.  Each barb: linear ramp then vertical step back.
// 8 mm barbs: ramp 7.5 -> 9.5, step back to 7.5
// 5 mm barbs: ramp 6.5 -> 5.0, step back to 6.5

// Build one 8 mm barb profile (relative to its base)
module barb8_profile() {
    polygon([
        [barb8_od0/2, 0],
        [barb8_od1/2, barb8_h],
        [barb8_od0/2, barb8_h],
        [barb8_od0/2, 0]
    ]);
}

// Build one 5 mm barb profile (relative to its base)
module barb5_profile() {
    polygon([
        [barb5_od0/2, 0],
        [barb5_od1/2, barb5_h],
        [barb5_od0/2, barb5_h],
        [barb5_od0/2, 0]
    ]);
}

// Full outer profile of the part (closed polygon in the XZ plane, revolved)
// Points listed counter-clockwise starting at base centre.
// We build the outer silhouette as a single closed polygon:
//   Start at (0, 0)
//   Go out to base radius of first 8 mm barb
//   For each 8 mm barb: ramp up, step back
//   Collar: straight cylinder
//   For each 5 mm barb: ramp down, step back out
//   Close at top centre (0, ztop)

module outer_profile() {
    // Collect points
    pts = [
        [0, 0],
        [barb8_od0/2, 0]
    ];

    // 8 mm barbs
    for (i = [0 : n8-1]) {
        zbase = i * barb8_h;
        pts = concat(pts, [
            [barb8_od1/2, zbase + barb8_h],
            [barb8_od0/2, zbase + barb8_h]
        ]);
    }

    // Collar: from z8 to zc, radius = collar_d/2
    pts = concat(pts, [
        [collar_d/2, z8],
        [collar_d/2, zc]
    ]);

    // 5 mm barbs
    for (i = [0 : n5-1]) {
        zbase = zc + i * barb5_h;
        pts = concat(pts, [
            [barb5_od1/2, zbase + barb5_h],
            [barb5_od0/2, zbase + barb5_h]
        ]);
    }

    // Close at top centre
    pts = concat(pts, [
        [0, ztop]
    ]);

    polygon(pts);
}

// ---- Main part ----
// Revolve the outer profile, then subtract the bore.
difference() {
    rotate_extrude($fn = 64)
        outer_profile();

    // Bore: cylinder extending 1 mm past both ends to avoid coplanar faces
    cylinder(h = ztop + 2, d = bore_d, center = [0, 0, ztop/2]);
}