// 10-well comb for casting agarose gels
// Print orientation: flat on bed, teeth pointing down (-Z)

// ---------- Parameters ----------
plate_len    = 70;    // spine length (X)
plate_w      = 12;    // spine width (Y)
plate_t      = 1.5;   // plate thickness (Z)

tooth_count  = 10;    // number of teeth
tooth_w      = 5.0;   // tooth width (X)
tooth_len    = 12;    // tooth length (Y)
tooth_h      = 12;    // tooth height from plate top (Z)

gap          = 1.5;   // gap between teeth (X)
eps          = 0.5;   // cutter overshoot past faces (Z)

$fn = 64;

// ---------- Derived ----------
pitch    = tooth_w + gap;
x_start  = -(tooth_count - 1) * pitch / 2;   // centre row on origin
plate_z0 = -plate_t / 2 + eps;               // cutter start below bottom face

// ---------- Model ----------
union() {
    // Base plate
    translate([-plate_len / 2, -plate_w / 2, 0])
        cube([plate_len, plate_w, plate_t]);

    // Teeth
    for (i = [0 : tooth_count - 1])
        translate([x_start + i * pitch - tooth_w / 2, -tooth_len / 2, plate_z0])
            cube([tooth_w, tooth_len / 2, tooth_h]);
}