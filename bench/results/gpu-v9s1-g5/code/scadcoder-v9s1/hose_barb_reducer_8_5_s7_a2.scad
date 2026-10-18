// Hose-barb reducer: joins 8 mm ID tubing to 5 mm ID tubing
// Print orientation: standing upright along Z, centred on origin in X/Y

// ---------------- Parameters ----------------
reducer_d      = 10;   // bore diameter (through-hole)
tubing_a_od    = 7.5;  // outer diameter of 8 mm tubing (barb bottom)
tubing_a_top   = 9.5;  // outer diameter of 8 mm tubing (barb top)
barb_a_h       = 10;   // height of each 8 mm tubing barb
barb_a_count   = 2;    // number of 8 mm tubing barbs, stacked
collar_d       = 12;   // outer diameter of the collar
collar_h       = 5;    // collar height (z = 20 to z = 25)
tubing_b_od    = 6.5;  // outer diameter of 5 mm tubing (barb bottom)
tubing_b_top   = 5.0;  // outer diameter of 5 mm tubing (barb top)
barb_b_h       = 8;    // height of each 5 mm tubing barb
barb_b_count   = 2;    // number of 5 mm tubing barbs, stacked
eps            = 0.5;  // overshoot for clean boolean cuts
overlap         = 0.01; // small overlap so adjacent barbs fuse

// Derived
barb_a_len = barb_a_h + overlap;   // extended length of 8 mm barbs
barb_b_len = barb_b_h + overlap;   // extended length of 5 mm barbs

// ---------------- Model ----------------
difference() {
    union() {
        // 8 mm tubing barbs: sawtooth profile, stacked
        for (i = [0 : barb_a_count - 1]) {
            translate([0, 0, i * barb_a_h])
                cylinder(h = barb_a_len,
                         r = (z) -> (z < barb_a_h ?
                                    tubing_a_od + 2 * (tubing_a_top - tubing_a_od) / barb_a_h :
                                    tubing_a_od));
        }

        // Collar
        translate([0, 0, 20])
            cylinder(h = collar_h, d = collar_d);

        // 5 mm tubing barbs: shrinking profile, stacked
        for (i = [0 : barb_b_count - 1]) {
            translate([0, 0, 25 + i * barb_b_h])
                cylinder(h = barb_b_len,
                         r = (z) -> (z < 25 + barb_b_h ?
                                    tubing_b_od - 2 * (tubing_b_od - tubing_b_top) / barb_b_h * (z - 25) / barb_b_h :
                                    tubing_b_od));
        }
    }

    // Full-length bore
    translate([0, 0, -eps])
        cylinder(h = 41 + 2 * eps, d = reducer_d);
}