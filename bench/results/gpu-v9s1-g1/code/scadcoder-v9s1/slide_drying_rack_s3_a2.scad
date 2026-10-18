// Microscope slide drying rack
// 10 slides standing on their long edge, side by side

// ---- Block ----
block_len   = 90;   // X length of base block
block_wid   = 45;   // Y width of base block
block_h     = 20;   // Z height of base block

// ---- Slots ----
slot_count  = 10;   // number of slide slots
slot_len    = 77;   // slot length along X
slot_w      = 1.6;  // slot width along Y
slot_depth  = 10;   // slot depth from top face (Z)
slot_pitch  = 3.5;  // centre-to-centre spacing along Y

// ---- Cut clearance ----
eps         = 0.5;  // overshoot past cut faces

$fn = 64;

difference() {
    // Base block, centred in X/Y, resting on z = 0
    translate([-block_len/2, -block_wid/2, 0])
        cube([block_len, block_wid, block_h]);

    // Slots, centred in X and Y
    for (i = [0 : slot_count - 1]) {
        y = (i - (slot_count - 1)/2) * slot_pitch;
        translate([-slot_len/2, y, block_h - slot_depth])
            cube([slot_len, slot_w, slot_depth + eps]);
    }
}