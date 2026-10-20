// Parameters (mm)
bore_d = 3;                     // inner bore diameter
barb8_bottom_od = 7.5;          // 8 mm tubing barb bottom outer diameter
barb8_top_od = 9.5;             // 8 mm tubing barb top outer diameter
barb8_height = 10;              // height of each 8 mm barb
barb8_count = 2;                // number of 8 mm barbs (stacked)

collar_od = 12;                 // collar outer diameter
collar_height = 5;             // collar height

barb5_bottom_od = 6.5;          // 5 mm tubing barb bottom outer diameter
barb5_top_od = 5.0;             // 5 mm tubing barb top outer diameter
barb5_height = 8;               // height of each 5 mm barb
barb5_count = 2;                // number of 5 mm barbs (stacked)

total_height = 41;              // overall part height (0 → 41 mm)

$fn = 128;                      // resolution for curved surfaces

// ---------- Modules ----------
module barb8() {
    // 8 mm tubing barb: conical expansion then vertical step back to bottom radius
    rotate_extrude(angle = 360)
        polygon(points = [
            [barb8_bottom_od/2, 0],
            [barb8_top_od/2,    barb8_height],
            [barb8_bottom_od/2, barb8_height]
        ], paths = [[0,1,2]]);
}

module barb5() {
    // 5 mm tubing barb: conical contraction then vertical step back to bottom radius
    rotate_extrude(angle = 360)
        polygon(points = [
            [barb5_bottom_od/2, 0],
            [barb5_top_od/2,    barb5_height],
            [barb5_bottom_od/2, barb5_height]
        ], paths = [[0,1,2]]);
}

module barb8_stack() {
    for (i = [0 : barb8_count-1])
        translate([0,0,i*barb8_height])
            barb8();
}

module barb5_stack() {
    for (i = [0 : barb5_count-1])
        translate([0,0,i*barb5_height])
            barb5();
}

module collar() {
    cylinder(r = collar_od/2, h = collar_height);
}

// ---------- Assembly ----------
module part() {
    union() {
        // 8 mm barbs (z = 0 → 20)
        translate([0,0,0])
            barb8_stack();

        // Collar (z = 20 → 25)
        translate([0,0,20])
            collar();

        // 5 mm barbs (z = 25 → 41)
        translate([0,0,25])
            barb5_stack();
    }
}

// ---------- Final part with bore ----------
difference() {
    part();  // solid outer shape

    // inner bore (extends slightly beyond the part to avoid coplanar faces)
    translate([0,0,-0.01])
        cylinder(r = bore_d/2, h = total_height + 0.02);
}