// Hose-barb reducer: joins 8 mm ID silicone tubing to 5 mm ID silicone tubing
// Print orientation: standing upright along +Z, base on XY plane

// ---------------- Parameters ----------------
reducer_d      = 7.5;   // bore diameter through full length (mm)
barb8_base_d   = 7.5;   // 8 mm tubing barb outer diameter at bottom (mm)
barb8_top_d    = 9.5;   // 8 mm tubing barb outer diameter at top (mm)
barb8_height   = 10;    // 8 mm tubing barb height (mm)
barb8_pitch    = 12;    // centre-to-centre spacing of the two 8 mm barbs (mm)
barb8_start_z  = 0;     // z position of bottom of 8 mm barbs (mm)
barb8_step_d   = 2;     // diameter increase then decrease at the sawtooth peak (mm)

barb5_base_d   = 6.5;   // 5 mm tubing barb outer diameter at bottom (mm)
barb5_top_d    = 5.0;   // 5 mm tubing barb outer diameter at top (mm)
barb5_height   = 8;     // 5 mm tubing barb height (mm)
barb5_pitch    = 12;    // centre-to-centre spacing of the two 5 mm barbs (mm)
barb5_start_z  = 25;    // z position of bottom of 5 mm barbs (mm)
barb5_step_d   = 1.5;   // diameter increase then decrease at the sawtooth peak (mm)

collar_d       = 12;    // cylindrical collar diameter (mm)
collar_start_z = 20;    // z position of bottom of collar (mm)
collar_end_z   = 25;    // z position of top of collar (mm)

eps            = 0.5;   // overshoot for clean boolean cuts (mm)

$fn = 96;

// ---------------- Model ----------------
difference() {
    union() {
        // 8 mm tubing barbs
        for (i = [-1, 1]) {
            translate([i * barb8_pitch / 2, 0, barb8_start_z])
                linear_extrude(height = barb8_height)
                    hull() {
                        circle(d = barb8_base_d);
                        circle(d = barb8_top_d);
                    }
        }

        // 5 mm tubing barbs
        for (i = [-1, 1]) {
            translate([i * barb5_pitch / 2, 0, barb5_start_z])
                linear_extrude(height = barb5_height)
                    hull() {
                        circle(d = barb5_base_d);
                        circle(d = barb5_top_d);
                    }
        }

        // Cylindrical collar
        translate([0, 0, collar_start_z])
            cylinder(d = collar_d, h = collar_end_z - collar_start_z);
    }

    // Through bore
    translate([0, 0, -eps])
        cylinder(d = reducer_d, h = (barb8_start_z + barb8_height +
                                     collar_start_z + (collar_end_z - collar_start_z) +
                                     barb5_start_z + barb5_height) + 2 * eps);
}