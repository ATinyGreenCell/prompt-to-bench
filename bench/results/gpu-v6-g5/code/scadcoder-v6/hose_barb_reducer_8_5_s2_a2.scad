// Hose-barb reducer: 8 mm tubing -> 5 mm tubing
// Print orientation: standing upright along +Z

$fn = 64;

// ---- 8 mm tubing barbs (z = 0 .. 20) ----
barb_h      = 10;   // barb height
barb_od_bot = 7.5;  // outer diameter at bottom of barb
barb_od_top = 9.5;  // outer diameter at top of barb
barb_count  = 2;    // stacked barbs

// ---- collar (z = 20 .. 25) ----
collar_d    = 12;   // collar diameter
collar_h    = 5;    // collar height

// ---- 5 mm tubing barbs (z = 25 .. 41) ----
barb2_h     = 8;    // barb height
barb2_od_bot = 6.5; // outer diameter at bottom of barb
barb2_od_top = 5.0; // outer diameter at top of barb
barb2_count = 2;    // stacked barbs

// ---- bore ----
bore_d      = 3;    // through-bore diameter

// ---- cut overlap ----
eps         = 0.5;  // extension past cut faces

module barb_profile() {
    // sawtooth: from bottom to top: 7.5 -> 9.5 -> 7.5
    polygon(points = [
        [0, barb_h * 2 - eps],
        [barb_od_bot / 2, eps],
        [barb_od_top / 2, barb_h - eps],
        [barb_od_bot / 2, barb_h + eps],
        [0, barb_h * 2 + eps]
    ]);
}

union() {
    // 8 mm barbs
    for (i = [0 : barb_count - 1])
        translate([0, 0, i * barb_h])
            rotate([0, 90, 0])
                linear_extrude(height = barb_od_bot)
                    barb_profile();

    // collar
    translate([0, 0, barb_count * barb_h])
        cylinder(d = collar_d, h = collar_h);

    // 5 mm barbs
    for (i = [0 : barb2_count - 1])
        translate([0, 0, barb_count * barb_h + collar_h + i * barb2_h])
            rotate([0, 90, 0])
                linear_extrude(height = barb2_od_bot)
                    polygon(points = [
                        [0, -eps],
                        [barb2_od_bot / 2, eps],
                        [barb2_od_top / 2, barb2_h - eps],
                        [barb2_od_bot / 2, barb2_h + eps],
                        [0, barb2_h + 2 * eps]
                    ]);

    // bore
    translate([0, 0, -eps])
        cylinder(d = bore_d, h = barb_count * barb_h + collar_h + barb2_count * barb2_h + 2 * eps);
}