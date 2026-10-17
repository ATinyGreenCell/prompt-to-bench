// Agarose gel comb - 10 well plate caster
// Print orientation: flat on bed, teeth pointing down (-Y)

// ---- Spine ----
spine_len   = 70;    // spine length along X
spine_wid   = 12;    // spine width along Y
plate_thk   = 1.5;   // plate thickness along Z

// ---- Teeth ----
tooth_count = 10;    // number of wells
tooth_w     = 5.0;   // tooth width along X
tooth_l     = 12;    // tooth length along Y
pitch       = 1.5;   // centre-to-centre spacing along X

// ---- Misc ----
eps         = 0.5;   // cutter overshoot past faces
$fn         = 64;

// Derived
row_span = (tooth_count - 1) * pitch;   // span of gaps
x0       = -(tooth_count * tooth_w + row_span) / 2;  // first tooth X

difference() {
    // Plate with spine
    translate([-spine_len / 2, -spine_wid / 2, 0])
        cube([spine_len, spine_wid, plate_thk]);

    // Teeth cut from -Y side
    for (i = [0 : tooth_count - 1])
        translate([x0 + i * (tooth_w + pitch), -spine_wid / 2 - tooth_l, -eps])
            cube([tooth_w, tooth_l + eps, plate_thk + 2 * eps]);
}