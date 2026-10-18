// 10-well agarose gel comb - printed lying flat on the bed
// Units: mm

// ---------- Parameters ----------
plate_thickness = 1.5;    // Z thickness of the whole comb
spine_length    = 70;     // X length of the back spine
spine_width     = 12;     // Y width of the back spine
tooth_count     = 10;     // number of wells / teeth
tooth_width     = 5.0;    // tooth width along X
tooth_length    = 12;     // tooth length along Y
tooth_height    = 12;     // tooth height in Z (from top of spine)
gap             = 1.5;    // gap between neighbouring teeth (X)
overcut         = 0.5;    // extra length so cutters pass through faces

$fn = 64;

// ---------- Derived ----------
pitch      = tooth_width + gap;                 // centre-to-centre spacing
row_offset = -(tooth_count - 1) * pitch / 2;    // centres the row on the spine

// ---------- Model ----------
difference() {
    // Base plate (spine + tooth footprints)
    translate([-spine_length / 2, -spine_width / 2, 0])
        cube([spine_length, spine_width, plate_thickness]);

    // Teeth that hang from the -Y edge of the spine
    for (i = [0 : tooth_count - 1]) {
        translate([row_offset + i * pitch - tooth_width / 2,
                   -spine_width / 2 - tooth_height,
                   -overcut])
            cube([tooth_width, tooth_length, plate_thickness + tooth_height + 2 * overcut]);
    }

    // Wells: cut through the top of the spine (and into the teeth)
    for (i = [0 : tooth_count - 1]) {
        translate([row_offset + i * pitch - tooth_width / 2,
                   -spine_width / 2 + overcut,
                   plate_thickness - overcut])
            cube([tooth_width, tooth_length, plate_thickness + tooth_height]);
    }
}