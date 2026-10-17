// Straight hose-barb reducer: 8 mm tubing -> 5 mm tubing
// Print orientation: standing upright along +Z, centred on origin in X/Y

// ---------------- Parameters ----------------
reducer_id      = 8;   // inner diameter of large (upstream) tubing
small_id        = 5;   // inner diameter of small (downstream) tubing
bore_d          = 3;   // through-bore diameter
barb_h_large    = 10;  // height of each large-tubing barb
barb_od_bottom  = 7.5; // outer diameter of large barbs at their bottom
barb_od_top     = 9.5; // outer diameter of large barbs at their top
barb_count_large = 2;  // number of large barbs, stacked
collar_d        = 12;  // outer diameter of the collar joining the two sections
collar_h        = 5;   // collar height (z = 20 to z = 25)
barb_h_small    = 8;   // height of each small-tubing barb
barb_od_small_b = 6.5; // outer diameter of small barbs at their bottom
barb_od_small_t = 5.0; // outer diameter of small barbs at their top
barb_count_small = 2;  // number of small barbs, stacked
eps             = 0.5; // overshoot for clean boolean cuts

$fn = 96;

// ---------------- Derived ----------------
large_start = -barb_h_large * (barb_count_large + 1) / 2;  // z = -15
large_end   = large_start + barb_h_large * barb_count_large; // z = 5
small_start = large_end + collar_h;                         // z = 30
small_end   = small_start + barb_h_small;                   // z = 38

// ---------------- Model ----------------
difference() {
    union() {
        // Large-tubing barbs (z = -15 to 5)
        for (i = [0 : barb_count_large - 1]) {
            translate([0, 0, large_start + i * barb_h_large])
                linear_extrude(height = barb_od_bottom + eps)
                    circle(d = barb_od_bottom);
            translate([0, 0, large_start + i * barb_h_large + eps])
                linear_extrude(height = barb_od_top - barb_od_bottom + eps)
                    circle(d = barb_od_top);
        }

        // Joining collar (z = 20 to 25)
        translate([0, 0, large_end])
            cylinder(d = collar_d, h = collar_h);

        // Small-tubing barbs (z = 30 to 38)
        for (i = [0 : barb_count_small - 1]) {
            translate([0, 0, small_start + i * barb_h_small])
                linear_extrude(height = barb_od_small_b + eps)
                    circle(d = barb_od_small_b);
            translate([0, 0, small_start + i * barb_h_small + eps])
                linear_extrude(height = barb_od_small_t - barb_od_small_b + eps)
                    circle(d = barb_od_small_t);
        }
    }

    // Through-bore along Z
    translate([0, 0, large_start - eps])
        cylinder(d = bore_d, h = small_end - large_start + 2 * eps);
}