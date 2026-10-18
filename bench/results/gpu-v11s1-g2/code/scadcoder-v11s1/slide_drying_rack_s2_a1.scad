// Microscope slide drying rack
// Print orientation: base block on XY plane, slots open upward (+Z)

// ---------- Block ----------
block_len   = 90;    // block length along X (mm)
block_wid   = 45;    // block width along Y (mm)
block_ht    = 20;    // block height along Z (mm)

// ---------- Slots ----------
slot_count  = 10;    // number of slide slots
slot_len    = 77;    // slot length along X (mm)
slot_wid    = 1.6;   // slot width along Y (mm)
slot_depth  = 10;    // slot depth into block from top face (mm)
slot_pitch  = 3.5;   // centre-to-centre spacing along Y (mm)

// ---------- Misc ----------
eps         = 0.5;   // cutter overshoot past top face (mm)
$fn         = 64;

// X position of first slot so the slot group is centred on the block
slot_x0     = -(block_len - slot_len) / 2;

difference() {
    // Base block
    translate([-block_len / 2, -block_wid / 2, 0])
        cube([block_len, block_wid, block_ht]);

    // Parallel slots running along X
    for (i = [0 : slot_count - 1]) {
        translate([slot_x0, -slot_wid / 2 + i * slot_pitch, block_ht - slot_depth])
            cube([slot_len, slot_wid, slot_depth + eps]);
    }
}