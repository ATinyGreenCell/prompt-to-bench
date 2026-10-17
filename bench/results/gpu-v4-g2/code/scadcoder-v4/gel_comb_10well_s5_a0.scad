// 10-well comb for agarose gel casting, printed lying flat
// Units: mm

// ---- Spine ----
spine_len   = 70;    // spine length (X)
spine_wid   = 12;    // spine width (Y)

// ---- Teeth ----
tooth_count = 10;    // number of teeth
tooth_w     = 5.0;   // tooth width (X)
tooth_l     = 12;    // tooth length (Y)

// ---- Pitch ----
pitch       = 1.5;   // gap between tooth centres (X)

// ---- Plate ----
plate_t     = 1.5;   // plate thickness (Z)

// ---- Misc ----
eps         = 0.5;   // cutter overshoot

$fn = 64;

teoth_wid = tooth_w + pitch;   // centre-to-centre spacing

difference() {
    union() {
        // Spine
        translate([-spine_len/2, 0, 0])
            cube([spine_len, spine_wid, plate_t]);

        // Teeth
        for (i = [0 : tooth_count - 1])
            translate([(i - (tooth_count - 1)/2) * tooth_wid,
                       -spine_wid/2 - eps,
                       0])
                cube([tooth_w, tooth_l, plate_t]);
    }

    // Cut out the wells (through the full plate)
    for (i = [0 : tooth_count - 1])
        translate([(i - (tooth_count - 1)/2) * tooth_wid,
                   -spine_wid/2 - eps - 0.01,
                   -eps])
            cube([tooth_w, tooth_l + 2*eps, 2*eps + plate_t + 0.02]);
}