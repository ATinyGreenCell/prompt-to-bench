// Hose-barb reducer: 8 mm ID -> 5 mm ID
// Print orientation: standing upright along +Z

$fn = 64;

// ---- Dimensions (mm) ----
bore      = 3;    // through-bore diameter
tube_d1   = 8;    // larger tubing inner diameter
tube_d2   = 5;    // smaller tubing inner diameter
barb_h1   = 10;   // height of each 8 mm barb
barb_od1  = 7.5;  // outer diameter of 8 mm barbs at bottom
barb_od2  = 9.5;  // outer diameter of 8 mm barbs at top
collar_d  = 12;   // collar diameter (z = 20 to 25)
barb_h2   = 8;    // height of each 5 mm barb
barb_od3  = 6.5;  // outer diameter of 5 mm barbs at bottom
barb_od4  = 5.0;  // outer diameter of 5 mm barbs at top
eps       = 0.5;  // overshoot for clean cuts

// ---- Derived ----
z0 = 0;
z_barb1 = barb_h1;      // top of first 8 mm barb
z_barb2 = z_barb1 + barb_h1;  // top of second 8 mm barb (= collar start)
z_collar = z_barb2 + 5;  // top of collar (= 25)
z_end = z_collar + barb_h2;  // top of first 5 mm barb
n     = 2;             // number of stacked barbs per section

// ---- Profile (radius vs height), counter-clockwise ----
profile = [
    [barb_od1 / 2, z0],
    [barb_od2 / 2, z_barb1],
    [barb_od1 / 2, z_barb1 + 0.01],  // tiny flat at the sawtooth peak
    [barb_od3 / 2, z_barb2 + 0.01],  // step down between sections
    [barb_od4 / 2, z_end],
    [barb_od3 / 2, z_end + 0.01]     // tiny flat at the sawtooth peak
];

// ---- Model ----
difference() {
    rotate_extrude($fn = 128)
        linear_extrude(height = 1)
            polygon(profile);

    // through-bore
    translate([0, 0, z0 - eps])
        cylinder(d = bore, h = z_end + 2 * eps);
}