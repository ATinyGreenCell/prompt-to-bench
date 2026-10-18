// Hose-barb reducer: joins 8 mm ID tubing to 5 mm ID tubing
// Print orientation: standing upright along +Z, centred on origin in X/Y

$fn = 96;

// ---- Dimensions (mm) ----
eps      = 0.5;         // overcut for clean differences
barb_h8  = 10;          // height of each 8 mm barb
barb_od8_bottom = 7.5;  // outer diameter of 8 mm barb at bottom
barb_od8_top    = 9.5;  // outer diameter of 8 mm barb at top
collar_d      = 12;     // diameter of the collar
barb_h5  = 8;           // height of each 5 mm barb
barb_od5_bottom = 6.5;  // outer diameter of 5 mm barb at bottom
barb_od5_top    = 5.0;  // outer diameter of 5 mm barb at top
bore_d      = 3;        // central through-bore diameter
length8     = 20;       // z extent of the 8 mm tubing section
length5     = 16;       // z extent of the 5 mm tubing section (z = 25 to 41)
length_coll = 5;        // z extent of the collar (z = 20 to 25)

// ---- Model ----
difference() {
    union() {
        // 8 mm tubing section: two stacked barbs with sawtooth profile
        for (i = [0 : 1])
            translate([0, 0, i * barb_h8])
                linear_extrude(height = bore_d + 2 * eps, center = true)
                    polygon([
                        [-barb_od8_bottom / 2, 0],
                        [ barb_od8_bottom / 2, 0],
                        [0, barb_h8],
                        [-0, barb_h8]
                    ]);
        // collar
        translate([0, 0, length8])
            cylinder(d = collar_d, h = length_coll);
        // 5 mm tubing section: two stacked barbs, shrinking OD
        for (i = [0 : 1])
            translate([0, 0, length8 + length_coll + i * barb_h5])
                linear_extrude(height = bore_d + 2 * eps, center = true)
                    polygon([
                        [-barb_od5_bottom / 2, 0],
                        [ barb_od5_bottom / 2, 0],
                        [0, barb_h5],
                        [-0, barb_h5]
                    ]);
    }
    // central through-bore
    translate([0, 0, -eps])
        cylinder(d = bore_d, h = length8 + length_coll + 2 * barb_h5 + 2 * eps);
}