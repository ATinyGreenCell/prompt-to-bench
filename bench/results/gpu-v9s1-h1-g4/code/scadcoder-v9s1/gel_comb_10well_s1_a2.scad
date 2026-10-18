// 10-well comb for agarose gel casting
// Print orientation: flat on bed, teeth pointing down (-Z)

// ---------- Parameters ----------
plate_thickness = 4;     // mm, base plate thickness
spine_length    = 70;    // mm, spine (back bar) length in X
spine_width     = 12;    // mm, spine width in Y
tooth_count     = 10;    // number of wells
tooth_width     = 5;     // mm, tooth width in X
tooth_length    = 12;    // mm, tooth length in Y
gap             = 1.5;   // mm, gap between neighbouring teeth
overcut         = 0.5;   // mm, extra length on cutters past faces

$fn = 64;

// ---------- Derived ----------
pitch      = tooth_width + gap;
row_offset = -(tooth_count - 1) * pitch / 2;   // centres row on spine in X
spine_x0   = -spine_length / 2;

// ---------- Model ----------
union() {
    // Base plate
    translate([spine_x0 - overcut, -spine_width / 2, 0])
        cube([spine_length + 2 * overcut, spine_width, plate_thickness]);

    // Spine (back bar), extended above top face
    translate([spine_x0, -spine_width / 2, plate_thickness])
        cube([spine_length, spine_width, overcut]);

    // Teeth, hanging from the spine in -Y, overlapping the top face
    for (i = [0 : tooth_count - 1]) {
        translate([row_offset + i * pitch - tooth_width / 2,
                   spine_width / 2 - tooth_length,
                   plate_thickness])
            cube([tooth_width, tooth_length + overcut, overcut]);
    }
}