// Slide drying rack - holds 10 microscope slides standing upright on their long edge
// Print orientation: flat base on the XY plane, slots open upward (+Z)

// ---------------- Parameters ----------------
block_len    = 90;    // block length along X (mm)
block_wid    = 45;    // block width along Y (mm)
block_h      = 20;    // block height along Z (mm)

slot_count   = 10;    // number of slide slots
slot_len     = 77;    // slot length along X (mm)
slot_w       = 1.6;   // slot width along Y (mm)
slot_depth   = 10;    // slot depth from top face (mm)
slot_pitch   = 3.5;   // centre-to-centre slot spacing along Y (mm)

eps          = 0.5;   // overshoot so cutters pass through the top face (mm)

$fn = 64;

// ---------------- Model ----------------
difference() {
    // Main block, centred in X and Y, resting on z = 0
    translate([-block_len/2, -block_wid/2, 0])
        cube([block_len, block_wid, block_h]);

    // Slot group, centred on the block in X and Y
    for (i = [0 : slot_count - 1]) {
        y = (i - (slot_count - 1)/2) * slot_pitch;
        translate([-slot_len/2, y, block_h - slot_depth])
            cube([slot_len, slot_w, slot_depth + eps]);
    }
}