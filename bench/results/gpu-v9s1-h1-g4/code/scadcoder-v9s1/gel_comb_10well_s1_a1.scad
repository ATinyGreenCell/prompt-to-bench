// 10-well agarose gel comb, printed lying flat
// Units: mm

// ---- Spine ----
spine_len   = 70;   // spine length along X
spine_wid   = 12;   // spine width along Y

// ---- Teeth ----
tooth_count = 10;   // number of teeth
tooth_w     = 5.0;  // tooth width along X
tooth_len   = 12;   // tooth length along Y
gap         = 1.5;  // gap between teeth

// ---- Plate ----
plate_t     = 1.5;  // plate thickness along Z

// ---- Misc ----
eps         = 0.5;  // cutter overshoot past faces
$fn         = 64;   // curve resolution

pitch       = tooth_w + gap;                 // tooth pitch
row_offset  = -(tooth_count - 1) * pitch / 2; // centre row on origin

union() {
    // Spine
    translate([-spine_len / 2, 0, 0])
        cube([spine_len, spine_wid, plate_t]);

    // Teeth (extend past -Y face, overlap spine slightly)
    for (i = [0 : tooth_count - 1])
        translate([row_offset + i * pitch - tooth_w / 2,
                   -spine_wid - eps,
                   0])
            cube([tooth_w, tooth_len + eps, plate_t]);
}