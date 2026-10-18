// 10-well agarose gel comb - printed lying flat
// Units: mm

// ---- Parameters ----
plate_t      = 1.5;   // plate thickness (Z)
spine_len    = 70;    // spine length (X)
spine_w      = 12;    // spine width (Y)
tooth_w      = 5.0;   // tooth width (X)
tooth_len    = 12;    // tooth length (Y)
tooth_count  = 10;    // number of teeth
gap          = 1.5;   // gap between teeth (X)
overhang     = 0.5;   // tooth extension past spine front edge

$fn = 64;

// ---- Derived ----
pitch   = tooth_w + gap;
x_start = -(tooth_count - 1) * pitch / 2;  // centre row on spine

// ---- Model ----
union() {
    // Spine
    translate([-spine_len/2, -spine_w/2, 0])
        cube([spine_len, spine_w, plate_t]);

    // Teeth
    for (i = [0 : tooth_count - 1])
        translate([x_start + i * pitch - tooth_w/2,
                   spine_w/2 - tooth_len,
                   0])
            cube([tooth_w, tooth_len + overhang, plate_t]);
}