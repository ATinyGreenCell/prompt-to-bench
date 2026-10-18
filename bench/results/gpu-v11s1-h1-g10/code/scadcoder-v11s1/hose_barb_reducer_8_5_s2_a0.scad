// Hose-barb reducer: 8 mm ID -> 5 mm ID
// Print orientation: standing upright along +Z

$fn = 64;

// ---- Dimensions (mm) ----
tube_id_8     = 8;    // 8 mm tubing inner diameter
tube_id_5     = 5;    // 5 mm tubing inner diameter
bore          = 3;    // through-bore diameter
barb_h_8      = 10;   // 8 mm tubing barb height
barb_od_8_bot = 7.5;  // 8 mm barb outer diameter at bottom
barb_od_8_top = 9.5;  // 8 mm barb outer diameter at top
step_8        = 7.5;  // 8 mm barb outer diameter after step back
collar_h      = 5;    // collar height (z = 20 to 25)
collar_d      = 12;   // collar diameter
barb_h_5      = 8;    // 5 mm tubing barb height
barb_od_5_bot = 6.5;  // 5 mm barb outer diameter at bottom
barb_od_5_top = 5.0;  // 5 mm barb outer diameter at top
step_5        = 6.5;  // 5 mm barb outer diameter after step back
total_h       = 41;   // top of last 5 mm barb

eps = 0.5;            // cutter overshoot

// ---- Model ----
difference() {
    union() {
        // 8 mm barbs: z = 0 to 20
        for (i = [0 : 1])
            translate([0, 0, i * barb_h_8])
                linear_extrude(height = barb_h_8)
                    polygon([
                        [barb_od_8_bot / 2, 0],
                        [barb_od_8_top / 2, barb_h_8],
                        [step_8 / 2,        barb_h_8]
                    ]);
        // collar: z = 20 to 25
        translate([0, 0, total_h - collar_h])
            cylinder(h = collar_h, d = collar_d);
        // 5 mm barbs: z = 25 to 41
        for (i = [0 : 1])
            translate([0, 0, total_h - collar_h - (i + 1) * barb_h_5])
                linear_extrude(height = barb_h_5)
                    polygon([
                        [barb_od_5_bot / 2, 0],
                        [barb_od_5_top / 2, barb_h_5],
                        [step_5 / 2,        barb_h_5]
                    ]);
    }
    // through-bore
    translate([0, 0, -eps])
        cylinder(h = total_h + 2 * eps, d = bore);
}