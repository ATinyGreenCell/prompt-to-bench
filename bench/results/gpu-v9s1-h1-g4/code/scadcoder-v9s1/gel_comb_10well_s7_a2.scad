// 10-well comb for casting agarose gels
// Print orientation: flat on bed, teeth pointing down (-Y)

// ---- Dimensions (mm) ----
plate_t      = 1.5;   // plate thickness (Z)
spine_l      = 70;    // spine length (X)
spine_w      = 12;    // spine width (Y)
tooth_n      = 10;    // number of teeth
tooth_w      = 5.0;   // tooth width (X)
tooth_l      = 12;    // tooth length (Y)
tooth_gap    = 1.5;   // gap between teeth (X)
overcut      = 0.5;   // extra length for clean cuts

$fn = 64;

// ---- Derived ----
pitch   = tooth_w + tooth_gap;            // centre-to-centre spacing
x_start = -(tooth_n - 1) * pitch / 2;     // first tooth centre (row centred)

difference() {
    // Spine (back bar)
    translate([-spine_l / 2, 0, 0])
        cube([spine_l, spine_w, plate_t]);

    // Teeth, cut into the plate
    for (i = [0 : tooth_n - 1])
        translate([x_start + i * pitch - tooth_w / 2,
                   -spine_w - overcut,
                   -overcut])
            cube([tooth_w, tooth_l, plate_t + 2 * overcut]);
}