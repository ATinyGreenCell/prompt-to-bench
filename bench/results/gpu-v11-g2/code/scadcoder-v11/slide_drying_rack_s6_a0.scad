// Slide drying rack - holds 10 microscope slides standing upright on their long edge
// Units: mm. Print orientation: base on XY plane, slots open upward (+Z).

// ---------------- Parameters ----------------
block_len    = 90;     // block length along X
block_wid    = 45;     // block width along Y
block_h      = 20;     // block height along Z

slot_count   = 10;     // number of slide slots
slot_len     = 77;     // slot length along X (slide length + clearance)
slot_w       = 1.6;    // slot width along Y
slot_depth   = 10;     // slot depth from top face along Z
slot_pitch   = 3.5;    // centre-to-centre spacing of slots along Y

eps          = 0.5;    // overshoot so cutters pass cleanly through faces
$fn          = 64;

// ---------------- Derived ----------------
slot_x0 = -(slot_len / 2);              // first slot centre X
// First slot centre Y so the whole group is centred on the block
slot_y0 = -(slot_count - 1) * slot_pitch / 2;

// ---------------- Model ----------------
difference() {
    // Solid base block, centred in X and Y, resting on z = 0
    translate([-block_len / 2, -block_wid / 2, 0])
        cube([block_len, block_wid, block_h]);

    // Parallel slots running along X, open at the top
    for (i = [0 : slot_count - 1])
        translate([slot_x0, slot_y0 + i * slot_pitch, block_h - slot_depth])
            cube([slot_len + 2 * eps, slot_w, slot_depth + eps]);
}