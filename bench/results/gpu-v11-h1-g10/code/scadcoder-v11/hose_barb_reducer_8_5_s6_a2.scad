// Hose-barb reducer: 8 mm tubing (barbs A) -> collar -> 5 mm tubing (barbs B)
// Print orientation: standing upright along Z, centred on origin in X/Y

$fn = 96;

// ---- Dimensions (mm) ----
bore      = 3;    // through-bore diameter
barb_a_h  = 10;   // height of each 8 mm barb
barb_a_d  = 7.5;  // outer diameter of 8 mm barb (bottom)
barb_a_dt = 9.5;  // outer diameter of 8 mm barb (top)
collar_d  = 12;   // collar diameter
collar_h  = 5;    // collar height (z = 20 to 25)
barb_b_h  = 8;    // height of each 5 mm barb
barb_b_d  = 6.5;  // outer diameter of 5 mm barb (bottom)
barb_b_dt = 5;    // outer diameter of 5 mm barb (top)
eps       = 0.5;  // overcut for clean differences

// ---- Derived ----
z0 = 0;           // start of barbs A
z2 = z0 + barb_a_h; // bottom of collar (top of barbs A)
z5 = z2 + collar_h; // top of collar (bottom of barbs B)
zn = z5 + barb_b_h; // end of barbs B

// ---- Model ----
difference() {
    union() {
        // Barbs for 8 mm tubing
        for (i = [0 : 1])
            translate([0, 0, z0 + i * barb_a_h])
                linear_extrude(height = barb_a_h)
                    polygon([
                        [-barb_a_d / 2, 0],
                        [ barb_a_dt / 2, 0],
                        [ 0, barb_a_h]
                    ]);

        // Collar
        translate([0, 0, z2])
            cylinder(d = collar_d, h = collar_h);

        // Barbs for 5 mm tubing
        for (i = [0 : 1])
            translate([0, 0, z5 + i * barb_b_h])
                linear_extrude(height = barb_b_h)
                    polygon([
                        [-barb_b_d / 2, 0],
                        [ barb_b_dt / 2, 0],
                        [ 0, barb_b_h]
                    ]);
    }

    // Through-bore
    translate([0, 0, z0 - eps])
        cylinder(d = bore, h = zn + 2 * eps);
}