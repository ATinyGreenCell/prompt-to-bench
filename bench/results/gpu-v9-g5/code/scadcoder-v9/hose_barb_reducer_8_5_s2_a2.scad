// Hose-barb reducer: 8 mm ID -> 5 mm ID
// Print orientation: standing upright along Z

$fn = 64;

// ---- 8 mm tubing barbs ----
barb_h_8 = 20;    // barb height
barb_od_8 = 7.5;  // barb outer diameter (both end and sawtooth bottom)

// ---- 5 mm tubing barbs ----
barb_h_5 = 8;     // barb height
barb_od_5 = 6.5;  // barb outer diameter at bottom (sawtooth peak)

// ---- Common ----
collar_d = 12;    // collar diameter
collar_h = 5;     // collar height
bore_d = 3;       // through-bore diameter
overlap = 0.5;    // overlap between adjacent sections for a clean union

union() {
    // 8 mm barbs: z = 0 to 20
    for (i = [0 : 1])
        translate([0, 0, i * barb_h_8 / 2])
            linear_extrude(height = barb_h_8)
                polygon([
                    [0, -barb_od_8 / 2],
                    [0, barb_od_8 / 2],
                    [barb_od_8 / 2, barb_od_8 / 2 + 2],   // sawtooth tip
                    [-barb_od_8 / 2, barb_od_8 / 2 + 2]
                ]);

    // Collar: z = 20 to 25
    translate([0, 0, collar_h * overlap])
        cylinder(d = collar_d, h = collar_h - overlap);

    // 5 mm barbs: z = 25 to 41
    for (i = [0 : 1])
        translate([0, 0, 25 + i * barb_h_5])
            linear_extrude(height = barb_h_5)
                polygon([
                    [0, -barb_od_5 / 2],
                    [0, barb_od_5 / 2],
                    [barb_od_5 / 2, barb_od_5 / 2 + 2],   // small sawtooth
                    [-barb_od_5 / 2, barb_od_5 / 2 + 2]
                ]);
}

// Through-bore
translate([0, 0, -1])
    cylinder(d = bore_d, h = 42 + overlap);