// 10-well comb for agarose gel casting
// Printed lying flat on the bed, teeth pointing down in -Y

$fn = 64;

// ---- Dimensions (mm) ----
spine_len    = 70;    // spine length (X)
spine_wid    = 12;    // spine width (Y)
tooth_w      = 5;     // tooth width (X)
tooth_len    = 12;    // tooth length (Y)
gap          = 1.5;   // gap between teeth (X)
thickness    = 1.5;   // plate thickness (Z)
overcut      = 0.5;   // cutter overshoot past faces

n_teeth      = 10;    // number of teeth
row_span     = (n_teeth - 1) * gap;  // span of gaps
x_start      = -row_span / 2;        // first tooth centre (row centred)

// ---- Model ----
difference() {
    // Spine
    translate([-spine_len/2, 0, 0])
        cube([spine_len, spine_wid, thickness]);

    // Teeth
    for (i = [0 : n_teeth - 1])
        translate([x_start + i * (tooth_w + gap) - tooth_w/2,
                   -tooth_len,
                   0])
            cube([tooth_w, tooth_len + overcut, thickness]);
}