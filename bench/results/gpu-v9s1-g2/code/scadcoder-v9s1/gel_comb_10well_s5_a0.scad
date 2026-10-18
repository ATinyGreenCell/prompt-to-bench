// 10-well comb for agarose gel casting, printed lying flat
// Units: mm

// ---- Spine ----
spine_len   = 70;   // spine length (X)
spine_wid   = 12;   // spine width (Y)
plate_thk   = 1.5;  // plate thickness (Z)

// ---- Teeth ----
tooth_count = 10;   // number of teeth
tooth_w     = 5.0;  // tooth width (X)
tooth_l     = 12;   // tooth length (Y)
tooth_h     = 12;   // tooth height from spine (-Y)

// ---- Misc ----
eps         = 0.5;  // cutter overshoot
$fn         = 64;

// Pitch between tooth centres
pitch = tooth_w + 1.5;

difference() {
    // Base plate
    translate([-spine_len/2, 0, 0])
        cube([spine_len, spine_wid, plate_thk]);

    // Teeth row, centred on spine in X
    for (i = [0 : tooth_count - 1]) {
        x = (i - (tooth_count - 1) / 2) * pitch;
        translate([x, -tooth_h, 0])
            cube([tooth_w, tooth_l, plate_thk + eps]);
    }
}