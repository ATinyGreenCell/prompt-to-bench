// Hose-barb reducer: joins 8 mm ID tubing to 5 mm ID tubing
// Print orientation: standing upright along +Z, centred on origin in X/Y

// ---------------- Parameters ----------------
reducer_d      = 10;   // bore diameter (through-hole)
tube8_d        = 8;    // inner diameter of first tubing set
tube5_d        = 5;    // inner diameter of second tubing set
barb8_h        = 10;   // height of each 8 mm barb
barb8_od_bot   = 7.5;  // outer diameter of 8 mm barb at bottom
barb8_od_top   = 9.5;  // outer diameter of 8 mm barb at top
barb8_step     = 7.5;  // outer diameter after sawtooth step
collar_d       = 12;   // diameter of collar (z = 20 to 25)
barb5_h        = 8;    // height of each 5 mm barb
barb5_od_bot   = 6.5;  // outer diameter of 5 mm barb at bottom
barb5_od_top   = 5.0;  // outer diameter of 5 mm barb at top
barb5_step     = 6.5;  // outer diameter after sawtooth step
eps            = 0.5;  // overshoot for clean boolean cuts
$fn            = 96;   // curve resolution

// ---------------- Model ----------------
difference() {
    union() {
        // 8 mm tubing section: two stacked barbs with sawtooth profile
        for (z = [0, barb8_h])
            translate([0, 0, z])
                linear_extrude(height = reducer_d + 2 * eps, center = true)
                    polygon([
                        [0, 0],
                        [barb8_od_bot / 2, barb8_h],
                        [barb8_od_top / 2, 0],
                        [barb8_step / 2, barb8_h]
                    ]);

        // collar (z = 20 to 25)
        translate([0, 0, 20])
            cylinder(d = collar_d, h = 5);

        // 5 mm tubing section: two stacked barbs with sawtooth profile
        for (z = [25, 25 + barb5_h])
            translate([0, 0, z])
                linear_extrude(height = reducer_d + 2 * eps, center = true)
                    polygon([
                        [0, 0],
                        [barb5_od_bot / 2, barb5_h],
                        [barb5_od_top / 2, 0],
                        [barb5_step / 2, barb5_h]
                    ]);
    }

    // full-length bore
    translate([0, 0, -eps])
        cylinder(d = reducer_d, h = reducer_d + 2 * eps);
}