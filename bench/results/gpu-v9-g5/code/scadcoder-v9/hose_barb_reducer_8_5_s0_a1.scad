// Straight hose-barb reducer: 8 mm ID tubing end with two stacked barbs,
// a 12 mm collar, and a second end with two stacked barbs for 5 mm ID tubing.
// A 3 mm bore runs straight through the full length.
// Print orientation: standing upright along +Z.

$fn = 96;

// ---- 8 mm tubing end ----
tube_a_id   = 8;    // tubing inner diameter
barb_a_h    = 10;   // barb height
barb_a_d0   = 7.5;  // barb outer diameter at bottom
barb_a_d1   = 9.5;  // barb outer diameter at top
barb_a_n    = 2;    // number of barbs, stacked
tube_a_len  = 20;   // end length (z = 0 to 20)

// ---- Collar ----
collar_d    = 12;   // collar diameter
collar_h    = 5;    // collar height (z = 20 to 25)

// ---- 5 mm tubing end ----
tube_b_id   = 5;    // tubing inner diameter
barb_b_h    = 8;    // barb height
barb_b_d0   = 6.5;  // barb outer diameter at bottom
barb_b_d1   = 5.0;  // barb outer diameter at top
barb_b_n    = 2;    // number of barbs, stacked
tube_b_len  = 16;   // end length (z = 25 to 41)

// ---- Bore ----
bore_d      = 3;    // through-bore diameter

// ---- Modelling helpers ----
overlap     = 0.01; // small overlap so adjacent shapes fuse cleanly
eps         = 0.5;  // cutter overshoot past faces

// Total height of the part
total_h = tube_a_len + collar_h + tube_b_len;

module barbed_end(len, d0, d1, nh) {
    // Each barb is a cone from its bottom diameter up to the top diameter of the end,
    // then a straight step back down to the bottom diameter (sawtooth profile).
    for (i = [0 : nh - 1]) {
        translate([0, 0, i * (len / nh)])
            linear_extrude(height = len / nh)
                polygon([
                    [0, 0],
                    [d0 / 2, 0],
                    [d1 / 2, len / (2 * nh)],
                    [-d1 / 2, len / (2 * nh)],
                    [-d0 / 2, 0]
                ]);
    }
}

difference() {
    union() {
        // First end (z = 0 to 20)
        translate([0, 0, 0])
            barbed_end(tube_a_len, barb_a_d0, barb_a_d1, barb_a_n);

        // Collar (z = 20 to 25)
        translate([0, 0, tube_a_len - overlap])
            cylinder(d = collar_d, h = collar_h + overlap);

        // Second end (z = 25 to 41)
        translate([0, 0, tube_a_len + collar_h])
            barbed_end(tube_b_len, barb_b_d0, barb_b_d1, barb_b_n);
    }

    // Through bore
    translate([0, 0, -eps])
        cylinder(d = bore_d, h = total_h + 2 * eps);
}