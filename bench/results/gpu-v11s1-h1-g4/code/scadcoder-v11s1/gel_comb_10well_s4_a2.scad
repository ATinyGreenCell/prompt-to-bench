// 10-well comb for agarose gel casting
// Print orientation: flat on bed, teeth pointing down (-Y)

// ---- Parameters ----
tooth_count  = 10;    // number of teeth
tooth_w      = 5.0;   // tooth width (X)
tooth_l      = 12;    // tooth length (Y)
gap          = 1.5;   // gap between teeth (X)
spine_l      = 70;    // spine length (X)
spine_w      = 12;    // spine width (Y)
thickness    = 1.5;   // plate thickness (Z)

eps          = 0.5;   // cutter overshoot
$fn          = 64;

// ---- Derived ----
pitch   = tooth_w + gap;
x_start = -(tooth_count - 1) * pitch / 2;   // first tooth centre

// ---- Model ----
union() {
    // Teeth
    for (i = [0 : tooth_count - 1])
        translate([x_start + i * pitch - tooth_w / 2,
                   -tooth_l - eps,
                   0])
            cube([tooth_w, tooth_l + 2 * eps, thickness]);

    // Spine
    translate([-spine_l / 2, -spine_w / 2, 0])
        cube([spine_l, spine_w, thickness]);
}