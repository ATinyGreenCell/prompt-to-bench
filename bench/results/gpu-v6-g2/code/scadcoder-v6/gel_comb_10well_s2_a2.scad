// 10-well comb for casting agarose gels
// Print orientation: flat on bed, spine (back bar) along +X, teeth hanging in -Y

// ---------- Parameters ----------
spine_len      = 70;    // spine length along X (mm)
spine_w        = 12;    // spine width along Y (mm)
plate_t        = 1.5;   // plate thickness along Z (mm)

tooth_count    = 10;    // number of teeth
tooth_w        = 5.0;   // tooth width along X (mm)
tooth_len      = 12;    // tooth length along Y (mm)
tooth_gap      = 1.5;   // gap between neighbouring teeth (mm)

eps            = 0.5;   // cutter overshoot past faces (mm)

$fn = 64;

// ---------- Derived ----------
pitch   = tooth_w + tooth_gap;            // centre-to-centre tooth spacing
x_start = -(tooth_count - 1) * pitch / 2; // first tooth centre, row centred on spine

// ---------- Model ----------
union() {
    // Spine (back bar)
    translate([-spine_len / 2, 0, 0])
        cube([spine_len, spine_w, plate_t]);

    // Teeth hanging in -Y from the spine's long edge
    for (i = [0 : tooth_count - 1])
        translate([x_start + i * pitch - tooth_w / 2,
                   -tooth_len - eps,
                   0])
            cube([tooth_w, tooth_len + eps, plate_t]);
}