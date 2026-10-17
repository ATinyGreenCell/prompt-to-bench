// 10-well agarose gel comb, printed lying flat
// Units: mm. Plate thickness (Z) = 1.5 mm.

$fn = 64;

// ---- Spine (back bar) ----
spine_len   = 70;   // spine length along X
spine_wid   = 12;   // spine width along Y

// ---- Teeth ----
tooth_count = 10;   // number of wells
tooth_w     = 5.0;  // tooth width along X
tooth_l     = 12;   // tooth length along Y (same as spine width)

// ---- Pitch ----
pitch       = 1.5;  // centre-to-centre spacing of teeth along X

// ---- Misc ----
eps         = 0.5;  // cutter overshoot past faces
plate_t     = 1.5;  // plate thickness (Z)

// First tooth centre, so the row is centred on the spine
x0 = -(tooth_count - 1) * pitch / 2;

difference() {
    // Plate: spine + teeth, resting on z = 0
    union() {
        translate([-spine_len / 2, -spine_wid / 2, 0])
            cube([spine_len, spine_wid, plate_t]);
        for (i = [0 : tooth_count - 1])
            translate([x0 + i * pitch - tooth_w / 2,
                       -spine_wid / 2 - tooth_l, 0])
                cube([tooth_w, tooth_l, plate_t]);
    }

    // Cut the wells through the top face (z = plate_t)
    for (i = [0 : tooth_count - 1])
        translate([x0 + i * pitch - tooth_w / 2,
                   -spine_wid / 2 - tooth_l - eps,
                   plate_t - eps])
            cube([tooth_w, tooth_l + 2 * eps, 2 * eps]);
}