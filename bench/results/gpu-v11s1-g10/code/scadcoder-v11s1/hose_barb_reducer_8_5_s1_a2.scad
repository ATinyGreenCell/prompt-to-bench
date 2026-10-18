// Hose-barb reducer: 8 mm ID -> 5 mm ID
// Print orientation: standing upright along +Z

$fn = 64;

// ---- Dimensions (mm) ----
id_8     = 8.0;    // inner diameter of 8 mm tubing
id_5     = 5.0;    // inner diameter of 5 mm tubing
bore     = 3.0;    // through-bore diameter
base_d   = 7.5;    // barb outer diameter at bottom (8 mm side)
top_d    = 9.5;    // barb outer diameter at top (8 mm side)
h_8      = 10;     // height of each 8 mm barb
collar_d = 12;     // collar outer diameter (z = 20 to 25)
h_5      = 8;      // height of each 5 mm barb
eps      = 0.5;    // cutter overshoot past faces

total_h = 2*h_8 + 5 + 2*h_5;   // 41 mm overall length

// ---- Model ----
difference() {
    union() {
        // 8 mm tubing barbs (z = 0 to 20)
        for (i = [0 : 1])
            translate([0, 0, i*h_8])
                linear_extrude(height = h_8)
                    polygon([
                        [-(base_d/2), -(base_d/2)],
                        [-(base_d/2),  base_d/2],
                        [(top_d - base_d)/2, base_d/2],
                        [(top_d - base_d)/2, -(base_d/2)]
                    ]);

        // Collar (z = 20 to 25)
        translate([0, 0, 2*h_8])
            cylinder(d = collar_d, h = 5);

        // 5 mm tubing barbs (z = 25 to 41)
        for (i = [0 : 1])
            translate([0, 0, 5 + 2*h_8 + i*h_5])
                linear_extrude(height = h_5)
                    polygon([
                        [-(base_d/2), -(base_d/2)],
                        [-(base_d/2),  base_d/2],
                        [(base_d - id_5)/2, base_d/2],
                        [(base_d - id_5)/2, -(base_d/2)]
                    ]);
    }

    // Through-bore along Z
    translate([0, 0, -eps])
        cylinder(d = bore, h = total_h + 2*eps);
}