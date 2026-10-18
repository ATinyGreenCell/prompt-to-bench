// Hose-barb reducer: 8 mm tubing -> 5 mm tubing
// Print orientation: standing upright along +Z

$fn = 96;

// ---- Dimensions (mm) ----
tube_d1     = 8;    // first tubing inner diameter
tube_d2     = 5;    // second tubing inner diameter
bore        = 3;    // through-bore diameter
barb_h1     = 10;   // first barb height
barb_od1_b  = 7.5;  // first barb outer diameter at bottom
barb_od1_t  = 9.5;  // first barb outer diameter at top
collar_d    = 12;   // collar diameter
collar_h    = 5;    // collar height
barb_h2     = 8;    // second barb height
barb_od2_b  = 6.5;  // second barb outer diameter at bottom
barb_od2_t  = 5.0;  // second barb outer diameter at top
eps         = 0.5;  // overshoot for clean cuts

total_h = barb_h1 + collar_h + barb_h2;  // 23 mm

// ---- Model ----
difference() {
    union() {
        // First stacked barbs (z = 0 .. 10)
        for (i = [0, 1])
            translate([0, 0, i * barb_h1])
                linear_extrude(height = barb_h1)
                    polygon(points = [
                        [-barb_od1_b / 2, 0],
                        [ barb_od1_t / 2, 0],
                        [ barb_od1_t / 2, barb_h1],
                        [-barb_od1_b / 2, barb_h1]
                    ]);

        // Collar (z = 15 .. 20)
        translate([0, 0, barb_h1 + collar_h - collar_h])
            cylinder(d = collar_d, h = collar_h);

        // Second stacked barbs (z = 25 .. 33)
        for (i = [0, 1])
            translate([0, 0, barb_h1 + collar_h + i * barb_h2])
                linear_extrude(height = barb_h2)
                    polygon(points = [
                        [-barb_od2_b / 2, 0],
                        [ barb_od2_t / 2, 0],
                        [ barb_od2_t / 2, barb_h2],
                        [-barb_od2_b / 2, barb_h2]
                    ]);
    }

    // Through-bore
    translate([0, 0, -eps])
        cylinder(d = bore, h = total_h + 2 * eps);
}