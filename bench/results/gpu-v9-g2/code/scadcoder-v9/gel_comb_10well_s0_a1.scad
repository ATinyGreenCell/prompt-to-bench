// 10-well comb for agarose gel casting
// Print orientation: flat on bed, teeth pointing down (-Z)

// ---- Parameters ----
plate_len    = 70;    // spine length (X)
plate_wid    = 12;    // spine width (Y)
plate_thk    = 1.5;   // plate thickness (Z)
tooth_count  = 10;    // number of wells
tooth_w      = 5.0;   // tooth width (X)
tooth_len    = 12;    // tooth length (Y)
gap          = 1.5;   // tooth gap (X)
eps          = 0.5;   // cutter overshoot

$fn = 64;

// ---- Derived ----
pitch   = tooth_w + gap;
x_start = -(tooth_count - 1) * gap / 2;

// ---- Model ----
difference() {
    translate([-plate_len/2, -plate_wid/2, 0])
        cube([plate_len, plate_wid, plate_thk]);
    for (i = [0 : tooth_count - 1])
        translate([x_start + i * pitch, 0, 0])
            rotate([90, 0, 0])
                cube([tooth_len, tooth_w, eps]);
}