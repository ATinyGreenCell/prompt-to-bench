// Hose-barb reducer: 8 mm tubing (z = 0..20) to 5 mm tubing (z = 25..41)
// Print orientation: standing upright along +Z, centred on the Z axis

$fn = 64;

// ---- Dimensions (mm) ----
bore        = 3;    // central through-bore diameter
barb_od_8   = 9.5;  // outer diameter of 8 mm barbs at their tops
barb_h_8    = 10;   // height of each 8 mm barb
barb_start_8 = 7.5; // outer diameter of 8 mm barbs at their bottoms
collar_d    = 12;   // outer diameter of the collar (z = 20..25)
barb_od_5   = 5.0;  // outer diameter of 5 mm barbs at their tops
barb_h_5    = 8;    // height of each 5 mm barb
barb_start_5 = 6.5; // outer diameter of 5 mm barbs at their bottoms
overlap     = 0.5;  // axial overlap so adjacent parts fuse cleanly

// ---- Model ----
union() {
    // 8 mm tubing side (z = 0 to 20), two stacked barbs
    for (i = [0 : 1])
        translate([0, 0, i * barb_h_8])
            linear_extrude(height = barb_h_8)
                polygon([
                    [-barb_od_8 / 2, -barb_od_8 / 2],
                    [ barb_od_8 / 2, -barb_od_8 / 2],
                    [ barb_od_8 / 2,  barb_od_8 / 2],
                    [-barb_od_8 / 2,  barb_od_8 / 2]
                ]);

    // Collar (z = 20 to 25)
    translate([0, 0, 20])
        cylinder(d = collar_d, h = overlap);

    // 5 mm tubing side (z = 25 to 41), two stacked barbs
    for (i = [0 : 1])
        translate([0, 0, 25 + i * barb_h_5])
            linear_extrude(height = barb_h_5)
                polygon([
                    [-barb_od_5 / 2, -barb_od_5 / 2],
                    [ barb_od_5 / 2, -barb_od_5 / 2],
                    [ barb_od_5 / 2,  barb_od_5 / 2],
                    [-barb_od_5 / 2,  barb_od_5 / 2]
                ]);
}

// ---- Through-bore ----
translate([0, 0, -1])
    cylinder(d = bore, h = 43);