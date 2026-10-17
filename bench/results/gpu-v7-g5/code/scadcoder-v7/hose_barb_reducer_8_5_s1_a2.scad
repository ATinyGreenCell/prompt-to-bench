// Straight hose-barb reducer: joins 8 mm ID silicone tubing to 5 mm ID silicone tubing
// Print orientation: standing upright along +Z

// ---------- Parameters ----------
reducer_length_8mm   = 20;   // z = 0 to 20: barbs for 8 mm tubing
reducer_length_5mm   = 16;   // z = 25 to 41: barbs for 5 mm tubing (8 mm tall each, 2 stacked)
reducer_collar_length = 5;    // z = 20 to 25: cylindrical collar
reducer_bore         = 3;     // through-bore diameter

barb_8mm_height      = 10;    // each 8 mm barb height
barb_8mm_d0          = 7.5;   // barb outer diameter at bottom
barb_8mm_d1          = 9.5;   // barb outer diameter at top

barb_5mm_height      = 8;     // each 5 mm barb height
barb_5mm_d0          = 6.5;   // barb outer diameter at bottom
barb_5mm_d1          = 5.0;   // barb outer diameter at top

eps                  = 0.5;   // overshoot for clean boolean cuts
$fn                  = 96;    // curve resolution

// ---------- Derived ----------
z_start_8 = 0;
z_end_8   = z_start_8 + reducer_length_8mm;

z_start_collar = z_end_8;
z_end_collar   = z_start_collar + reducer_collar_length;

z_start_5 = z_end_collar;
z_end_5   = z_start_5 + reducer_length_5mm;

// ---------- Modules ----------
module sawtooth_barb(h, d0, d1, overshoot = eps) {
    // Barb: diameter grows linearly from d0 to d1 over height h, then steps back to d0
    // (sawtooth profile, 2x per period: up then down)
    L = h + overshoot;
    d_up = d0 + (d1 - d0) * (z / h);
    union() {
        cylinder(h = h, d = d0);
        translate([0, 0, h])
            cylinder(h = overshoot, d = d1);
    }
}

module through_bore(d, overshoot = eps) {
    translate([0, 0, -overshoot])
        cylinder(h = d + 2 * overshoot, d = d);
}

// ---------- Part ----------
difference() {
    union() {
        // 8 mm tubing barbs
        for (i = [0, 1])
            translate([0, 0, z_start_8 + i * barb_8mm_height])
                cylinder(h = barb_8mm_height,
                         d1 = barb_8mm_d0,
                         d2 = barb_8mm_d1);

        // Collar
        translate([0, 0, z_start_collar])
            cylinder(h = reducer_collar_length, d = 12);

        // 5 mm tubing barbs
        for (i = [0, 1])
            translate([0, 0, z_start_5 + i * barb_5mm_height])
                cylinder(h = barb_5mm_height,
                         d1 = barb_5mm_d0,
                         d2 = barb_5mm_d1);
    }

    // Central bore
    through_bore(reducer_bore);
}