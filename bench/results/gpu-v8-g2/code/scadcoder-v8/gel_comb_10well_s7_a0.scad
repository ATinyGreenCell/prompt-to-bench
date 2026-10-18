// 10-well agarose gel comb, printed lying flat
// Units: mm

// ---------- Parameters ----------
plate_t      = 1.5;    // comb plate thickness (Z)
spine_len    = 70;     // spine length along X
spine_w      = 12;     // spine width along Y
tooth_count  = 10;     // number of teeth
tooth_w      = 5.0;    // tooth width along X
tooth_len    = 12;     // tooth length along Y (from spine edge)
tooth_gap    = 1.5;    // gap between neighbouring teeth (X)
cut_extra    = 0.5;    // overshoot for clean boolean cuts
$fn          = 64;

// ---------- Derived ----------
pitch   = tooth_w + tooth_gap;            // centre-to-centre spacing
x_start = -(tooth_count - 1) * pitch / 2; // first tooth centre (row centred)

// ---------- Model ----------
difference() {
    union() {
        // Spine (back bar)
        translate([-spine_len / 2, -spine_w / 2, 0])
            cube([spine_len, spine_w, plate_t]);

        // Teeth hanging in -Y from the spine edge
        for (i = [0 : tooth_count - 1])
            translate([x_start + i * pitch - tooth_w / 2,
                       -spine_w / 2 - tooth_len,
                       0])
                cube([tooth_w, tooth_len, plate_t]);
    }

    // 10 rectangular wells cut through the plate
    for (i = [0 : tooth_count - 1])
        translate([x_start + i * pitch - tooth_w / 2,
                   -spine_w / 2 - tooth_len,
                   -cut_extra])
            cube([tooth_w, tooth_len, plate_t + 2 * cut_extra]);
}