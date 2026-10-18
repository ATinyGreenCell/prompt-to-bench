// 10-well agarose gel comb, printed lying flat
// Units: mm

// ---- Parameters ----
comb_length    = 70;    // spine length (X)
comb_width     = 12;    // spine width (Y)
comb_thickness = 1.5;   // plate thickness (Z)

tooth_count    = 10;    // number of teeth
tooth_width    = 5.0;   // tooth width (X)
tooth_length   = 12;    // tooth length (Y)
tooth_gap      = 1.5;   // gap between teeth (X)

cut_extra      = 0.5;   // overshoot for clean cuts
$fn            = 64;    // curve resolution

// ---- Derived ----
pitch   = tooth_width + tooth_gap;
x0      = -(tooth_count - 1) * pitch / 2;   // first tooth centre (row centred)
reach   = tooth_length + cut_extra;         // tooth tip extension past edge

// ---- Model ----
difference() {
    // Base plate
    translate([-comb_length / 2, -comb_width / 2, 0])
        cube([comb_length, comb_width, comb_thickness]);

    // Teeth, cut from -Y side
    for (i = [0 : tooth_count - 1])
        translate([x0 + i * pitch - tooth_width / 2,
                   -comb_width / 2 - cut_extra,
                   -cut_extra])
            cube([tooth_width, tooth_length, comb_thickness + 2 * cut_extra]);
}