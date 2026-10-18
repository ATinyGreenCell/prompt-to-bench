// 10-well agarose gel comb, printed lying flat
// Units: mm

// ---- Spine ----
spine_len   = 70;   // spine length along X
spine_wid   = 12;   // spine width along Y
spine_thk   = 1.5;  // spine thickness along Z

// ---- Teeth ----
tooth_count = 10;   // number of teeth
tooth_w     = 5.0;  // tooth width along X
tooth_l     = 12;   // tooth length along Y (hang from -Y edge)
tooth_gap   = 1.5;  // gap between neighbouring teeth along X

// ---- Misc ----
eps = 0.5;          // cutter overshoot past faces

$fn = 64;

// Offset of the first tooth so the row is centred on the spine
row_start = -(tooth_count - 1) * tooth_gap / 2;

difference() {
    // Spine (back bar)
    translate([-spine_len / 2, -spine_wid / 2, 0])
        cube([spine_len, spine_wid, spine_thk]);

    // Teeth, hanging from the -Y edge of the spine
    for (i = [0 : tooth_count - 1])
        translate([row_start + i * (tooth_w + tooth_gap), -spine_wid / 2, 0])
            cube([tooth_w, tooth_l, spine_thk]);
}