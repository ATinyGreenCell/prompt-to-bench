// 10-well comb for agarose gel casting, printed lying flat
// Units: mm

// ---- Spine ----
spine_len   = 70;   // spine length along X
spine_wid   = 12;   // spine width along Y
spine_thk   = 1.5;  // plate thickness along Z

// ---- Teeth ----
tooth_count = 10;   // number of wells
tooth_wid   = 5.0;  // tooth width along X
tooth_len   = 12;   // tooth length along Y (overlaps spine)
gap         = 1.5;  // gap between neighbouring teeth

// ---- Misc ----
eps         = 0.01; // cut overlap
$fn         = 64;

// Derived
pitch   = tooth_wid + gap;
x_start = -(tooth_count - 1) * pitch / 2;  // row centred on origin

difference() {
    // Base plate (spine + teeth area)
    translate([-spine_len / 2, -tooth_len / 2, 0])
        cube([spine_len, tooth_len, spine_thk]);

    // Cut out teeth (leaving the back bar intact)
    for (i = [0 : tooth_count - 1])
        translate([x_start + i * pitch - tooth_wid / 2, 0, -eps])
            cube([tooth_wid, tooth_len + 2 * eps, spine_thk + 2 * eps]);
}