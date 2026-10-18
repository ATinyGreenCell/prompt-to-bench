// 10-well agarose gel comb, printed lying flat
// Units: mm. Plate thickness (Z) = 1.5.

// ---- Spine (back bar) ----
spine_len   = 70;   // spine length along X
spine_wid   = 12;   // spine width along Y

// ---- Teeth ----
tooth_count = 10;   // number of wells
tooth_w     = 5.0;  // tooth width along X
tooth_l     = 12;   // tooth length along Y (overlaps spine by 12 mm)
gap         = 1.5;  // gap between neighbouring teeth along X

// ---- Misc ----
eps         = 0.5;  // cutter overshoot past faces
$fn         = 64;

// Derived
pitch    = tooth_w + gap;                 // centre-to-centre spacing
x_start  = -(tooth_count - 1) * pitch / 2; // first tooth centre (row centred)
tooth_h  = tooth_l + spine_wid;           // total tooth height from -Y edge

module spine() {
    translate([-spine_len / 2, 0, 0])
        cube([spine_len, spine_wid, 1.5]);
}

module teeth() {
    for (i = [0 : tooth_count - 1]) {
        translate([x_start + i * pitch - tooth_w / 2, -tooth_h, 0])
            cube([tooth_w, tooth_l, 1.5]);
    }
}

union() {
    spine();
    teeth();
}