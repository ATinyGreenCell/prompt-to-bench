// 10-well comb for agarose gel casting
// Printed lying flat, teeth pointing down (-Y)

$fn = 64;

// --- Spine ---
spine_len   = 70;   // length along X
spine_wid   = 12;   // width along Y
spine_thk   = 1.5;  // thickness along Z

// --- Teeth ---
tooth_count = 10;   // number of teeth
tooth_w     = 5.0;  // tooth width along X
tooth_len   = 12;   // tooth length along Y
tooth_gap   = 1.5;  // gap between teeth along X

// --- Cutting overlap ---
eps         = 0.5;  // extension of cutters past faces

pitch       = tooth_w + tooth_gap;
x_start     = -(tooth_count - 1) * pitch / 2;

difference() {
    // Spine
    translate([-spine_len/2, 0, 0])
        cube([spine_len, spine_wid, spine_thk]);

    // Teeth
    for (i = [0 : tooth_count - 1])
        translate([x_start + i * pitch - tooth_w/2,
                   spine_wid - eps,
                   -eps])
            cube([tooth_w, tooth_len + eps, spine_thk + 2*eps]);
}