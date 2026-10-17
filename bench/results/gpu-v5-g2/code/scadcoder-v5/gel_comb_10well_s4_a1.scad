// 10-well comb for casting agarose gels
// Print orientation: flat on bed, teeth pointing up (+Z)

// ---------- Parameters ----------
spine_len      = 70;    // spine (back bar) length along X
spine_wid      = 12;    // spine width along Y
plate_thk      = 1.5;   // comb plate thickness along Z

tooth_count    = 10;    // number of wells/teeth
tooth_w        = 5.0;   // tooth width along X
tooth_l        = 12;    // tooth length along Y
tooth_pitch    = 1.5;   // centre-to-centre spacing of teeth in X

eps            = 0.5;   // overcut for clean differences
$fn            = 64;

// ---------- Derived ----------
teeth_total_w  = tooth_count * tooth_w + (tooth_count + 1) * tooth_pitch;
x0             = (spine_len - teeth_total_w) / 2;   // row centre offset in X

// ---------- Model ----------
difference() {
    union() {
        // Spine
        translate([0, -spine_wid / 2, 0])
            cube([spine_len, spine_wid, plate_thk]);

        // Teeth
        for (i = [0 : tooth_count - 1])
            translate([x0 + i * (tooth_w + tooth_pitch), -tooth_l / 2, 0])
                cube([tooth_w, tooth_l, plate_thk]);
    }

    // Pockets the teeth cut up into the plate (open at the top face)
    for (i = [0 : tooth_count - 1])
        translate([x0 + i * (tooth_w + tooth_pitch), -tooth_l / 2 - eps, eps])
            cube([tooth_w, tooth_l, plate_thk + 2 * eps]);
}