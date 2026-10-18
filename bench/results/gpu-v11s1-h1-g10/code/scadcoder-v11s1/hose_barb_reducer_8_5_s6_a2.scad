// Hose-barb reducer: 8 mm ID -> 5 mm ID
// Print orientation: standing upright along +Z

$fn = 64;

// ---- Dimensions (mm) ----
bore        = 3;    // through-bore diameter
tube_id1    = 8;    // larger tubing inner diameter
tube_id2    = 5;    // smaller tubing inner diameter
barb_h1     = 10;   // height of each 8 mm barb
barb_od1_b  = 7.5;  // 8 mm barb outer diameter at bottom
barb_od1_t  = 9.5;  // 8 mm barb outer diameter at top
collar_d    = 12;   // collar diameter (z = 20 to 25)
barb_h2     = 8;    // height of each 5 mm barb
barb_od2_b  = 6.5;  // 5 mm barb outer diameter at bottom
barb_od2_t  = 5.0;  // 5 mm barb outer diameter at top
total_h     = 41;   // overall height

eps = 0.5;          // overlap for clean boolean cuts

// ---- Derived ----
z0 = 0;
z1 = barb_h1;       // top of first 8 mm barb
z2 = z1 + barb_h1;  // top of second 8 mm barb / bottom of collar
z3 = z2 + 5;        // top of collar
z4 = z3 + barb_h2;  // top of first 5 mm barb
z5 = z4 + barb_h2;  // top of second 5 mm barb (= total_h)

// ---- Model ----
difference() {
    union() {
        // 8 mm tubing barbs (sawtooth profile)
        for (i = [0 : 1])
            translate([0, 0, z0 + i * barb_h1])
                linear_extrude(height = barb_h1)
                    polygon([
                        [-barb_od1_b / 2, i * barb_h1],
                        [ barb_od1_t / 2, i * barb_h1],
                        [ barb_od1_t / 2, i * barb_h1 + eps],
                        [-barb_od1_b / 2, i * barb_h1 + eps]
                    ]);

        // Collar
        translate([0, 0, z2])
            cylinder(d = collar_d, h = 5);

        // 5 mm tubing barbs (sawtooth profile)
        for (i = [0 : 1])
            translate([0, 0, z3 + i * barb_h2])
                linear_extrude(height = barb_h2)
                    polygon([
                        [-barb_od2_b / 2, i * barb_h2],
                        [ barb_od2_t / 2, i * barb_h2],
                        [ barb_od2_t / 2, i * barb_h2 + eps],
                        [-barb_od2_b / 2, i * barb_h2 + eps]
                    ]);
    }

    // Through-bore
    translate([0, 0, -eps])
        cylinder(d = bore, h = total_h + 2 * eps);
}