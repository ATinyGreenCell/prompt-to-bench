// 10-well comb for casting agarose gels
// Print orientation: flat on bed, teeth pointing down (-Z)

// ---------- Parameters ----------
spine_len   = 70;    // spine length along X (mm)
spine_w     = 12;    // spine width along Y (mm)
comb_t      = 1.5;   // comb plate thickness along Z (mm)

tooth_w     = 5.0;   // tooth width along X (mm)
tooth_n     = 10;    // number of teeth
tooth_len   = 12;    // tooth length along Y (mm)
tooth_pitch = 1.5;   // gap between neighbouring teeth (mm)

eps         = 0.5;   // cutter overshoot past faces (mm)

$fn = 64;

// ---------- Derived ----------
total_tooth_w = tooth_w * tooth_n + (tooth_n - 1) * tooth_pitch;
x0            = (spine_len - total_tooth_w) / 2;   // first tooth X centre

// ---------- Model ----------
difference() {
    // Base plate (spine + teeth)
    translate([0, 0, 0])
        union() {
            // Spine
            translate([0, 0, 0])
                cube([spine_len, spine_w, comb_t]);

            // Teeth
            for (i = [0 : tooth_n - 1])
                translate([x0 + i * (tooth_w + tooth_pitch),
                           -spine_w / 2,
                           0])
                    cube([tooth_w, tooth_len, comb_t]);
        }

    // Cut out the well spaces (through the full thickness)
    for (i = [0 : tooth_n - 1])
        translate([x0 + i * (tooth_w + tooth_pitch) - eps,
                   -spine_w / 2 - eps,
                   -eps])
            cube([tooth_w + 2 * eps,
                  tooth_len + 2 * eps,
                  comb_t + 2 * eps]);
}