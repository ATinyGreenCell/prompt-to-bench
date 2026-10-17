// 10-well agarose gel comb, printed lying flat
// Units: mm

// ---------- Parameters ----------
plate_t      = 1.5;     // plate thickness (Z)
spine_len    = 70;      // spine length (X)
spine_wid    = 12;      // spine width (Y)
tooth_count  = 10;      // number of teeth
tooth_w      = 5.0;     // tooth width (X)
tooth_l      = 12;      // tooth length (Y)
tooth_gap    = 1.5;     // gap between teeth (X)
eps          = 0.5;     // cutter overshoot past faces

$fn = 64;

// ---------- Derived ----------
row_start = -(tooth_count * tooth_w + (tooth_count - 1) * tooth_gap) / 2; // first tooth X
pitch     = tooth_w + tooth_gap;                                          // centre-to-centre spacing

// ---------- Model ----------
difference() {
    // Base plate: spine + teeth
    translate([row_start, -tooth_l, 0])
        for (i = [0 : tooth_count - 1])
            translate([i * pitch, 0, 0])
                cube([tooth_w, tooth_l, plate_t]);

    translate([0, -tooth_l - eps, 0])
        cube([spine_len, tooth_l + 2 * eps, plate_t]); // spine under the teeth

    // Cut out the wells (through the plate)
    translate([row_start, 0, -eps])
        for (i = [0 : tooth_count - 1])
            translate([i * pitch, 0, 0])
                cube([tooth_w, tooth_l, plate_t + 2 * eps]);
}