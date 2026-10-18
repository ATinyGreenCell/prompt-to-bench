// 10-well comb for agarose gel casting, printed lying flat
// Units: mm

// ---- Spine ----
spine_len   = 70;   // spine length along X
spine_wid   = 12;   // spine width along Y

// ---- Teeth ----
tooth_count = 10;   // number of wells
tooth_w     = 5.0;  // tooth width along X
tooth_l     = 12;   // tooth length along Y (overlaps spine)

// ---- Gaps ----
gap         = 1.5;  // gap between neighbouring teeth

// ---- Plate ----
plate_t     = 1.5;  // plate thickness along Z

// ---- Misc ----
eps         = 0.5;  // cutter overshoot past faces

$fn = 64;

// Pitch between tooth centres
pitch = tooth_w + gap;

// X offset of first tooth so the row is centred on the spine
row_start = -(tooth_count - 1) * pitch / 2;

union() {
    // Spine (back bar)
    translate([-spine_len / 2, 0, 0])
        cube([spine_len, spine_wid, plate_t]);

    // Teeth hanging in -Y direction
    for (i = [0 : tooth_count - 1]) {
        translate([row_start + i * pitch - tooth_w / 2,
                   -spine_wid - eps,
                   0])
            cube([tooth_w, tooth_l + eps, plate_t]);
    }
}