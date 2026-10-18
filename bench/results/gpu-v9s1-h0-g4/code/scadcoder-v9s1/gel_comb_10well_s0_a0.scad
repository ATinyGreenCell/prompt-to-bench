// 10-well comb for casting agarose gels
// Print orientation: flat on bed, teeth pointing down (-Y)

// ---------- Parameters ----------
plate_t      = 1.5;    // plate thickness (Z)
spine_l      = 70;     // spine length (X)
spine_w      = 12;     // spine width (Y)
tooth_n      = 10;     // number of teeth
tooth_w      = 5.0;    // tooth width (X)
tooth_l      = 12;     // tooth length (Y)
gap          = 1.5;    // gap between teeth (X)
overcut      = 0.5;    // extra length on cutters to avoid coplanar faces

$fn = 64;

// ---------- Derived ----------
pitch   = tooth_w + gap;                 // centre-to-centre spacing
x_start = -(tooth_n - 1) * pitch / 2;    // first tooth centre (row centred)

// ---------- Model ----------
difference() {
    union() {
        // Spine (back bar)
        translate([-spine_l / 2, 0, 0])
            cube([spine_l, spine_w, plate_t]);

        // Teeth
        for (i = [0 : tooth_n - 1])
            translate([x_start + i * pitch - tooth_w / 2,
                       -tooth_l,
                       0])
                cube([tooth_w, tooth_l + overcut, plate_t]);
    }

    // Cut out the wells (through the plate, into the teeth)
    for (i = [0 : tooth_n - 1])
        translate([x_start + i * pitch - tooth_w / 2,
                   -tooth_l - overcut,
                   -overcut])
            cube([tooth_w, tooth_l + 2 * overcut, plate_t + 2 * overcut]);
}