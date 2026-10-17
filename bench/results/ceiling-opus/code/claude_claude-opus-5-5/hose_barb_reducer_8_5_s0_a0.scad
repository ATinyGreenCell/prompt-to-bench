// Straight hose-barb reducer: 8 mm ID tubing <-> 5 mm ID tubing
// Printed upright along Z, rotationally symmetric about Z axis.

$fn = 96;

// ---------- Through bore ----------
bore_d        = 3.0;    // straight through-bore diameter

// ---------- Large barbs (8 mm ID tubing), z = 0..20 ----------
big_barb_n    = 2;      // number of stacked barbs
big_barb_h    = 10.0;   // height of each barb
big_barb_d0   = 7.5;    // barb diameter at its bottom
big_barb_d1   = 9.5;    // barb diameter at its top (then steps back to d0)

// ---------- Collar, z = 20..25 ----------
collar_d      = 12.0;   // collar diameter
collar_h      = 5.0;    // collar height

// ---------- Small barbs (5 mm ID tubing), z = 25..41 ----------
small_barb_n  = 2;      // number of stacked barbs
small_barb_h  = 8.0;    // height of each barb
small_barb_d0 = 6.5;    // barb diameter at its bottom
small_barb_d1 = 5.0;    // barb diameter at its top (then steps back to d0)

// ---------- Derived ----------
big_len    = big_barb_n * big_barb_h;          // 20
collar_z   = big_len;                          // 20
small_z    = collar_z + collar_h;              // 25
total_h    = small_z + small_barb_n * small_barb_h; // 41
cut_extra  = 1.0;                              // bore overshoot past end faces

difference() {
    union() {
        // Large barbs (sawtooth, widening upward)
        for (i = [0 : big_barb_n - 1])
            translate([0, 0, i * big_barb_h])
                cylinder(h = big_barb_h, d1 = big_barb_d0, d2 = big_barb_d1);

        // Collar
        translate([0, 0, collar_z])
            cylinder(h = collar_h, d = collar_d);

        // Small barbs (sawtooth, narrowing upward)
        for (i = [0 : small_barb_n - 1])
            translate([0, 0, small_z + i * small_barb_h])
                cylinder(h = small_barb_h, d1 = small_barb_d0, d2 = small_barb_d1);
    }

    // Through bore
    translate([0, 0, -cut_extra])
        cylinder(h = total_h + 2 * cut_extra, d = bore_d);
}