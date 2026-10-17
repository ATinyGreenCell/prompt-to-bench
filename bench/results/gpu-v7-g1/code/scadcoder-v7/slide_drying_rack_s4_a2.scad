// Slide drying rack - holds 10 microscope slides standing upright on their long edge
// Print orientation: base block on the bed, slots open upward (+Z)

// ---------- Block ----------
block_len   = 90;    // block length along X (mm)
block_wid   = 45;    // block width along Y (mm)
block_ht    = 20;    // block height along Z (mm)

// ---------- Slots ----------
slot_count  = 10;    // number of slide slots
slot_len    = 77;    // slot length along X (mm)
slot_wid    = 1.6;   // slot width along Y (mm)
slot_depth  = 10;    // slot depth from top face (mm)
slot_pitch  = 3.5;   // centre-to-centre spacing in Y (mm)

// ---------- Misc ----------
eps         = 0.5;   // overshoot for clean boolean cuts (mm)
$fn         = 64;    // curve resolution

// Derived
first_y = -(slot_count - 1) * slot_pitch / 2;  // Y of first slot, groups centred in Y

difference() {
    // Solid base block, centred in X and Y, resting on z = 0
    translate([-block_len / 2, -block_wid / 2, 0])
        cube([block_len, block_wid, block_ht]);

    // Parallel slots, open at the top
    for (i = [0 : slot_count - 1]) {
        translate([0, first_y + i * slot_pitch, block_ht - slot_depth])
            cube([slot_len, slot_wid, slot_depth + eps]);
    }
}