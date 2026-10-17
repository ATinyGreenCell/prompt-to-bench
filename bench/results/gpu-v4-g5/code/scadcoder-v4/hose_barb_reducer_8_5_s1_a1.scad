// Tubing reducer - joins two sizes of silicone tubing via barbs and a collar
// Print orientation: standing upright along +Z, centred on origin in X/Y

// ---------------- Parameters ----------------
reducer_d      = 8;   // outer diameter of the 8 mm tubing (at the joint)
reducer_d2     = 5;   // outer diameter of the 5 mm tubing (at the joint)
bore_d         = 3;   // through-bore diameter along Z
sawtooth_d     = 7.5; // outer diameter of sawtooth barbs at their bottom
sawtooth_d2    = 9.5; // outer diameter of sawtooth barbs at their top
sawtooth_h     = 10;  // height of each sawtooth barb
sawtooth_n     = 2;   // number of stacked sawtooth barbs
collar_d       = 12;  // outer diameter of the cylindrical collar
collar_h       = 5;   // height of the collar
sawtooth_d3    = 6.5; // outer diameter of small barbs at their bottom
sawtooth_d4    = 5.0; // outer diameter of small barbs at their top
sawtooth_h2    = 8;   // height of each small barb
sawtooth_n2     = 2;  // number of stacked small barbs
eps            = 0.5; // overshoot for clean boolean cuts

total_h = sawtooth_n * sawtooth_h + collar_h + sawtooth_n2 * sawtooth_h2; // 45 mm

// ---------------- Model ----------------
difference() {
    union() {
        // 8 mm tubing section: stacked sawtooth barbs
        for (i = [0 : sawtooth_n - 1])
            translate([0, 0, i * sawtooth_h])
                linear_extrude(height = sawtooth_h)
                    polygon([[-1.5 * sawtooth_d, 0], [-1.5 * sawtooth_d2, sawtooth_h / 2],
                             [1.5 * sawtooth_d2, sawtooth_h / 2], [1.5 * sawtooth_d, 0]]);

        // Collar section
        cylinder(d = collar_d, h = collar_h);

        // 5 mm tubing section: stacked shrinking barbs
        for (i = [0 : sawtooth_n2 - 1])
            translate([0, 0, sawtooth_n * sawtooth_h + collar_h + i * sawtooth_h2])
                linear_extrude(height = sawtooth_h2)
                    polygon([[sawtooth_d3 / 2, 0], [sawtooth_d3 / 2, sawtooth_h2],
                             [sawtooth_d4 / 2, sawtooth_h2 / 2], [-sawtooth_d4 / 2, sawtooth_h2 / 2],
                             [-sawtooth_d3 / 2, 0]]);
    }

    // Through-bore along Z
    translate([0, 0, -eps])
        cylinder(d = bore_d, h = total_h + 2 * eps);
}