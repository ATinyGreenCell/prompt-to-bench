// Hose-barb reducer: joins 8 mm ID tubing to 5 mm ID tubing
// Print orientation: standing upright along Z

$fn = 96;

// ---- 8 mm tubing barbs (z = 0 to 20) ----
barb_h_8 = 20;
barb_od_bottom_8 = 7.5;
barb_od_top_8 = 9.5;

// ---- 5 mm tubing barbs (z = 25 to 41) ----
barb_h_5 = 8;
barb_od_bottom_5 = 6.5;
barb_od_top_5 = 5.0;

// ---- Collar (z = 20 to 25) ----
collar_od = 12;

// ---- Through bore ----
bore = 3;

// ---- Derived ----
collar_h = 5;
overlap = 0.01;

module barb(h, od_bottom, od_top) {
    // Sawtooth profile: grow linearly, then step straight back to bottom diameter
    len = (od_top - od_bottom) / 2 / tan(30);  // 30 deg flank
    hull() {
        translate([0, 0, 0]) cylinder(h = h + overlap, d = od_bottom);
        translate([0, 0, h - overlap]) cylinder(h = overlap, d = od_bottom);
        for (s = [-1, 1])
            rotate([0, 0, s * 180])
                translate([len / 2, 0, 0])
                    linear_extrude(height = h + overlap)
                        circle(d = od_top);
    }
}

difference() {
    union() {
        // 8 mm barbs
        for (z = [0, barb_h_8 / 2])
            translate([0, 0, z]) barb(h = barb_h_8 / 2 + overlap, od_bottom = barb_od_bottom_8, od_top = barb_od_top_8);

        // Collar
        translate([0, 0, 20]) cylinder(h = collar_h, d = collar_od);

        // 5 mm barbs
        for (z = [25, 41 - 16 / 2])
            translate([0, 0, z]) barb(h = barb_h_5, od_bottom = barb_od_bottom_5, od_top = barb_od_top_5);
    }

    // Through bore
    translate([0, 0, -1]) cylinder(h = barb_h_8 + collar_h + barb_h_5 + 2, d = bore);
}