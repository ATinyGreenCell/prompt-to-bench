// 10-well comb for agarose gel casting
// Print orientation: flat on bed, teeth pointing down (-Z)

// ---------- Parameters ----------
plate_t      = 1.5;   // plate thickness (Z)
spine_len    = 70;    // spine length (X)
spine_w      = 12;    // spine width (Y)
tooth_count  = 10;    // number of teeth
tooth_w      = 5.0;   // tooth width (X)
tooth_len    = 12;    // tooth length (Y)
tooth_h      = 12;    // tooth height from plate top (Z)
gap          = 1.5;   // gap between teeth (X)
eps          = 0.5;   // cutter overshoot past faces

$fn = 64;

// ---------- Derived ----------
pitch   = tooth_w + gap;
x0      = -(tooth_count - 1) * pitch / 2;   // first tooth centre (row centred on spine)
reach   = max(eps, tooth_h);                // cutter must pass through the top face

// ---------- Model ----------
union() {
    // Plate with spine
    translate([-spine_len / 2, -spine_w / 2, 0])
        cube([spine_len, spine_w, plate_t]);

    // Teeth hanging from the +Y edge of the spine
    for (i = [0 : tooth_count - 1])
        translate([x0 + i * pitch - tooth_w / 2,
                   spine_w / 2 - tooth_len,
                   plate_t])
            cube([tooth_w, tooth_len, reach]);
}