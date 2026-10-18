// Straight hose-barb reducer: 8 mm tubing to 5 mm tubing
// Print orientation: standing upright along +Z, centred on origin in X/Y

$fn = 64;

// ---- Dimensions (mm) ----
tube1_id     = 8;    // first tubing inner diameter
tube2_id     = 5;    // second tubing inner diameter
barb1_height = 10;   // first barb height
barb2_height = 8;    // second barb height
collar_d     = 12;   // collar outer diameter
bore         = 3;    // through-bore diameter
eps          = 0.5;  // overshoot for clean cuts

// ---- Derived ----
tube1_od = tube1_id + 1.5;   // 8 mm tubing ~ 9.5 mm outer diameter
tube2_od = tube2_id + 1.5;   // 5 mm tubing ~ 6.5 mm outer diameter
barb1_base_od = 7.5;         // first barb bottom outer diameter
barb1_top_od  = 9.5;         // first barb top outer diameter
barb2_base_od = 6.5;         // second barb bottom outer diameter
barb2_top_od  = 5.0;         // second barb top outer diameter
barb1_embed   = 0.5;         // first barb overlap into collar
barb2_embed   = 0.5;         // second barb overlap into collar

// ---- Model ----
union() {
    // First barbs (z = 0 to 20)
    for (i = [0 : 1]) {
        translate([0, 0, i * barb1_height])
            hull() {
                cylinder(h = barb1_height, d = tube1_od);
                cylinder(h = barb1_height + 2 * barb1_embed,
                         d1 = tube1_od - 0.5, d2 = tube1_od + 0.5);
            }
    }

    // Collar (z = 20 to 25)
    translate([0, 0, 20])
        cylinder(h = 5, d = collar_d);

    // Second barbs (z = 25 to 41)
    for (i = [0 : 1]) {
        translate([0, 0, 25 + i * barb2_height])
            hull() {
                cylinder(h = barb2_height, d = tube2_od);
                cylinder(h = barb2_height + 2 * barb2_embed,
                         d1 = tube2_od - 0.5, d2 = tube2_od + 0.5);
            }
    }

    // Through-bore
    translate([0, 0, -eps])
        cylinder(h = 41 + 2 * eps, d = bore);
}