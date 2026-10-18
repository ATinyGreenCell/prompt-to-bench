// Straight hose-barb reducer: 8 mm ID tubing to 5 mm ID tubing
// Print orientation: standing upright along Z
// Units: mm

$fn = 96;

// ---- 8 mm tubing section (z = 0 to 20) ----
barb_count_8 = 2;          // stacked barbs
barb_height_8 = 10;        // height of each barb
barb_od_8_bottom = 7.5;    // outer diameter at bottom of barb
barb_od_8_top = 9.5;       // outer diameter at top of barb
bore_d = 3;                // through-bore diameter

// ---- Collar ----
collar_d = 12;             // collar outer diameter
collar_h = 5;              // collar height (z = 20 to 25)

// ---- 5 mm tubing section (z = 25 to 41) ----
barb_count_5 = 2;          // stacked barbs
barb_height_5 = 8;         // height of each barb
barb_od_5_bottom = 6.5;    // outer diameter at bottom of barb
barb_od_5_top = 5.0;       // outer diameter at top of barb

// ---- Derived ----
total_length = barb_count_8 * barb_height_8 + collar_h + barb_count_5 * barb_height_5; // 41 mm
overlap = 0.01;            // small overlap for stacked barbs to fuse cleanly

module barb() {
    // Sawtooth profile: grows linearly then steps straight back
    hull() {
        for (t = [0, 1]) {
            translate([0, 0, t * barb_height_8])
                cylinder(d = t * (barb_od_8_top - barb_od_8_bottom) + barb_od_8_bottom, h = 0.01);
        }
    }
}

module collar_section() {
    translate([0, 0, barb_count_8 * barb_height_8])
        cylinder(d = collar_d, h = collar_h);
}

module reduced_barb() {
    // Shrinks linearly then steps straight back out
    hull() {
        for (t = [0, 1]) {
            translate([0, 0, t * barb_height_5])
                cylinder(d = t * (barb_od_5_bottom - barb_od_5_top) + barb_od_5_top, h = 0.01);
        }
    }
}

difference() {
    union() {
        // 8 mm barbs
        for (i = [0 : barb_count_8 - 1])
            translate([0, 0, i * barb_height_8 + overlap])
                cylinder(d = barb_od_8_top, h = barb_height_8 - overlap);
        // collar
        collar_section();
        // 5 mm barbs
        for (i = [0 : barb_count_5 - 1])
            translate([0, 0, collar_h + i * barb_height_5 + overlap])
                reduced_barb();
    }
    // through bore
    translate([0, 0, -overlap])
        cylinder(d = bore_d, h = total_length + 2 * overlap);
}