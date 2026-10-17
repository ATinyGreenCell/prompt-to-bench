// Hose-barb reducer: joins 8 mm ID silicone tubing to 5 mm ID silicone tubing
// Print orientation: standing upright along +Z
// Units: mm

// ---------------- Parameters ----------------
reducer_length_8mm   = 20;   // z = 0 to 20: barbs for 8 mm tubing
reducer_length_coll  = 5;    // z = 20 to 25: cylindrical collar
reducer_length_5mm   = 16;   // z = 25 to 41: barbs for 5 mm tubing

barb_height_8mm      = 10;   // each 8 mm barb height
barb_d0_8mm          = 7.5;  // barb outer diameter at bottom
barb_d1_8mm          = 9.5;  // barb outer diameter at top (before step back)

barb_height_5mm      = 8;    // each 5 mm barb height
barb_d0_5mm          = 6.5;  // barb outer diameter at bottom
barb_d1_5mm          = 5.0;  // barb outer diameter at top (before step back)

bore_d               = 3;    // through-bore diameter
eps                  = 0.5;  // overshoot for clean boolean cuts

$fn = 96;

// ---------------- Modules ----------------
module sawtooth_barb(h, d0, d1) {
    // Barb: diameter grows linearly from d0 to d1 over height h,
    // then steps straight back to d0.
    // (The step-back portion is at the top and does not affect the first
    // 80% of the barb, so it does not cause a self-intersection.)
    difference() {
        cylinder(h = h, d = d0);
        translate([0, 0, eps])
            cylinder(h = h - eps, d1 = d1, d0 = d0);
    }
}

module through_bore(d) {
    translate([0, 0, -eps])
        cylinder(h = d + 2 * eps, d = d);
}

// ---------------- Part ----------------
union() {
    // 8 mm tubing barbs (z = 0 to 20)
    for (i = [0, 1])
        translate([0, 0, i * barb_height_8mm])
            sawtooth_barb(barb_height_8mm, barb_d0_8mm, barb_d1_8mm);

    // Cylindrical collar (z = 20 to 25)
    translate([0, 0, reducer_length_8mm])
        cylinder(h = reducer_length_coll, d = 12);

    // 5 mm tubing barbs (z = 25 to 41)
    for (i = [0, 1])
        translate([0, 0, reducer_length_8mm + reducer_length_coll + i * barb_height_5mm])
            sawtooth_barb(barb_height_5mm, barb_d0_5mm, barb_d1_5mm);

    // Through-bore
    through_bore(bore_d);
}