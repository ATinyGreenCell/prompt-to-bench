// Hose-barb reducer: joins 8 mm tubing to 5 mm tubing
// Print orientation: standing upright along +Z

// ---------------- Parameters ----------------
reducer_d      = 12;   // bore diameter through full length
z0             = 0;    // start of 8 mm barbs
z1             = 20;   // end of 8 mm barbs / start of collar
z2             = 25;   // end of collar / start of 5 mm barbs
z3             = 41;   // end of 5 mm barbs

// 8 mm tubing barbs
bb_h           = 10;   // barb height
bb_d_bottom    = 7.5;  // barb outer diameter at bottom
bb_d_top       = 9.5;  // barb outer diameter at top

// 5 mm tubing barbs
ab_h           = 8;    // barb height
ab_d_bottom    = 6.5;  // barb outer diameter at bottom
ab_d_top       = 5.0;  // barb outer diameter at top

eps            = 0.5;  // overshoot for clean cuts

$fn = 96;

// ---------------- Model ----------------
difference() {
    union() {
        // 8 mm barbs (z = 0 to 20)
        for (i = [0, 1])
            translate([0, 0, z0 + i * bb_h])
                linear_extrude(height = bb_h)
                    circle(d = bb_d_bottom + (bb_d_top - bb_d_bottom) * (mod(i, 2) == 0 ? 0 : 1));

        // Collar (z = 20 to 25)
        translate([0, 0, z1])
            cylinder(d = reducer_d, h = z2 - z1);

        // 5 mm barbs (z = 25 to 41)
        for (i = [0, 1])
            translate([0, 0, z2 + i * ab_h])
                linear_extrude(height = ab_h)
                    circle(d = ab_d_bottom + (ab_d_top - ab_d_bottom) * (mod(i, 2) == 0 ? 0 : 1));
    }

    // Central bore through full length
    translate([0, 0, -eps])
        cylinder(d = reducer_d, h = z3 - z0 + 2 * eps);
}