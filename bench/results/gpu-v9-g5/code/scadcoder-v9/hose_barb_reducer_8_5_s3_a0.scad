// Hose-barb reducer: 8 mm tubing (z = 0..20) -> 5 mm tubing (z = 25..41)
// Print orientation: standing upright along Z

// ---------- Parameters ----------
reducer_length   = 41;     // overall length (z = 0 to z = 41)
bore             = 3;      // through-bore diameter
collar_d         = 12;     // collar diameter (z = 20 to z = 25)
eps              = 0.5;    // cutter overshoot past faces

// 8 mm tubing barbs (z = 0 to z = 20)
barb_8_height    = 20;     // barb height
barb_8_bottom_d  = 7.5;    // outer diameter at bottom of barbs
barb_8_top_d     = 9.5;    // outer diameter at top of barbs
barb_8_count     = 2;      // number of barbs, stacked

// 5 mm tubing barbs (z = 25 to z = 41)
barb_5_height    = 8;      // barb height
barb_5_bottom_d  = 6.5;    // outer diameter at bottom of barbs
barb_5_top_d     = 5.0;    // outer diameter at top of barbs
barb_5_count     = 2;      // number of barbs, stacked

// ---------- Derived ----------
barb_8_start_z = 0;
barb_8_end_z   = barb_8_start_z + barb_8_height;

barb_5_start_z = 25;
barb_5_end_z   = barb_5_start_z + barb_5_height;

// ---------- Model ----------
difference() {
    union() {
        // 8 mm tubing barbs
        for (i = [0 : barb_8_count - 1]) {
            translate([0, 0, barb_8_start_z + i * barb_8_height / barb_8_count])
                cylinder(h = barb_8_height / barb_8_count,
                         d = cylinder(d1 = barb_8_bottom_d,
                                     d2 = barb_8_top_d,
                                     h = barb_8_height / barb_8_count).d);
        }

        // Collar (z = 20 to z = 25)
        translate([0, 0, 20])
            cylinder(h = 5, d = collar_d);

        // 5 mm tubing barbs
        for (i = [0 : barb_5_count - 1]) {
            translate([0, 0, barb_5_start_z + i * barb_5_height / barb_5_count])
                cylinder(h = barb_5_height / barb_5_count,
                         d = cylinder(d1 = barb_5_bottom_d,
                                     d2 = barb_5_top_d,
                                     h = barb_5_height / barb_5_count).d);
        }
    }

    // Through-bore
    translate([0, 0, -eps])
        cylinder(h = reducer_length + 2 * eps, d = bore);
}