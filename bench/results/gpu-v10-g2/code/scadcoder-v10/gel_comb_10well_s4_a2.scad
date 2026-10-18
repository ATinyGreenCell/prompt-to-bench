// 10-well comb for agarose gel casting
// Printed lying flat on the bed

// ---------- Dimensions ----------
plate_t      = 1.5;    // plate thickness (Z)
spine_len    = 70;     // spine length along X
spine_wid    = 12;     // spine width along Y
tooth_w      = 5.0;    // tooth width along X
tooth_len    = 12;     // tooth length along Y
gap          = 1.5;    // gap between neighbouring teeth along X
n_teeth      = 10;     // number of teeth
eps          = 0.5;    // cutter overshoot past faces

$fn = 64;

// ---------- Derived ----------
pitch   = tooth_w + gap;
x0      = -(n_teeth * tooth_w + (n_teeth - 1) * gap) / 2;   // first tooth X

// ---------- Model ----------
difference() {
    // Spine (back bar)
    translate([-spine_len / 2, 0, 0])
        cube([spine_len, spine_wid, plate_t]);

    // Teeth (hang from -Y edge of spine)
    for (i = [0 : n_teeth - 1])
        translate([x0 + i * pitch, tooth_len, 0])
            cube([tooth_w, tooth_len, plate_t]);
}