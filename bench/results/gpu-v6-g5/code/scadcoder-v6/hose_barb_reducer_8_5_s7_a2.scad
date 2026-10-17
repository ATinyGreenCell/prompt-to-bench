// Straight hose-barb reducer: 8 mm tubing -> 5 mm tubing
// Print orientation: standing upright along +Z, centred on origin in X/Y

$fn = 64;

// ---- Dimensions (mm) ----
reducer_length   = 41;   // total length of the part
bore_d           = 3;    // through-bore diameter
first_tubing_d   = 8;    // inner diameter of the larger tubing
second_tubing_d  = 5;    // inner diameter of the smaller tubing
first_barb_h     = 10;   // height of each 8 mm barb
second_barb_h    = 8;    // height of each 5 mm barb
first_barb_od    = 9.5;  // outer diameter of 8 mm barbs at their tops
second_barb_od   = 5.0;  // outer diameter of 5 mm barbs at their tops
collar_d         = 12;   // outer diameter of the collar
overlap          = 0.5;  // overlap between stacked barbs for a clean union

// ---- Derived ----
first_barb_widening = (first_barb_od - 7.5) / 2;   // radius growth per mm of height
second_barb_narrowing = (6.5 - second_barb_od) / 2; // radius shrink per mm of height

difference() {
    union() {
        // ---- 8 mm tubing end (z = 0 to 20) ----
        for (z = [0 : first_barb_h : first_barb_h * 2 - overlap]) {
            translate([0, 0, z])
                cylinder(h = first_barb_h,
                         r = 7.5 + first_barb_widening * first_barb_h,
                         $fn = 64);
        }

        // ---- 5 mm tubing end (z = 25 to 41) ----
        for (z = [25 : second_barb_h : 25 + second_barb_h * 2 - overlap]) {
            translate([0, 0, z])
                cylinder(h = second_barb_h,
                         r = 6.5 - second_barb_narrowing * second_barb_h,
                         $fn = 64);
        }

        // ---- Collar (z = 20 to 25) ----
        translate([0, 0, 20])
            cylinder(h = 5, d = collar_d, $fn = 64);
    }

    // ---- Through bore ----
    translate([0, 0, -1])
        cylinder(h = reducer_length + 2, d = bore_d, $fn = 64);
}