// 10-well comb for agarose gel casting
// Printed lying flat, teeth pointing down (-Y)

$fn = 64;

// ---- Dimensions (mm) ----
spine_len    = 70;    // spine length (X)
spine_wid    = 12;    // spine width (Y)
tooth_w      = 5.0;   // tooth width (X)
tooth_len    = 12;    // tooth length (Y)
tooth_count  = 10;    // number of teeth
gap          = 1.5;   // tooth gap (X)
plate_t      = 1.5;   // plate thickness (Z)
eps          = 0.5;   // cutter overshoot

// ---- Derived ----
pitch   = tooth_w + gap;
x_start = -(tooth_count - 1) * gap / 2;

// ---- Model ----
difference() {
    // Spine
    translate([-spine_len/2, 0, 0])
        cube([spine_len, spine_wid, plate_t]);

    // Teeth
    for (i = [0 : tooth_count - 1])
        translate([x_start + i * pitch, -tooth_len, 0])
            cube([tooth_w, tooth_len, plate_t + eps]);
}