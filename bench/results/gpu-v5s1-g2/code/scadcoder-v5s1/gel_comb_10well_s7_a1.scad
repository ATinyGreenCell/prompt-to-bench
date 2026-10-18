// 10-well comb for casting agarose gels, printed lying flat
// Units: mm. Print orientation: flat on bed, teeth pointing -Y.

// ---------- Parameters ----------
spine_len      = 70;    // spine (back bar) length (X)
spine_wid      = 12;    // spine width (Y)
plate_thk      = 1.5;   // plate thickness (Z)

tooth_count    = 10;    // number of teeth
tooth_w        = 5.0;   // tooth width (X)
tooth_len      = 12;    // tooth length (Y)
tooth_gap      = 1.5;   // gap between neighbouring teeth (X)

eps            = 0.5;   // cutter overshoot past top/bottom faces

$fn = 64;

// ---------- Derived ----------
row_wid        = tooth_w + tooth_gap;   // width of tooth+gap
row_start_x    = -(tooth_count - 1) * tooth_gap / 2;  // first tooth X (centred row)

// ---------- Model ----------
difference() {
    // Base plate with spine
    translate([-spine_len / 2, -spine_wid / 2, 0])
        cube([spine_len, spine_wid, plate_thk]);

    // Teeth hanging in -Y direction
    for (i = [0 : tooth_count - 1])
        translate([row_start_x + i * row_wid - tooth_w / 2,
                   -tooth_len - eps,
                   -eps])
            cube([tooth_w, tooth_len + tooth_w + 2 * eps, plate_thk + 2 * eps]);
}