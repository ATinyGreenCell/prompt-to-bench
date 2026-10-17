// 10-well comb for agarose gel casting, printed lying flat
// Units: mm

$fn = 64;

// --- Dimensions ---
plate_t      = 1.5;     // plate thickness (Z)
spine_len    = 70;      // spine length (X)
spine_wid    = 12;      // spine width (Y)
tooth_count  = 10;      // number of teeth
tooth_w      = 5.0;     // tooth width (X)
tooth_l      = 12;      // tooth length (Y)
tooth_gap    = 1.5;     // gap between teeth (X)
eps          = 0.5;     // cutter overshoot past faces

// Derived
row_start = -(tooth_count * tooth_w + (tooth_count - 1) * tooth_gap) / 2; // first tooth X

difference() {
    union() {
        // Spine
        translate([0, 0, 0])
            cube([spine_len, spine_wid, plate_t]);
        // Teeth
        for (i = [0 : tooth_count - 1])
            translate([row_start + i * (tooth_w + tooth_gap), -spine_wid, 0])
                cube([tooth_w, tooth_l, plate_t]);
    }
    // Cut the teeth out from the +Y side, leaving the overhangs
    for (i = [0 : tooth_count - 1])
        translate([row_start + i * (tooth_w + tooth_gap), -spine_wid, -eps])
            cube([tooth_w, tooth_l + 2 * eps, plate_t + 2 * eps]);
}