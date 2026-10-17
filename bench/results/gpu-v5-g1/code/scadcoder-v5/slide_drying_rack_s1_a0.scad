// Slide drying rack - holds 10 microscope slides upright on their long edge
// Print orientation: base block on the XY plane, slots open upward (+Z)

// ---------------- Parameters ----------------
block_len    = 90;    // base block length along X (mm)
block_wid    = 45;    // base block width along Y (mm)
block_ht     = 20;    // base block height along Z (mm)

slot_count   = 10;    // number of slide slots
slot_len     = 77;    // slot length along X (mm)
slot_wid     = 1.6;   // slot width along Y (mm)
slot_depth   = 10;    // slot depth from top face (mm)
slot_pitch   = 3.5;   // centre-to-centre spacing of slots along Y (mm)

eps          = 0.5;   // overshoot so cutters pass cleanly through the top face

$fn = 64;

// ---------------- Model ----------------
difference() {
    // Solid base block, centred in X and Y, resting on z = 0
    translate([-block_len/2, -block_wid/2, 0])
        cube([block_len, block_wid, block_ht]);

    // Row of parallel slots, centred on the block in X and Y
    for (i = [0 : slot_count - 1]) {
        y_c = (i - (slot_count - 1)/2) * slot_pitch;
        translate([-slot_len/2, y_c - slot_wid/2, block_ht - slot_depth])
            cube([slot_len, slot_wid, slot_depth + eps]);
    }
}