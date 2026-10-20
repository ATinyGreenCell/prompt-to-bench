// Hose-barb reducer: 8 mm ID -> 5 mm ID silicone tubing
// Printed upright, rotationally symmetric about Z, 3 mm through-bore.

$fn = 64;

// Bore
bore_d = 3.0;

// 8 mm tubing section (z = 0..20)
big_barb_h   = 10.0;   // height of each 8 mm barb
big_barb_bot =  7.5;   // outer diameter at barb bottom (mm)
big_barb_top =  9.5;   // outer diameter at barb top (mm)
big_n        =  2;     // number of 8 mm barbs

// Collar (z = 20..25)
collar_h = 5.0;
collar_d = 12.0;

// 5 mm tubing section (z = 25..41)
small_barb_h   =  8.0;  // height of each 5 mm barb
small_barb_bot =  6.5;  // outer diameter at barb bottom (mm)
small_barb_top =  5.0;  // outer diameter at barb top (mm)
small_n        =  2;    // number of 5 mm barbs

// Sawtooth barb: cone from base_d to tip_d over height h, then a straight
// step back to base_d. The step is modelled as a short cylinder (0.01 mm)
// so the sawtooth is preserved and the profile is continuous.
module barb(base_d, tip_d, h) {
    union() {
        // Cone: base radius at z=0, tip radius at z=h
        rotate_extrude()
            polygon([
                [0, 0],
                [base_d / 2, 0],
                [tip_d / 2, h],
                [0, h]
            ]);
        // Step back to base_d (0.01 mm tall, sits on top of the cone)
        translate([0, 0, h])
            cylinder(h = 0.01, d = base_d);
    }
}

// Full outer body: two 8 mm barbs, collar, two 5 mm barbs
module body() {
    union() {
        // 8 mm barbs (z = 0..20)
        for (i = [0 : big_n - 1])
            translate([0, 0, i * big_barb_h])
                barb(big_barb_bot, big_barb_top, big_barb_h);

        // Collar (z = 20..25)
        translate([0, 0, big_n * big_barb_h])
            cylinder(h = collar_h, d = collar_d);

        // 5 mm barbs (z = 25..41)
        for (i = [0 : small_n - 1])
            translate([0, 0, big_n * big_barb_h + collar_h + i * small_barb_h])
                barb(small_barb_bot, small_barb_top, small_barb_h);
    }
}

// Through-bore: 3 mm diameter, extended 1 mm past each face
module bore() {
    cylinder(
        h = big_n * big_barb_h + collar_h + small_n * small_barb_h + 2,
        d = bore_d,
        $fn = $fn
    );
}

// Final part: body minus bore
difference() {
    body();
    bore();
}