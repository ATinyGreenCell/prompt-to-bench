// 10-well agarose gel comb, printed lying flat
// Units: mm

// ---- Spine ----
spine_len   = 70;   // spine length (X)
spine_wid   = 12;   // spine width (Y)
plate_thk   = 1.5;  // plate thickness (Z)

// ---- Teeth ----
tooth_count = 10;   // number of teeth
tooth_w     = 5.0;  // tooth width (X)
tooth_l     = 12;   // tooth length (Y)
tooth_h     = 12;   // tooth height from spine (Z)

// ---- Gaps ----
gap         = 1.5;  // gap between neighbouring teeth (X)

// ---- Derived ----
pitch       = tooth_w + gap;              // centre-to-centre spacing
x_start     = -(tooth_count - 1) * pitch / 2; // first tooth centre (row centred on spine)
eps         = 0.5;  // cutter overshoot past faces

union() {
    // Spine (back bar)
    translate([-spine_len / 2, -spine_wid / 2, 0])
        cube([spine_len, spine_wid, plate_thk]);

    // Teeth, hanging in -Y direction
    for (i = [0 : tooth_count - 1]) {
        translate([x_start + i * pitch - tooth_w / 2,
                   -spine_wid / 2 - tooth_l,
                   0])
            cube([tooth_w, tooth_l, tooth_h]);
    }
}