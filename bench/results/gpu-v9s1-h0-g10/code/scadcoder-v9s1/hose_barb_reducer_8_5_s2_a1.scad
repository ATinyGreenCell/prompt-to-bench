// Hose-barb reducer: joins 8 mm ID tubing to 5 mm ID tubing
// Print orientation: standing upright along +Z, centred on origin in X/Y

// ---------------- Parameters ----------------
reducer_d      = 10;   // bore diameter (through-hole)
tube8_d        = 8;    // inner diameter of first tubing set
tube5_d        = 5;    // inner diameter of second tubing set
barb8_h        = 10;   // height of each 8 mm barb
barb5_h        = 8;    // height of each 5 mm barb
barb8_bottom_d = 7.5;  // outer diameter of 8 mm barbs at bottom
barb8_top_d    = 9.5;  // outer diameter of 8 mm barbs at top
barb5_bottom_d = 6.5;  // outer diameter of 5 mm barbs at bottom
barb5_top_d    = 5.0;  // outer diameter of 5 mm barbs at top
collar_d       = 12;   // diameter of cylindrical collar
z0             = 0;    // start of first barbs
z8             = z0 + 2 * barb8_h;   // top of 8 mm barbs (20)
z_coll         = z8 + 5;             // top of collar (25)
z5             = z_coll + 2 * barb5_h; // top of 5 mm barbs (41)
eps            = 0.5;  // overshoot for clean boolean cuts

$fn = 96;

// ---------------- Model ----------------
difference() {
    union() {
        // 8 mm tubing barbs (sawtooth profile, stacked)
        for (i = [0 : 1])
            translate([0, 0, z0 + i * barb8_h])
                cylinder(h = barb8_h,
                         r = function(z) {
                             if (z < barb8_h * 0.5)
                                 return barb8_bottom_d / 2 +
                                        (barb8_top_d - barb8_bottom_d) / 2 /
                                        (barb8_h * 0.5) * (z - 0);
                             else
                                 return barb8_top_d / 2;
                         });

        // Cylindrical collar
        translate([0, 0, z8])
            cylinder(h = 5, d = collar_d);

        // 5 mm tubing barbs (shrinking profile, stacked)
        for (i = [0 : 1])
            translate([0, 0, z_coll + i * barb5_h])
                cylinder(h = barb5_h,
                         r = function(z) {
                             if (z < z_coll + barb5_h * 0.5)
                                 return barb5_bottom_d / 2;
                             else
                                 return barb5_bottom_d / 2 -
                                        (barb5_bottom_d - barb5_top_d) / 2 /
                                        (barb5_h * 0.5) * (z - (z_coll + barb5_h * 0.5));
                         });
    }

    // Full-length bore
    translate([0, 0, -eps])
        cylinder(h = z5 + 2 * eps, d = reducer_d);
}