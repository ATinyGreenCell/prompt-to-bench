// Straight hose-barb reducer: 8 mm tubing (barbs) -> 5 mm tubing (barbs)
// Print orientation: standing upright along Z, centred on origin in X/Y

// ---------------- Parameters ----------------
tube_d1      = 8;    // inner diameter of the larger tubing
tube_d2      = 5;    // inner diameter of the smaller tubing
bore_d       = 3;    // through-bore diameter (full length)

z_barb1_h    = 20;   // height of the 8 mm barbs (z = 0 .. 20)
z_barb1_od0  = 7.5;  // outer diameter of 8 mm barbs at bottom
z_barb1_od1  = 9.5;  // outer diameter of 8 mm barbs at top

z_collar_h   = 5;    // height of the cylindrical collar (z = 20 .. 25)
z_collar_d   = 12;   // outer diameter of the collar

z_barb2_h    = 16;   // height of the 5 mm barbs (z = 25 .. 41)
z_barb2_od0  = 6.5;  // outer diameter of 5 mm barbs at bottom
z_barb2_od1  = 5.0;  // outer diameter of 5 mm barbs at top

eps          = 0.5;  // overshoot for clean boolean cuts
$fn          = 96;   // curve resolution

// ---------------- Derived ----------------
tube_r1 = tube_d1 / 2 + 0.8;  // 8 mm barb outer radius at 3 mm bore
tube_r2 = tube_d2 / 2 + 0.8;  // 5 mm barb outer radius at 3 mm bore
collar_r = z_collar_d / 2;

// ---------------- Model ----------------
difference() {
    union() {
        // 8 mm barbs: sawtooth profile, stacked (two identical)
        for (i = [0 : 1])
            translate([0, 0, i * z_barb1_h / 2])
                linear_extrude(height = z_barb1_h / 2)
                    polygon([
                        [-tube_r1, 0],
                        [ tube_r1, 0],
                        [ tube_r1, z_barb1_od1 - tube_r1],  // top outer corner
                        [-tube_r1, z_barb1_od1 - tube_r1]
                    ]);

        // Cylindrical collar (z = 20 .. 25)
        translate([0, 0, z_barb1_h])
            cylinder(h = z_collar_h, r = collar_r);

        // 5 mm barbs: tapered then stepped back out, stacked (two identical)
        for (i = [0 : 1])
            translate([0, 0, z_barb1_h + z_collar_h + i * z_barb2_h / 2])
                linear_extrude(height = z_barb2_h / 2)
                    polygon([
                        [-tube_r2, 0],
                        [ tube_r2, 0],
                        [ tube_r2, z_barb2_od0 - tube_r2],  // bottom outer corner
                        [ z_barb2_od1 - tube_r2, z_barb2_od0 - tube_r2],  // top outer corner
                        [-z_barb2_od1 + tube_r2, z_barb2_od0 - tube_r2],
                        [-tube_r2, z_barb2_od0 - tube_r2]
                    ]);
    }

    // Full-length 3 mm bore
    translate([0, 0, -eps])
        cylinder(h = z_barb1_h + z_collar_h + z_barb2_h + 2 * eps, d = bore_d);
}