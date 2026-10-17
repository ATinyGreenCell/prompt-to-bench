// 10-well comb for casting agarose gels, printed lying flat
// Units: mm

// ---- Spine (back bar) ----
spine_len   = 70;   // spine length along X
spine_wid   = 12;   // spine width along Y
plate_thk   = 1.5;  // plate thickness along Z

// ---- Teeth ----
tooth_count = 10;   // number of teeth
tooth_w     = 5.0;  // tooth width along X
tooth_l     = 12;   // tooth length along Y (hangs in -Y)
tooth_gap   = 1.5;  // gap between neighbouring teeth along X

// ---- Misc ----
eps = 0.5;          // overcut for clean differences
$fn = 64;

// Derived
row_len    = tooth_count * tooth_w + (tooth_count - 1) * tooth_gap;  // 56.5 mm
overhang   = (spine_len - row_len) / 2;                              // centre offset in X

difference() {
    // Base plate (spine + teeth area)
    translate([-spine_len / 2, -spine_wid / 2, 0])
        cube([spine_len, spine_wid, plate_thk]);

    // Teeth cut out from the top face, extending past the +Z face
    for (i = [0 : tooth_count - 1]) {
        x = -overhang + i * (tooth_w + tooth_gap);
        translate([x, -spine_wid / 2 - tooth_l, eps])
            cube([tooth_w, tooth_l + eps, plate_thk + eps]);
    }
}