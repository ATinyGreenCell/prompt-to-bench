// Hose-barb reducer: 8 mm tubing (z = 0..20) -> collar (z = 20..25) -> 5 mm tubing (z = 25..41)
// Print orientation: standing upright along +Z, centred on origin in X/Y
// Units: mm

$fn = 96;

// ---- 8 mm tubing barbs (z = 0 to 20) ----
barb_h_t      = 10;   // barb height (stacked, so 20 mm total)
barb_d_bottom = 7.5;  // outer diameter at bottom of each barb
barb_d_top    = 9.5;  // outer diameter at top of each barb
barb_n        = 2;    // number of stacked barbs

// ---- Collar ----
collar_d      = 12;   // collar diameter
collar_h      = 5;    // collar height (z = 20 to 25)

// ---- 5 mm tubing barbs (z = 25 to 41) ----
barb_h_s      = 8;    // barb height (stacked, so 16 mm total)
barb_d_s_bot  = 6.5;  // outer diameter at bottom of each barb
barb_d_s_top  = 5.0;  // outer diameter at top of each barb
barb_n_s      = 2;    // number of stacked barbs

// ---- Through bore ----
bore_d        = 3;    // straight through-bore diameter

// ---- Cut overlap ----
eps           = 0.5;  // extension of cutters past faces

// Helper: sawtooth profile (bottom -> top -> bottom), rotated so bottom faces the part
module sawtooth_d(d_bot, d_top) {
    hull() {
        cylinder(d = d_bot, h = eps);
        cylinder(d = d_top, h = eps);
        translate([0, 0, -eps]) cylinder(d = d_bot, h = eps);
    }
}

union() {
    // 8 mm tubing barbs
    for (i = [0 : barb_n - 1])
        translate([0, 0, i * barb_h_t])
            cylinder(h = barb_h_t, d = sawtooth_d(barb_d_bottom, barb_d_top));

    // Collar
    translate([0, 0, 20])
        cylinder(h = collar_h, d = collar_d);

    // 5 mm tubing barbs
    for (i = [0 : barb_n_s - 1])
        translate([0, 0, 25 + i * barb_h_s])
            cylinder(h = barb_h_s, d = sawtooth_d(barb_d_s_bot, barb_d_s_top));

    // Through bore
    translate([0, 0, -eps])
        cylinder(h = 46 + 2 * eps, d = bore_d);
}