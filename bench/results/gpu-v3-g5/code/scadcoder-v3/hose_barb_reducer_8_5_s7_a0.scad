// Straight hose-barb reducer: 8 mm tubing to 5 mm tubing
// Print orientation: upright along Z, resting on XY plane at z = 0

$fn = 96;

// ---------------- Dimensions (mm) ----------------
// Collar
collar_d      = 12;    // collar outer diameter
collar_h      = 5;     // collar height (z = 20 to 25)

// 8 mm tubing barbs (lower section)
barb8_h       = 10;    // each barb height
barb8_d_min   = 7.5;   // barb outer diameter at bottom
barb8_d_max   = 9.5;   // barb outer diameter at top

// 5 mm tubing barbs (upper section)
barb5_h       = 8;     // each barb height
barb5_d_min   = 6.5;   // barb outer diameter at bottom
barb5_d_max   = 5.0;   // barb outer diameter at top

// Bore
bore_d        = 3;     // through-bore diameter

// ---------------- Derived values ----------------
total_h       = 41;    // overall height
overlap       = 0.5;   // extra length so barbs overlap into collar

// ---------------- Model ----------------
difference() {
    union() {
        // Lower barbs (stacked)
        for (i = [0 : 1])
            translate([0, 0, i * barb8_h])
                module barb8();

        // Collar
        translate([0, 0, 20])
            cylinder(d = collar_d, h = collar_h);

        // Upper barbs (stacked)
        for (i = [0 : 1])
            translate([0, 0, 25 + i * barb5_h])
                module barb5();
    }

    // Through-bore from z = 0 to z = 41
    translate([0, 0, -overlap])
        cylinder(d = bore_d, h = total_h + 2 * overlap);
}

// ---------------- Subroutines ----------------
module barb8() {
    // 8 mm barb: diameter grows then steps back
    difference() {
        union() {
            cylinder(d = barb8_d_min, h = barb8_h);
            translate([0, 0, barb8_h - 1])
                cylinder(d = barb8_d_max, h = 2);   // overlapping top
        }
        translate([0, 0, -1])
            cylinder(d = bore_d, h = barb8_h + 2);
    }
}

module barb5() {
    // 5 mm barb: diameter shrinks then steps back out
    difference() {
        union() {
            cylinder(d = barb5_d_min, h = barb5_h);
            translate([0, 0, 25 + barb5_h - 1])
                cylinder(d = barb5_d_max, h = 2);   // overlapping top
        }
        translate([0, 0, -1])
            cylinder(d = bore_d, h = barb5_h + 2);
    }
}