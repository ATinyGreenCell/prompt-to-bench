// 10-well comb for casting agarose gels
// Print orientation: flat on bed, teeth pointing down (-Z)

$fn = 64;

// ---- Dimensions (mm) ----
comb_length    = 70;    // spine (back bar) length in X
comb_width     = 12;    // spine width in Y
plate_thick    = 1.5;   // base plate thickness in Z
tooth_count    = 10;    // number of wells/teeth
tooth_width    = 5.0;   // tooth width in X
tooth_length   = 12;    // tooth length in Y
tooth_depth    = 12;    // tooth depth from spine in -Y
tooth_gap      = 1.5;   // gap between neighbouring teeth in X
overcut        = 0.5;   // extra length on cutters to avoid coplanar faces

// ---- Derived ----
pitch   = tooth_width + tooth_gap;             // centre-to-centre spacing
x_start = -(tooth_count - 1) * pitch / 2;      // first tooth centre (row centred)

// ---- Model ----
union() {
    // Base plate
    translate([-comb_length / 2, -comb_width / 2, 0])
        cube([comb_length, comb_width, plate_thick]);

    // Teeth (wells), cast from the spine
    for (i = [0 : tooth_count - 1]) {
        translate([x_start + i * pitch, 0, 0])
            cube([tooth_width, tooth_length, tooth_depth]);
    }
}