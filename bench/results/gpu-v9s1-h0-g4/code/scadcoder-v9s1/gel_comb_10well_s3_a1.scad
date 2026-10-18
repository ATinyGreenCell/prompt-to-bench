// 10-well agarose gel comb - printed lying flat
// Units: mm

plate_t      = 1.5;   // plate thickness (Z)
spine_len    = 70;    // spine length (X)
spine_w      = 12;    // spine width (Y)
tooth_count  = 10;    // number of teeth
tooth_w      = 5.0;   // tooth width (X)
tooth_len    = 12;    // tooth length (Y)
gap          = 1.5;   // gap between teeth (X)
eps          = 0.5;   // cutter overshoot

$fn = 64;

pitch = tooth_w + gap;
x0    = -(tooth_count - 1) * pitch / 2;    // first tooth centre

difference() {
    union() {
        // spine
        translate([-spine_len / 2, -spine_w / 2, 0])
            cube([spine_len, spine_w, plate_t]);
        // teeth
        for (i = [0 : tooth_count - 1])
            translate([x0 + i * pitch - tooth_w / 2, -spine_w / 2 - tooth_len, 0])
                cube([tooth_w, tooth_len, plate_t]);
    }
    // wells
    for (i = [0 : tooth_count - 1])
        translate([x0 + i * pitch - tooth_w / 2, -spine_w / 2 - tooth_len - eps, -eps])
            cube([tooth_w, tooth_len, plate_t + 2 * eps]);
}