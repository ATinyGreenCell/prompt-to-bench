// Microscope slide drying rack
// 10 slides standing on their long edge, side by side

// ---- Block ----
block_l = 90;    // X length of base block
block_w = 45;    // Y width of base block
block_h = 20;    // Z height of base block

// ---- Slots ----
slot_count = 10;     // number of slide slots
slot_len   = 77;     // slot length along X
slot_w     = 1.6;    // slot width along Y
slot_depth = 10;     // slot depth from top face
pitch      = 3.5;    // centre-to-centre spacing along Y

// ---- Misc ----
eps = 0.5;          // overcut past faces
$fn = 64;

difference() {
    // Base block
    translate([-block_l/2, -block_w/2, 0])
        cube([block_l, block_w, block_h]);

    // Slots, centred in X and Y
    for (i = [0 : slot_count - 1]) {
        y = (i - (slot_count - 1)/2) * pitch;
        translate([-slot_len/2, y - slot_w/2, block_h - slot_depth])
            cube([slot_len, slot_w, slot_depth + eps]);
    }
}