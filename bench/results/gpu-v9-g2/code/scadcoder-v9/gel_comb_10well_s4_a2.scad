// 10-well comb for agarose gel casting
// Print orientation: flat on bed, teeth pointing up (+Z)

// ---------- Parameters ----------
plate_len    = 70;    // spine length along X (mm)
plate_wid    = 12;    // spine width along Y (mm)
plate_thk    = 1.5;   // plate thickness along Z (mm)

tooth_count  = 10;    // number of wells/teeth
tooth_w      = 5.0;   // tooth width along X (mm)
tooth_len    = 12;    // tooth length along Y (mm)
tooth_pitch  = 1.5;   // gap between neighbouring teeth (mm)

eps          = 0.5;   // cutter overshoot past faces (mm)
$fn          = 64;    // curve resolution

// ---------- Derived ----------
total_tooth_w = tooth_count * tooth_w + (tooth_count - 1) * tooth_pitch;
x_start       = -(plate_len / 2 - total_tooth_w / 2);  // first tooth centre X

// ---------- Model ----------
union() {
    // Spine (back bar)
    translate([-plate_len / 2, -plate_wid / 2, 0])
        cube([plate_len, plate_wid, plate_thk]);

    // Teeth, hanging from the -Y edge of the spine
    for (i = [0 : tooth_count - 1]) {
        translate([x_start + i * (tooth_w + tooth_pitch),
                   -tooth_len,
                   0])
            cube([tooth_w, tooth_len + plate_wid / 2 + eps, plate_thk]);
    }
}