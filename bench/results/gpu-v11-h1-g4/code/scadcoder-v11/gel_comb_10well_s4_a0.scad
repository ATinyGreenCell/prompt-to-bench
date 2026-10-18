// 10-well agarose gel comb, printed lying flat
// Units: mm. Comb sits on the bed (z = 0), builds upward (+Z).

// ---------- Parameters ----------
plate_t      = 1.5;    // comb plate thickness (Z)
spine_len    = 70;     // spine (back bar) length (X)
spine_w      = 12;     // spine width (Y)

tooth_count  = 10;     // number of wells / teeth
tooth_w      = 5.0;    // tooth width (X)
tooth_l      = 12;     // tooth length into the gel (Y, -ve direction)
tooth_h      = 12;     // tooth height above plate (Z)

gap          = 1.5;    // centre-to-centre spacing between teeth (X)
eps          = 0.5;    // cutter overshoot past faces

$fn = 64;

// ---------- Derived ----------
pitch   = tooth_w + gap;               // centre-to-centre spacing
x_start = -(tooth_count - 1) * pitch / 2; // first tooth centre (row centred)

// ---------- Model ----------
union() {
    // Spine (back bar)
    translate([-spine_len / 2, 0, 0])
        cube([spine_len, spine_w, plate_t]);

    // Teeth hanging in -Y
    for (i = [0 : tooth_count - 1])
        translate([x_start + i * pitch - tooth_w / 2,
                   spine_w - tooth_l,
                   0])
            cube([tooth_w, tooth_l + eps, tooth_h]);
}