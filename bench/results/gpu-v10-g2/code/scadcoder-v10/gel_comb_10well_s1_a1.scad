// 10-well agarose gel comb - printed lying flat
// Units: mm

$fn = 64;

// ---- Dimensions ----
spine_len    = 70;    // spine length (X)
spine_wid    = 12;    // spine width (Y)
teeth_count  = 10;    // number of teeth
tooth_w      = 5.0;   // tooth width (X)
tooth_len    = 12;    // tooth length (Y)
gap          = 1.5;   // gap between teeth (X)
plate_t      = 1.5;   // plate thickness (Z)

eps          = 0.5;   // cutter overshoot

// ---- Derived ----
pitch        = tooth_w + gap;
row_span     = (teeth_count - 1) * gap;
x_start      = -row_span / 2;   // centre row on spine

// ---- Model ----
difference() {
    // Spine
    translate([-spine_len/2, 0, 0])
        cube([spine_len, spine_wid, plate_t]);

    // Teeth (extend past -Y face)
    for (i = [0 : teeth_count - 1])
        translate([x_start + i * pitch - tooth_w/2,
                   -tooth_len,
                   0])
            cube([tooth_w, tooth_len + eps, plate_t]);
}