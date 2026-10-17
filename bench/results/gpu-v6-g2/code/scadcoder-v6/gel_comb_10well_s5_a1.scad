// 10-well comb for casting agarose gels
// Print orientation: flat on bed, spine (back bar) along +X, teeth in -Y

// ---------- Parameters ----------
spine_len    = 70;    // spine length along X (mm)
spine_w      = 12;    // spine width along Y (mm)
plate_t      = 1.5;   // comb plate thickness along Z (mm)

tooth_count  = 10;    // number of teeth
tooth_w      = 5.0;   // tooth width along X (mm)
tooth_l      = 12;    // tooth length along Y (mm)
tooth_gap    = 1.5;   // gap between neighbouring teeth (mm)

eps          = 0.5;   // cutter overshoot past faces (mm)

$fn = 64;

// ---------- Derived ----------
pitch   = tooth_w + tooth_gap;              // centre-to-centre spacing
x_start = -(tooth_count - 1) * pitch / 2;   // first tooth centre (row centred on spine)
tooth_h = tooth_l + eps;                    // cutter height from top face

// ---------- Model ----------
difference() {
    // Base plate
    translate([-spine_len / 2, -spine_w / 2, 0])
        cube([spine_len, spine_w, plate_t]);

    // Teeth cutters (through the full thickness)
    for (i = [0 : tooth_count - 1])
        translate([x_start + i * pitch - tooth_w / 2,
                   -spine_w / 2 - tooth_l / 2,
                   -eps])
            cube([tooth_w, tooth_l, tooth_h]);
}