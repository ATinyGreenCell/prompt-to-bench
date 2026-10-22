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

// Build the full outer profile as a single closed polygon in the XZ plane.
// Each barb is a sawtooth: linear ramp then vertical step back.
// The profile is revolved about Z to form the solid.

// Collect all profile points in order (counter-clockwise in XZ, starting at base centre)
profile_pts = concat(
    // Base centre to base radius of first 8 mm barb
    [[0, 0], [barb8_od0/2, 0]],

    // 8 mm barbs: for each, ramp up to top radius, then step back to base radius
    [for (i = [0 : n8-1]) [
        [barb8_od1/2, i * barb8_h + barb8_h],
        [barb8_od0/2, i * barb8_h + barb8_h]
    ]],

    // Collar: step out to collar radius at z8, straight up to zc
    [[collar_d/2, z8], [collar_d/2, zc]],

    // 5 mm barbs: for each, ramp down to top radius, then step back out to base radius
    [for (i = [0 : n5-1]) [
        [barb5_od1/2, zc + i * barb5_h + barb5_h],
        [barb5_od0/2, zc + i * barb5_h + barb5_h]
    ]],

    // Close at top centre
    [[0, ztop]]
);

// ---- Main part ----
// Revolve the outer profile, then subtract the bore.
difference() {
    rotate_extrude($fn = 64)
        polygon(profile_pts);

    // Bore: cylinder extending 1 mm past both ends to avoid coplanar faces
    cylinder(h = ztop + 2, d = bore_d, center = [0, 0, ztop/2]);
}