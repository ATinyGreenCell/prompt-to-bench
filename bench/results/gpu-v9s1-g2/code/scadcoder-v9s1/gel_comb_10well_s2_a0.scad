// 10-well comb for casting agarose gels
// Print orientation: flat on bed, teeth pointing down (-Y)

$fn = 64;

// ---- Dimensions (mm) ----
plate_t      = 1.5;   // plate thickness (Z)
spine_len    = 70;    // spine length (X)
spine_w      = 12;    // spine width (Y)
tooth_n      = 10;    // number of teeth
tooth_w      = 5.0;   // tooth width (X)
tooth_len    = 12;    // tooth length (Y)
gap          = 1.5;   // gap between teeth (X)
overcut      = 0.5;   // cutter overshoot past faces (Z)

// ---- Derived ----
pitch   = tooth_w + gap;            // centre-to-centre spacing
x_start = -(tooth_n - 1) * pitch / 2; // first tooth centre (row centred)

difference() {
    // Plate with spine
    translate([-spine_len / 2, 0, 0])
        cube([spine_len, spine_w, plate_t]);

    // Teeth
    for (i = [0 : tooth_n - 1])
        translate([x_start + i * pitch - tooth_w / 2,
                   -tooth_len,
                   -overcut])
            cube([tooth_w, tooth_len + plate_t + 2 * overcut,
                  plate_t + 2 * overcut]);
}