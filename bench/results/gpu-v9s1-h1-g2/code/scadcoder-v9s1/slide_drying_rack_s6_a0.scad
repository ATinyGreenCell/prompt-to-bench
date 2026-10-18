// Slide drying rack - holds 10 microscope slides standing upright on their long edge
// Print orientation: base block on the bed (z = 0), slots open at the top

// ---------- Block ----------
block_l = 90;    // block length along X (mm)
block_w = 45;    // block width along Y (mm)
block_h = 20;    // block height along Z (mm)

// ---------- Slots ----------
slot_n     = 10;    // number of slide slots
slot_len   = 77;    // slot length along X (mm)
slot_w     = 1.6;   // slot width along Y (mm)
slot_depth = 10;    // slot depth into the block (mm)
slot_pitch = 3.5;   // centre-to-centre spacing along Y (mm)

// ---------- Misc ----------
eps = 0.5;       // overshoot so cutters pass cleanly through the top face (mm)
$fn = 64;

// Derived: first slot centre Y, then all slot centres
slot_y0 = -(slot_n - 1) * slot_pitch / 2;
slot_c  = [for (i = [0 : slot_n - 1]) [i * slot_pitch]];

difference() {
    // Solid base block, centred in X and Y, sitting on z = 0
    translate([-block_l / 2, -block_w / 2, 0])
        cube([block_l, block_w, block_h]);

    // Parallel slots running along X, open at the top
    for (j = [0 : slot_n - 1])
        translate([-slot_len / 2, slot_y0 + slot_c[j] - slot_pitch / 2, block_h - slot_depth])
            cube([slot_len, slot_w, slot_depth + eps]);
}