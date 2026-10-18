// Hose-barb reducer: joins 8 mm ID tubing to 5 mm ID tubing
// Print orientation: standing upright along Z, centred on origin in X/Y

// ---------------- Parameters ----------------
reducer_d      = 10;   // bore diameter (through hole)
tube_a_id      = 8;    // tubing A inner diameter
tube_b_id      = 5;    // tubing B inner diameter
barb_a_h       = 10;   // height of each 8 mm barb
barb_a_od_bot  = 7.5;  // outer diameter of 8 mm barb at bottom
barb_a_od_top  = 9.5;  // outer diameter of 8 mm barb at top
barb_a_count   = 2;    // number of 8 mm barbs (stacked)
barb_b_h       = 8;    // height of each 5 mm barb
barb_b_od_bot  = 6.5;  // outer diameter of 5 mm barb at bottom
barb_b_od_top  = 5.0;  // outer diameter of 5 mm barb at top
barb_b_count   = 2;    // number of 5 mm barbs (stacked)
collar_d       = 12;   // diameter of cylindrical collar
collar_h       = 5;    // height of collar (z = 20 to 25)
eps            = 0.5;  // overshoot for clean boolean cuts

$fn = 96;

// ---------------- Derived ----------------
total_h = barb_a_h * barb_a_count + collar_h + barb_b_h * barb_b_count;
// 2 * 10 + 5 + 2 * 8 = 35 mm

// ---------------- Model ----------------
difference() {
    union() {
        // 8 mm tubing barbs: sawtooth profile, z = 0 to 20
        for (i = [0 : barb_a_count - 1]) {
            translate([0, 0, i * barb_a_h])
                cylinder(h = barb_a_h,
                         r = function(z) {
                             return barb_a_od_bot +
                                    (barb_a_od_top - barb_a_od_bot) *
                                    (z - i * barb_a_h) / barb_a_h;
                         });
        }

        // Collar: z = 20 to 25
        translate([0, 0, barb_a_h * barb_a_count])
            cylinder(h = collar_h, d = collar_d);

        // 5 mm tubing barbs: shrinking profile, z = 25 to 41
        for (i = [0 : barb_b_count - 1]) {
            translate([0, 0, barb_a_h * barb_a_count +
                        collar_h + i * barb_b_h])
                cylinder(h = barb_b_h,
                         r = function(z) {
                             return barb_b_od_bot +
                                    (barb_b_od_top - barb_b_od_bot) *
                                    (z - (barb_a_h * barb_a_count +
                                         collar_h + i * barb_b_h)) /
                                    barb_b_h;
                         });
        }
    }

    // Full-length bore through the part
    translate([0, 0, -eps])
        cylinder(h = total_h + 2 * eps, d = reducer_d);
}