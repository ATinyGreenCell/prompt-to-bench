// 10-well comb for agarose gel casting, printed lying flat
// Units: mm

// ---- Spine ----
spine_len   = 70;   // spine length along X
spine_wid   = 12;   // spine width along Y
plate_thk   = 1.5;  // plate thickness along Z

// ---- Teeth ----
tooth_count = 10;   // number of teeth
tooth_w     = 5.0;  // tooth width along X
tooth_len   = 12;   // tooth length along Y (overlaps spine)
gap         = 1.5;  // gap between neighbouring teeth

// ---- Misc ----
eps         = 0.5;  // cutter overshoot past faces
$fn         = 64;

// Derived
pitch   = tooth_w + gap;
x_start = -(tooth_count - 1) * pitch / 2;  // first tooth centre, row centred

difference() {
    // Base plate
    translate([-spine_len / 2, -spine_wid / 2, 0])
        cube([spine_len, spine_wid, plate_thk]);

    // Teeth hanging in -Y
    for (i = [0 : tooth_count - 1]) {
        translate([x_start + i * pitch - tooth_w / 2,
                   -spine_wid / 2 - tooth_len,
                   0])
            cube([tooth_w, tooth_len + eps, plate_thk + eps]);
    }
}