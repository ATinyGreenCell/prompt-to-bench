// Straight hose-barb reducer: 8 mm tubing to 5 mm tubing
// Print orientation: upright along Z, resting on XY plane at z = 0

$fn = 96;

// ---- Dimensions (mm) ----
collar_d      = 12;    // collar outer diameter
bore_d        = 3;     // through-bore diameter
barb_8_h      = 10;    // 8 mm barb height per stack
barb_8_d_bot  = 7.5;   // 8 mm barb outer diameter at bottom
barb_8_d_top  = 9.5;   // 8 mm barb outer diameter at top
barb_5_h      = 8;     // 5 mm barb height per stack
barb_5_d_bot  = 6.5;   // 5 mm barb outer diameter at bottom
barb_5_d_top  = 5.0;   // 5 mm barb outer diameter at top
eps           = 0.5;   // cutter overshoot past faces

// ---- Z segment boundaries ----
z0            = 0;     // start of 8 mm barbs
z8_barbs      = 20;    // end of 8 mm barbs / start of collar
zcollar       = 25;    // end of collar / start of 5 mm barbs
z5_barbs      = 41;    // end of 5 mm barbs

// ---- Derived ----
barb_8_slope  = (barb_8_d_top - barb_8_d_bot) / barb_8_h;   // d change per mm of z
barb_5_slope  = (barb_5_d_top - barb_5_d_bot) / barb_5_h;   // d change per mm of z

// ---- Part ----
difference() {
    union() {
        // 8 mm barbs (z = 0 .. 20)
        for (stack = [0, 1])
            translate([0, 0, z0 + stack * barb_8_h])
                cylinder(h = barb_8_h, d1 = barb_8_d_bot, d2 = barb_8_d_top);
        // Collar (z = 20 .. 25)
        translate([0, 0, z8_barbs])
            cylinder(h = zcollar - z8_barbs, d = collar_d);
        // 5 mm barbs (z = 25 .. 41)
        for (stack = [0, 1])
            translate([0, 0, zcollar + stack * barb_5_h])
                cylinder(h = barb_5_h, d1 = barb_5_d_bot, d2 = barb_5_d_top);
    }
    // Through-bore, full length
    translate([0, 0, z0 - eps])
        cylinder(h = z5_barbs - z0 + 2 * eps, d = bore_d);
}