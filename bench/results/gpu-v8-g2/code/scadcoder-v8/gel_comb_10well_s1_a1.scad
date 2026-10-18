// 10-well agarose gel comb, printed flat
// Units: mm

// ---------- Parameters ----------
spine_len      = 70;    // spine length (X)
spine_wid      = 12;    // spine width (Y)
plate_thk      = 1.5;   // plate thickness (Z)

tooth_count    = 10;    // number of teeth
tooth_w        = 5.0;   // tooth width (X)
tooth_len      = 12;    // tooth length from spine (Y, -Y direction)
tooth_gap      = 1.5;   // gap between neighbouring teeth (X)

eps            = 0.5;   // cutter overshoot past faces

$fn = 64;

// ---------- Derived ----------
pitch   = tooth_w + tooth_gap;          // centre-to-centre spacing
x_start = -(tooth_count - 1) * pitch / 2; // first tooth centre (row centred on spine)

// ---------- Model ----------
difference() {
    // Base plate
    translate([-spine_len / 2, -spine_wid / 2, 0])
        cube([spine_len, spine_wid, plate_thk]);

    // Teeth cut out from the -Y edge of the spine
    for (i = [0 : tooth_count - 1])
        translate([x_start + i * pitch - tooth_w / 2,
                   -spine_wid / 2 - tooth_len,
                   -eps])
            cube([tooth_w, tooth_len + eps, plate_thk + 2 * eps]);
}