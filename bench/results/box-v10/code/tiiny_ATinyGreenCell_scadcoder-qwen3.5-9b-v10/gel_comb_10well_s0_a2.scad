// 10-well comb for agarose gel casting
// Printed flat, teeth pointing up

$fn = 64;

// ---- Dimensions (mm) ----
spine_len    = 70;    // spine length (X)
spine_wid    = 12;    // spine width (Y)
plate_thk    = 1.5;   // plate thickness (Z)

tooth_count  = 10;    // number of teeth
tooth_w      = 5.0;   // tooth width (X)
tooth_len    = 12;    // tooth length into plate (Y)
tooth_gap    = 1.5;   // gap between teeth (X)

eps          = 0.5;   // cutter overshoot

total_tooth_w = tooth_count * tooth_w;

difference() {
    // Base plate
    translate([-spine_len/2, -spine_wid/2, 0])
        cube([spine_len, spine_wid, plate_thk]);

    // Teeth, centred on spine in X
    for (i = [0 : tooth_count - 1]) {
        x = (i - (tooth_count - 1)/2) * (tooth_w + tooth_gap);
        translate([x, -tooth_len, 0])
            cube([tooth_w, tooth_len, plate_thk]);
    }
}