// Microscope slide drying rack
// Units: mm. Print orientation: base on XY plane, building up +Z.

// ---------------- Parameters ----------------
block_len    = 90;    // block length along X
block_wid    = 45;    // block width along Y
block_h      = 20;    // block height along Z

slot_count   = 10;    // number of slide slots
slot_len     = 77;    // slot length along X (slide length + clearance)
slot_w       = 1.6;   // slot width along Y (slide thickness + clearance)
slot_depth   = 10;    // slot depth from top face
slot_pitch   = 3.5;   // centre-to-centre slot spacing along Y

eps          = 0.5;   // overshoot for clean boolean cuts
$fn          = 64;    // curve resolution (no curves here; kept per convention)

// ---------------- Model ----------------
difference() {
    // Base block, centred in X and Y, resting on z = 0
    translate([-block_len/2, -block_wid/2, 0])
        cube([block_len, block_wid, block_h]);

    // Slot group, centred on the block in X and Y
    for (i = [0 : slot_count - 1]) {
        y = (i - (slot_count - 1)/2) * slot_pitch;
        translate([-slot_len/2, y, block_h - slot_depth])
            // Slot runs along X, open at the top face
            cube([slot_len, slot_w, slot_depth + eps]);
    }
}