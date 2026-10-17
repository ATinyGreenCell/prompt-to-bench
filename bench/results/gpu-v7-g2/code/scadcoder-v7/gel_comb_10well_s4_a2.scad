// 10-well comb for agarose gel casting, printed lying flat
// Units: mm

// ---- Parameters ----
plate_t      = 1.5;     // plate thickness (Z)
spine_len    = 70;      // spine length along X
spine_wid    = 12;      // spine width along Y
tooth_count  = 10;      // number of teeth
tooth_w      = 5.0;     // tooth width along X
tooth_l      = 12;      // tooth length along Y
tooth_h      = 12;      // tooth height from spine edge (-Y)
gap          = 1.5;     // gap between teeth along X
eps          = 0.5;     // cutter overshoot past faces

// Derived
pitch        = tooth_w + gap;   // centre-to-centre spacing along X
x0           = -(tooth_count - 1) * gap / 2;  // first tooth X offset

// ---- Model ----
difference() {
    union() {
        // Spine
        translate([0, -spine_wid / 2, 0])
            cube([spine_len, spine_wid, plate_t]);

        // Teeth
        for (i = [0 : tooth_count - 1])
            translate([x0 + i * pitch, -spine_wid / 2 - tooth_h, 0])
                cube([tooth_w, tooth_l, plate_t]);
    }

    // Notch under each tooth (cuts into the spine, so the teeth stand proud)
    for (i = [0 : tooth_count - 1])
        translate([x0 + i * pitch - eps, -spine_wid / 2 - tooth_h - eps, 0])
            cube([tooth_w + 2 * eps, tooth_l + 2 * eps, tooth_h + eps]);
}