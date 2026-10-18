// 10-well agarose gel comb, printed lying flat
// Units: mm. Print orientation: plate on bed (z = 0), teeth up (+Z).

// ---------------- Parameters ----------------
plate_t      = 1.5;    // plate thickness (Z)
spine_len    = 70;     // spine length (X)
spine_w      = 12;     // spine width (Y)

tooth_count  = 10;     // number of wells
tooth_w      = 5.0;    // tooth width (X)
tooth_l      = 12;     // tooth length (Y)
tooth_h      = 12;     // tooth height from plate (Z)

gap          = 1.5;    // gap between neighbouring teeth (X)
eps          = 0.5;    // overcut for clean differences

$fn = 64;

// ---------------- Derived ----------------
pitch   = tooth_w + gap;              // centre-to-centre spacing
x0      = -(tooth_count - 1) * pitch / 2; // first tooth centre (row centred)

// ---------------- Model ----------------
union() {
    // Spine (back bar)
    translate([-spine_len / 2, 0, 0])
        cube([spine_len, spine_w, plate_t]);

    // Teeth
    for (i = [0 : tooth_count - 1])
        translate([x0 + i * pitch - tooth_w / 2,
                   spine_w - tooth_l,
                   0])
            cube([tooth_w, tooth_l, tooth_h]);
}