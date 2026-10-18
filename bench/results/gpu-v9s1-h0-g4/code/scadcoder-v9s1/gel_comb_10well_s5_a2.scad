// 10-well comb for casting agarose gels
// Print orientation: flat on bed, teeth pointing down (-Z)

// ---------- Parameters ----------
plate_t      = 1.5;    // plate thickness (Z)
spine_len    = 70;     // spine length (X)
spine_w      = 12;     // spine width (Y)
tooth_count  = 10;     // number of teeth
tooth_w      = 5.0;    // tooth width (X)
tooth_len    = 12;     // tooth length (Y)
tooth_h      = 12;     // tooth height from spine (-Y)
pitch        = tooth_w + 1.5;  // centre-to-centre spacing (X)
eps          = 0.5;    // cutter overshoot past faces

$fn = 64;

// ---------- Model ----------
difference() {
    // Base plate
    translate([-spine_len/2, 0, 0])
        cube([spine_len, spine_w, plate_t]);

    // Teeth row, centred on spine in X
    for (i = [0 : tooth_count - 1])
        translate([(i - (tooth_count - 1)/2) * pitch, -tooth_h, 0])
            cube([tooth_w, tooth_len, plate_t + eps]);
}