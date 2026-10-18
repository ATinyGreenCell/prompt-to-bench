// 10-well comb for casting agarose gels
// Print orientation: flat on bed, teeth pointing down (-Y)

// ---- Parameters ----
plate_t      = 1.5;   // plate thickness (Z)
spine_len    = 70;    // spine length along X
spine_w      = 12;    // spine width along Y
tooth_n      = 10;    // number of teeth
tooth_w      = 5.0;   // tooth width along X
tooth_len    = 12;    // tooth length along Y
tooth_gap    = 1.5;   // gap between neighbouring teeth along X
eps          = 0.5;   // cutter overshoot past faces

$fn = 64;

// ---- Derived ----
pitch   = tooth_w + tooth_gap;            // centre-to-centre spacing
x0      = -(tooth_n - 1) * pitch / 2;     // first tooth centre (row centred)

// ---- Model ----
difference() {
    union() {
        // Spine (back bar)
        translate([-spine_len / 2, 0, 0])
            cube([spine_len, spine_w, plate_t]);

        // Teeth hanging from -Y edge
        for (i = [0 : tooth_n - 1])
            translate([x0 + i * pitch - tooth_w / 2, -tooth_len, 0])
                cube([tooth_w, tooth_len, plate_t]);
    }

    // Through-cut each tooth (extends past top and bottom faces)
    for (i = [0 : tooth_n - 1])
        translate([x0 + i * pitch - tooth_w / 2, -tooth_len - eps, -eps])
            cube([tooth_w, tooth_len + 2 * eps, plate_t + 2 * eps]);
}