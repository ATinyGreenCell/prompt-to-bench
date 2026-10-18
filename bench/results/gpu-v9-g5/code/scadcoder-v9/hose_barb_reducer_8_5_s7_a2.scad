// Hose-barb reducer: 8 mm ID tubing end (z = 0..20) -> 5 mm ID tubing end (z = 25..41)
// Print orientation: standing upright along +Z, centred on the Z axis.

// ---------------- Parameters ----------------
tube_a_id   = 8;    // first tubing inner diameter (mm)
tube_b_id   = 5;    // second tubing inner diameter (mm)
bore        = 3;    // through-bore diameter (mm)
eps         = 0.5;  // cutter overshoot past faces (mm)

// first end: barbs for 8 mm tubing
end_a_h     = 20;   // end A height (mm)
end_a_n     = 2;    // number of barbs stacked in end A
end_a_d0    = 7.5;  // barb outer diameter at bottom of end A (mm)
end_a_d1    = 9.5;  // barb outer diameter at top of end A (mm)

// second end: barbs for 5 mm tubing
end_b_h     = 8;    // end B height (mm)
end_b_d0    = 6.5;  // barb outer diameter at bottom of end B (mm)
end_b_d1    = 5.0;  // barb outer diameter at top of end B (mm)

// collar (for a clean transition between the two end blocks)
collar_d    = 12;   // collar outer diameter (mm)
collar_h    = 5;    // collar height (mm)

total_h     = end_a_h + collar_h + end_b_h;  // overall part height (mm)

$fn = 96;

// ---------------- Model ----------------
difference() {
    union() {
        // End A: stacked barbs for 8 mm tubing
        for (i = [0 : end_a_n - 1]) {
            translate([0, 0, i * end_a_h / (end_a_n - 1)])
                linear_extrude(height = end_a_h / (end_a_n - 1))
                    polygon([
                        [0, end_a_d0 / 2],
                        [0, -end_a_d0 / 2],
                        [end_a_d1 / 2, 0],
                        [-end_a_d1 / 2, 0]
                    ]);
        }

        // Collar
        translate([0, 0, end_a_h])
            cylinder(d = collar_d, h = collar_h);

        // End B: stacked barbs for 5 mm tubing
        for (i = [0 : end_b_n - 1]) {
            translate([0, 0, end_a_h + collar_h + i * end_b_h / (end_b_n - 1)])
                linear_extrude(height = end_b_h / (end_b_n - 1))
                    polygon([
                        [0, end_b_d0 / 2],
                        [0, -end_b_d0 / 2],
                        [end_b_d1 / 2, 0],
                        [-end_b_d1 / 2, 0]
                    ]);
        }
    }

    // Through-bore
    translate([0, 0, -eps])
        cylinder(d = bore, h = total_h + 2 * eps);
}