// 10-well comb for casting agarose gels
// Print orientation: flat on bed, teeth pointing down (-Z)

// ---------- Parameters ----------
spine_len    = 70;    // spine length along X (mm)
spine_w      = 12;    // spine width along Y (mm)
plate_t      = 1.5;   // plate thickness along Z (mm)

tooth_count  = 10;    // number of teeth
tooth_w      = 5.0;   // tooth width along X (mm)
tooth_l      = 12;    // tooth length along Y (mm)

gap          = 1.5;   // gap between neighbouring teeth (mm)
overhang     = 1.5;   // tooth extension past the spine edge (mm)

eps          = 0.01;  // small overlap for clean union

$fn = 64;

// ---------- Derived ----------
pitch   = tooth_w + gap;              // centre-to-centre tooth spacing
x_start = -(tooth_count - 1) * pitch / 2;  // first tooth centre (row centred)

// ---------- Model ----------
union() {
    // Spine (back bar)
    translate([-spine_len / 2, 0, 0])
        cube([spine_len, spine_w, plate_t]);

    // Teeth hanging from the -Y edge
    for (i = [0 : tooth_count - 1])
        translate([x_start + i * pitch - tooth_w / 2,
                   -spine_w / 2 - eps,
                   0])
            cube([tooth_w, tooth_l + eps, plate_t + overhang]);
}