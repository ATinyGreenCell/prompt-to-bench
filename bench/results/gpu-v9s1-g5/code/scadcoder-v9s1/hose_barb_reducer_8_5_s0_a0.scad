// Hose-barb reducer: 8 mm ID tubing to 5 mm ID tubing
// Print orientation: standing upright along Z, centred on origin in X/Y

$fn = 96;

// ---- Dimensions (mm) ----
eps      = 0.5;     // cutter overshoot
barb_h8  = 10;      // height of each 8 mm barb
od8_bot  = 7.5;     // outer diameter of 8 mm barb at bottom
od8_top  = 9.5;     // outer diameter of 8 mm barb at top
collar_d = 12;      // diameter of cylindrical collar
barb_h5  = 8;       // height of each 5 mm barb
od5_bot  = 6.5;     // outer diameter of 5 mm barb at bottom
od5_top  = 5.0;     // outer diameter of 5 mm barb at top
bore     = 3;       // central through-bore diameter
length8  = 20;      // z extent of 8 mm tubing section
length5  = 16;      // z extent of 5 mm tubing section (z = 25 to 41)
overlap  = 0.01;    // small overlap between stacked barbs for clean union

// ---- Model ----
difference() {
    union() {
        // 8 mm tubing section: two stacked barbs with sawtooth profile
        for (i = [-1, 1])
            translate([0, 0, i > 0 ? overlap : 0])
                linear_extrude(height = barb_h8)
                    polygon([
                        [-od8_bot / 2, -od8_bot / 2],
                        [ od8_bot / 2, -od8_bot / 2],
                        [ od8_bot / 2, od8_bot / 2],
                        [-od8_bot / 2, od8_bot / 2]
                    ]);
        // collar
        translate([0, 0, length8])
            cylinder(d = collar_d, h = 5);
        // 5 mm tubing section: two stacked barbs, shrinking OD
        for (i = [-1, 1])
            translate([0, 0, length8 + (i > 0 ? overlap : 0)])
                linear_extrude(height = barb_h5)
                    polygon([
                        [-od5_bot / 2, -od5_bot / 2],
                        [ od5_bot / 2, -od5_bot / 2],
                        [ od5_bot / 2, od5_bot / 2],
                        [-od5_bot / 2, od5_bot / 2]
                    ]);
    }
    // central bore through full length
    translate([0, 0, -eps])
        cylinder(d = bore, h = length8 + 5 + length5 + 2 * eps);
}