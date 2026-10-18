// Agarose gel casting comb - 10 wells
// Print orientation: flat on bed, teeth pointing down (-Y)

// ---------- Parameters ----------
plate_t      = 1.5;   // plate thickness (Z)
spine_len    = 70;    // spine length (X)
spine_w      = 12;    // spine width (Y)
tooth_w      = 5.0;   // tooth width (X)
tooth_len    = 12;    // tooth length (Y)
tooth_count  = 10;    // number of teeth
tooth_gap    = 1.5;   // gap between neighbouring teeth (X)
eps          = 0.5;   // cutter overshoot past faces

$fn = 64;

// ---------- Derived ----------
pitch   = tooth_w + tooth_gap;          // centre-to-centre spacing of teeth
x_start = -(tooth_count - 1) * pitch / 2; // first tooth centre (row centred on spine)

// ---------- Model ----------
difference() {
    union() {
        // Spine (back bar)
        translate([-spine_len / 2, -spine_w / 2, 0])
            cube([spine_len, spine_w, plate_t]);

        // Teeth
        for (i = [0 : tooth_count - 1])
            translate([x_start + i * pitch, -tooth_len, 0])
                cube([tooth_w, tooth_len, plate_t]);
    }

    // Teeth cutters, extending past -Y face
    for (i = [0 : tooth_count - 1])
        translate([x_start + i * pitch, -tooth_len - eps, 0])
            cube([tooth_w, tooth_len + 2 * eps, plate_t + eps]);
}