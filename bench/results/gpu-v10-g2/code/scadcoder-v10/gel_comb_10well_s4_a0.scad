// 10-well comb for agarose gel casting, printed lying flat
// Units: mm

// ---- Spine ----
spine_len   = 70;    // spine length along X
spine_wid   = 12;    // spine width along Y

// ---- Teeth ----
n_teeth     = 10;    // number of teeth
tooth_w     = 5.0;   // tooth width along X
tooth_len   = 12;    // tooth length along Y (into -Y)
gap         = 1.5;   // gap between neighbouring teeth along X

// ---- Plate ----
plate_t     = 1.5;   // plate thickness along Z

// ---- Misc ----
eps         = 0.5;   // cutter overshoot past faces
$fn         = 64;

// Derived
pitch       = tooth_w + gap;              // centre-to-centre tooth spacing
row_span    = (n_teeth - 1) * gap;        // total gap width
x_start     = -(n_teeth * tooth_w + row_span) / 2; // first tooth left edge

difference() {
    // Spine (back bar)
    translate([-spine_len / 2, 0, 0])
        cube([spine_len, spine_wid, plate_t]);

    // Teeth hanging from the -Y edge of the spine
    for (i = [0 : n_teeth - 1])
        translate([x_start + i * pitch, tooth_len, 0])
            cube([tooth_w, tooth_len, plate_t]);
}