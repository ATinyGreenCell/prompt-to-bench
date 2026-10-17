// Straight hose-barb reducer: 8 mm tubing to 5 mm tubing
// Print orientation: upright along Z, resting on XY plane at z = 0

$fn = 96;

// ---------------- Dimensions (mm) ----------------
// Collar
collar_d      = 12;    // collar outer diameter
collar_h      = 5;     // collar height (z = 20 to 25)

// 8 mm barbs (lower section)
n_barbs_8     = 2;     // number of stacked barbs
barb_h_8      = 10;    // barb height
barb_od_min_8 = 7.5;   // outer diameter at bottom of each barb
barb_od_max_8 = 9.5;   // outer diameter at top of each barb

// 5 mm barbs (upper section)
n_barbs_5     = 2;     // number of stacked barbs
barb_h_5      = 8;     // barb height
barb_od_min_5 = 6.5;   // outer diameter at bottom of each barb
barb_od_max_5 = 5.0;   // outer diameter at top of each barb

// Bore
bore_d        = 3;     // through-bore diameter

// ---------------- Derived ----------------
total_h = 41;          // overall height
pitch_8 = total_h / (n_barbs_8 + n_barbs_5 + 1);   // stack pitch (centres)
pitch_5 = pitch_8;     // same pitch for upper barbs

// ---------------- Model ----------------
difference() {
    union() {
        // Lower barbs (z = 0 to 20)
        for (i = [0 : n_barbs_8 - 1])
            translate([0, 0, i * pitch_8])
                module_barb(10, 7.5, 9.5);

        // Collar (z = 20 to 25)
        translate([0, 0, 20])
            cylinder(d = collar_d, h = collar_h);

        // Upper barbs (z = 25 to 41)
        for (i = [0 : n_barbs_5 - 1])
            translate([0, 0, 25 + i * pitch_5])
                module_barb(8, 6.5, 5.0);
    }

    // Through-bore, past every face
    translate([0, 0, -1])
        cylinder(d = bore_d, h = total_h + 2);
}

// ---------------- Subroutine ----------------
// Barb with sawtooth profile: outer diameter grows linearly from od_min to
// od_max over height h, then steps straight back to od_min.
module_barb(h, od_min, od_max) {
    difference() {
        union() {
            cylinder(d = od_min, h = h);
            translate([0, 0, h * 0.25])
                cylinder(d = od_max, h = h * 0.5);   // growth zone
            translate([0, 0, h * 0.75])
                cylinder(d = od_min, h = h * 0.25);  // step back
        }
        translate([0, 0, -1])
            cylinder(d = bore_d, h = h + 2);
    }
}