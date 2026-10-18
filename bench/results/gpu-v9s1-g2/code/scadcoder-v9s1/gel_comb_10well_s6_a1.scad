// 10-well agarose gel comb, printed lying flat
// Units: mm

// ---------- Parameters ----------
plate_thickness = 1.5;    // plate (base) thickness (Z)
spine_length    = 70;     // spine/back bar length (X)
spine_width     = 12;     // spine/back bar width (Y)

tooth_count     = 10;     // number of wells/teeth
tooth_width     = 5.0;    // tooth width (X)
tooth_length    = 12;     // tooth length (Y)
tooth_depth     = 12;     // tooth depth from spine edge (Y)

gap             = 1.5;    // gap between neighbouring teeth (X)
overcut         = 0.5;    // extra length on cutting shapes past faces

$fn = 64;

// ---------- Derived ----------
teeth_span = (tooth_count - 1) * gap;   // distance first-to-last tooth centres
x_start    = -(teeth_span + gap) / 2;   // first tooth left edge (row centred)

// ---------- Model ----------
difference() {
    // Base plate
    translate([-spine_length / 2, 0, 0])
        cube([spine_length, spine_width, plate_thickness]);

    // Teeth hanging in -Y from the spine
    for (i = [0 : tooth_count - 1]) {
        translate([x_start + i * (tooth_width + gap),
                   -tooth_length,
                   0])
            cube([tooth_width, tooth_depth, plate_thickness]);
    }

    // Well cavities, cut through the plate
    for (i = [0 : tooth_count - 1]) {
        translate([x_start + i * (tooth_width + gap) - tooth_width / 2,
                   -tooth_length - overcut,
                   -overcut])
            cube([tooth_width, tooth_depth + 2 * overcut,
                  plate_thickness + 2 * overcut]);
    }
}