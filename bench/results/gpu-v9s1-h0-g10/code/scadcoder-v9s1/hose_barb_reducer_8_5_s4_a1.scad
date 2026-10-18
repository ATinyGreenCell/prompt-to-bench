// Straight hose-barb reducer: 8 mm ID tubing to 5 mm ID tubing
// Print orientation: standing upright along Z axis

$fn = 96;

// ---- Dimensions (mm) ----
barb8_od_bottom = 7.5;   // 8 mm tubing barb: OD at bottom
barb8_od_top    = 9.5;   // 8 mm tubing barb: OD at top
barb8_height    = 10;    // 8 mm tubing barb: height
barb5_od_bottom = 6.5;   // 5 mm tubing barb: OD at bottom
barb5_od_top    = 5.0;   // 5 mm tubing barb: OD at top
barb5_height    = 8;     // 5 mm tubing barb: height
collar_d        = 12;    // cylindrical collar: diameter
collar_h        = 5;     // cylindrical collar: height
bore_d          = 3;     // through-bore diameter
overlap         = 0.5;   // overlap between stacked barbs for a clean union

total_length = barb8_height + collar_h + barb5_height;  // 23 mm overall

// ---- Model ----
union() {
    // 8 mm tubing barbs (sawtooth profile), stacked
    for (i = [0 : 1]) {
        translate([0, 0, i * barb8_height - (i > 0 ? overlap : 0)])
            linear_extrude(height = 1)
                polygon([
                    [-barb8_od_bottom / 2, 0],
                    [ barb8_od_bottom / 2, 0],
                    [ 0, barb8_height],
                    [ -barb8_od_bottom / 2, barb8_height]
                ]);
    }

    // Cylindrical collar
    translate([0, 0, barb8_height - overlap, 0])
        cylinder(d = collar_d, h = collar_h + (overlap < 0 ? -overlap : 0));

    // 5 mm tubing barbs (shrinking profile), stacked
    for (i = [0 : 1]) {
        translate([0, 0, i * barb5_height - (i > 0 ? overlap : 0)])
            linear_extrude(height = 1)
                polygon([
                    [-barb5_od_bottom / 2, 0],
                    [ barb5_od_bottom / 2, 0],
                    [ 0, barb5_height],
                    [ -barb5_od_top / 2, barb5_height],
                    [ barb5_od_top / 2, barb5_height]
                ]);
    }
}

// Through-bore, extending past both end faces
difference() {
    // (Current) bounding box of the part
    translate([0, 0, -1])
        hull() {
            // lower end
            translate([0, 0, 0])
                linear_extrude(height = 1)
                    polygon([
                        [-barb8_od_bottom / 2, 0],
                        [ barb8_od_bottom / 2, 0],
                        [ 0, barb8_height],
                        [ -barb8_od_bottom / 2, barb8_height]
                    ]);
            // upper end
            translate([0, 0, total_length - overlap])
                linear_extrude(height = 1)
                    polygon([
                        [-barb5_od_bottom / 2, 0],
                        [ barb5_od_bottom / 2, 0],
                        [ 0, barb5_height],
                        [ -barb5_od_top / 2, barb5_height],
                        [ barb5_od_top / 2, barb5_height]
                    ]);
        }
    // bore
    translate([0, 0, -1])
        cylinder(d = bore_d, h = total_length + 2);
}