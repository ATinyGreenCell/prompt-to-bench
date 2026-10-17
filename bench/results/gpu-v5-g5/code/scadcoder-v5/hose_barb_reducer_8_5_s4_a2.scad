// Hose-barb reducer: joins 8 mm ID silicone tubing to 5 mm ID silicone tubing
// Print orientation: standing upright along +Z, base on XY plane (z = 0)
// Bore: 3 mm through the full length

// ---------------- Parameters ----------------
reducer_d        = 12;   // collar diameter (mm)
barb8_base_d     = 7.5;  // 8 mm tubing barb outer diameter at bottom (mm)
barb8_top_d      = 9.5;  // 8 mm tubing barb outer diameter at top (mm)
barb8_height     = 10;   // 8 mm tubing barb height (mm)
barb8_start_z    = 0;    // 8 mm tubing barb start height (mm)
barb5_base_d     = 6.5;  // 5 mm tubing barb outer diameter at bottom (mm)
barb5_top_d      = 5.0;  // 5 mm tubing barb outer diameter at top (mm)
barb5_height     = 8;    // 5 mm tubing barb height (mm)
barb5_start_z    = 25;   // 5 mm tubing barb start height (mm)
bore_d           = 3;    // through-bore diameter (mm)
eps              = 0.5;  // overshoot for clean boolean cuts (mm)

$fn = 96;

// ---------------- Model ----------------
difference() {
    union() {
        // 8 mm tubing barbs (stacked, sawtooth profile)
        for (i = [0 : 1]) {
            translate([0, 0, barb8_start_z + i * barb8_height])
                cylinder(h = barb8_height, d1 = barb8_base_d, d2 = barb8_top_d);
        }
        // Cylindrical collar
        translate([0, 0, barb8_start_z + 2 * barb8_height])
            cylinder(h = reducer_d - 0.01, d = reducer_d);
        // 5 mm tubing barbs (stacked, shrinking profile)
        for (i = [0 : 1]) {
            translate([0, 0, barb5_start_z + i * barb5_height])
                cylinder(h = barb5_height, d1 = barb5_base_d, d2 = barb5_top_d);
        }
    }
    // Through-bore
    translate([0, 0, -eps])
        cylinder(h = reducer_d + 2 * eps, d = bore_d);
}