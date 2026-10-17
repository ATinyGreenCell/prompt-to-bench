// 10-well comb for casting agarose gels
// Print orientation: flat on bed, spine (back bar) along +X, teeth hanging in -Y

// ---------- Parameters ----------
plate_t      = 1.5;    // plate thickness (Z)
spine_l      = 70;     // spine length (X)
spine_w      = 12;     // spine width (Y)
tooth_n      = 10;     // number of teeth
tooth_w      = 5.0;    // tooth width (X)
tooth_len    = 12;     // tooth length (Y)
tooth_gap    = 1.5;    // gap between neighbouring teeth (X)
eps          = 0.5;    // cutter overshoot past faces (Z)

$fn = 64;

// ---------- Derived ----------
pitch   = tooth_w + tooth_gap;            // centre-to-centre tooth spacing
x0      = -(tooth_n - 1) * pitch / 2;     // first tooth centre (row centred on spine)
tooth_h = tooth_len + eps;                // cutter height from top face

// ---------- Model ----------
difference() {
    // Base plate
    translate([-spine_l / 2, -spine_w / 2, 0])
        cube([spine_l, spine_w, plate_t]);

    // Teeth cutters (through the top face)
    for (i = [0 : tooth_n - 1])
        translate([x0 + i * pitch - tooth_w / 2,
                   -spine_w / 2 - tooth_len,
                   plate_t - eps])
            cube([tooth_w, tooth_len + eps, tooth_h]);
}