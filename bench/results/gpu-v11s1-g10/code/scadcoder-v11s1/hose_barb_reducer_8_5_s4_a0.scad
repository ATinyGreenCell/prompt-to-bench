// Hose-barb reducer: 8 mm ID -> 5 mm ID
// Print orientation: standing upright along +Z

$fn = 64;

// ---- Dimensions (mm) ----
id_8     = 8;    // inner diameter of 8 mm tubing
id_5     = 5;    // inner diameter of 5 mm tubing
bore     = 3;    // through-bore diameter
base_d   = 7.5;  // barb outer diameter at bottom
top_d    = 9.5;  // barb outer diameter at top (8 mm side)
collar_d = 12;   // collar outer diameter
collar_h = 5;    // collar height
len_8    = 20;   // height of 8 mm tubing section
len_5    = 16;   // height of 5 mm tubing section (z = 25 to z = 41)

eps = 0.5;       // cutter overshoot

// ---- Model ----
difference() {
    union() {
        // 8 mm tubing: two stacked barbs, sawtooth profile
        for (z = [0, len_8/2])
            translate([0, 0, z])
                linear_extrude(height = len_8/2)
                    polygon([
                        [-base_d/2, base_d/2],
                        [ top_d/2, base_d/2],
                        [ top_d/2, top_d/2],
                        [-base_d/2, top_d/2]
                    ]);

        // Collar
        translate([0, 0, len_8])
            cylinder(d = collar_d, h = collar_h);

        // 5 mm tubing: two stacked barbs, shrinking profile
        for (z = [len_8 + collar_h, len_8 + collar_h + len_5/2])
            translate([0, 0, z])
                linear_extrude(height = len_5/2)
                    polygon([
                        [-base_d/2, base_d/2],
                        [ top_d/2, base_d/2],
                        [ top_d/2, id_5/2],
                        [-base_d/2, id_5/2]
                    ]);
    }

    // Through-bore
    translate([0, 0, -eps])
        cylinder(d = bore, h = len_8 + collar_h + len_5 + 2*eps);
}