// 10-well comb for casting agarose gels
// Print orientation: flat on bed, teeth pointing down (-Y)

// ---- Dimensions (mm) ----
plate_t      = 1.5;   // plate thickness (Z)
spine_l      = 70;    // spine length (X)
spine_w      = 12;    // spine width (Y)
tooth_w      = 5.0;   // tooth width (X)
tooth_l      = 12;    // tooth length (Y)
tooth_count  = 10;    // number of teeth
gap          = 1.5;   // gap between teeth (X)
overcut      = 0.5;   // extra length on cutters

$fn = 64;

pitch = tooth_w + gap;  // centre-to-centre tooth spacing

// ---- Model ----
difference() {
    union() {
        // Spine
        translate([-spine_l/2, -spine_w/2, 0])
            cube([spine_l, spine_w, plate_t]);

        // Teeth
        for (i = [0 : tooth_count - 1])
            translate([(i - (tooth_count - 1)/2) * pitch - tooth_w/2,
                       -spine_w/2 - tooth_l,
                       0])
                cube([tooth_w, tooth_l + plate_t, plate_t]);
    }

    // Tooth cutters (extend past -Y face)
    for (i = [0 : tooth_count - 1])
        translate([(i - (tooth_count - 1)/2) * pitch - tooth_w/2,
                   -spine_w/2 - tooth_l - overcut,
                   -overcut])
            cube([tooth_w, tooth_l + 2*overcut, plate_t + 2*overcut]);
}