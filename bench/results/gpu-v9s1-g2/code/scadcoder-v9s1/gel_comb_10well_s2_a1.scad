// 10-well agarose gel comb, printed lying flat
// Units: mm

// ---------- Parameters ----------
comb_length    = 70;    // spine length (X)
comb_width     = 12;    // spine width (Y)
comb_thickness = 1.5;   // plate thickness (Z)

tooth_count    = 10;    // number of teeth
tooth_width    = 5.0;   // tooth width (X)
tooth_length   = 12;    // tooth length (Y)
tooth_overlap  = 1.5;   // gap between neighbouring teeth (X)

eps            = 0.5;   // cutter overshoot past faces
$fn            = 64;    // curve resolution

// ---------- Derived ----------
pitch      = tooth_width + tooth_overlap;
row_offset = -(tooth_count - 1) * pitch / 2;   // centre row on origin in X

// ---------- Model ----------
difference() {
    // Base plate (spine + teeth top faces)
    translate([-comb_length / 2, 0, 0])
        cube([comb_length, comb_width, comb_thickness]);

    // Teeth, hanging from -Y edge
    for (i = [0 : tooth_count - 1])
        translate([row_offset + i * pitch - tooth_width / 2,
                   -tooth_length,
                   -eps])
            cube([tooth_width, tooth_length + comb_thickness + 2 * eps,
                  comb_thickness + 2 * eps]);
}