// -----------------------------------------------------
// Parameters (mm)
// -----------------------------------------------------
bore_d = 3;                     // inner bore diameter (through the whole part)

barb8_bottom_od = 7.5;          // 8 mm tubing barb bottom outer diameter
barb8_top_od    = 9.5;          // 8 mm tubing barb top outer diameter
barb8_height    = 10;           // height of each 8 mm barb
barb8_count    = 2;             // number of stacked 8 mm barbs

collar_od      = 12;            // collar outer diameter
collar_height  = 5;             // collar height (before adding overlaps)

barb5_bottom_od = 6.5;          // 5 mm tubing barb bottom outer diameter
barb5_top_od    = 5.0;          // 5 mm tubing barb top outer diameter
barb5_height    = 8;            // height of each 5 mm barb
barb5_count    = 2;             // number of stacked 5 mm barbs

overlap = 0.05;                 // small extra length to guarantee fusion (mm)

$fn = 128;                      // resolution for all curved surfaces

// -----------------------------------------------------
// Helper modules
// -----------------------------------------------------
module barb8() {
    // Frustum that expands from bottom to top
    cylinder(h = barb8_height,
             r1 = barb8_bottom_od/2,
             r2 = barb8_top_od/2);
    // Small cylinder at the top that steps back to the original radius
    translate([0,0,barb8_height])
        cylinder(h = overlap,
                 r = barb8_bottom_od/2);
}

module barb5() {
    // Frustum that shrinks from bottom to top
    cylinder(h = barb5_height,
             r1 = barb5_bottom_od/2,
             r2 = barb5_top_od/2);
    // Small cylinder at the top that steps back to the original radius
    translate([0,0,barb5_height])
        cylinder(h = overlap,
                 r = barb5_bottom_od/2);
}

module collar() {
    // Collar with extra overlap at bottom and top to fuse with adjacent barbs
    translate([0,0,-overlap])
        cylinder(h = collar_height + 2*overlap,
                 r = collar_od/2);
}

// -----------------------------------------------------
// Assembly
// -----------------------------------------------------
module part() {
    union() {
        // 8 mm barbs (z = 0 → 20)
        for (i = [0 : barb8_count-1])
            translate([0,0,i*barb8_height])
                barb8();

        // Collar (z = 20 → 25)
        translate([0,0,20])
            collar();

        // 5 mm barbs (z = 25 → 41)
        translate([0,0,25])
            for (i = [0 : barb5_count-1])
                translate([0,0,i*barb5_height])
                    barb5();
    }
}

// -----------------------------------------------------
// Final part with bore
// -----------------------------------------------------
total_height = 41 + overlap;   // outermost height after all overlaps

difference() {
    part();   // solid outer shape

    // inner bore (extends slightly beyond the outer shape to avoid coplanar faces)
    translate([0,0,-0.01])
        cylinder(h = total_height + 0.02,
                 r = bore_d/2);
}