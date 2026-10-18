// Hose-barb reducer: 8 mm tubing (barbs A) -> collar -> 5 mm tubing (barbs B)
// Print orientation: standing upright along +Z, centred on origin in X/Y

$fn = 64;

// ---- Dimensions (mm) ----
bore      = 3;    // through-bore diameter
barb_a_h  = 10;   // height of each 8 mm barb
barb_a_d  = 7.5;  // outer diameter of 8 mm barb (bottom)
barb_a_t  = 9.5;  // outer diameter of 8 mm barb (top)
collar_d  = 12;   // collar diameter (z = 20 to 25)
barb_b_h  = 8;    // height of each 5 mm barb
barb_b_d  = 6.5;  // outer diameter of 5 mm barb (bottom)
barb_b_t  = 5.0;  // outer diameter of 5 mm barb (top)
eps       = 0.5;  // overcut for clean differences

// ---- Derived ----
z0 = 0;
z_a = 20;         // top of 8 mm barbs
z_c = 25;         // top of collar / bottom of 5 mm barbs
z1 = 41;          // top of 5 mm barbs
n   = 2;          // number of stacked barbs on each side

// ---- Model ----
difference() {
    union() {
        // Barbs for 8 mm tubing
        for (i = [0 : n - 1])
            translate([0, 0, z0 + i * barb_a_h])
                linear_extrude(height = barb_a_h)
                    polygon([
                        [-barb_a_d / 2, 0],
                        [ barb_a_t / 2, 0],
                        [ barb_a_t / 2, -eps],
                        [-barb_a_d / 2, -eps]
                    ]);

        // Collar
        translate([0, 0, z_a])
            cylinder(d = collar_d, h = 5);

        // Barbs for 5 mm tubing
        for (i = [0 : n - 1])
            translate([0, 0, z_c + i * barb_b_h])
                linear_extrude(height = barb_b_h)
                    polygon([
                        [-barb_b_d / 2, 0],
                        [ barb_b_t / 2, 0],
                        [ barb_b_t / 2, eps],
                        [-barb_b_d / 2, eps]
                    ]);
    }

    // Full-length bore
    translate([0, 0, -eps])
        cylinder(d = bore, h = z1 + 2 * eps);
}