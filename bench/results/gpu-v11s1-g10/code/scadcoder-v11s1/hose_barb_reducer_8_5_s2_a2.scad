// Hose-barb reducer: 8 mm tubing -> 5 mm tubing
// Print orientation: standing upright along +Z

$fn = 64;

// ---- Dimensions (mm) ----
tube8_id     = 8;    // 8 mm tubing inner diameter
tube8_od     = 9.5;  // 8 mm tubing outer diameter
tube8_len    = 20;   // 8 mm tubing section length (z = 0 to 20)

tube5_id     = 5;    // 5 mm tubing inner diameter
tube5_od     = 6.5;  // 5 mm tubing outer diameter
tube5_len    = 16;   // 5 mm tubing section length (z = 25 to 41)

bore         = 3;    // through-bore diameter

collar_od    = 12;   // collar outer diameter (z = 20 to 25)
collar_len   = 5;    // collar length

overlap      = 0.5;  // overlap between stacked barbs
eps          = 0.01; // cutting overshoot

// ---- Model ----
difference() {
    union() {
        // 8 mm barbs
        for (i = [0 : 1])
            translate([0, 0, i * (tube8_len - overlap)])
                linear_extrude(height = tube8_len - overlap)
                    polygon([
                        [-tube8_od / 2, 0],
                        [tube8_od / 2, 0],
                        [tube8_od / 2, tube8_len - overlap],
                        [-tube8_od / 2, tube8_len - overlap]
                    ]);

        // Collar
        translate([0, 0, tube8_len])
            cylinder(d = collar_od, h = collar_len);

        // 5 mm barbs
        for (i = [0 : 1])
            translate([0, 0, tube8_len + collar_len + i * (tube5_len - overlap)])
                linear_extrude(height = tube5_len - overlap)
                    polygon([
                        [-tube5_od / 2, 0],
                        [tube5_od / 2, 0],
                        [tube5_od / 2, tube5_len - overlap],
                        [-tube5_od / 2, tube5_len - overlap]
                    ]);
    }

    // Through-bore
    translate([0, 0, -eps])
        cylinder(d = bore, h = tube8_len + collar_len + tube5_len + 2 * eps);
}