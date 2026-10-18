// Microscope slide drying rack
// Print orientation: base block on the bed (z = 0), slots open upward (+Z)

// ---------------- Parameters ----------------
block_len    = 90;    // base block length along X (mm)
block_wid    = 45;    // base block width along Y (mm)
block_ht     = 20;    // base block height along Z (mm)

slot_count   = 10;    // number of slide slots
slot_len     = 77;    // slot length along X (mm)
slot_wid     = 1.6;   // slot width along Y (mm)
slot_depth   = 10;    // slot depth into block from top face (mm)
slot_pitch   = 3.5;   // centre-to-centre slot spacing along Y (mm)

eps          = 0.5;   // overshoot of cutters past the top face (mm)

$fn = 64;

// ---------------- Model ----------------
difference() {
    // Base block, centred in X and Y, sitting on z = 0
    translate([-block_len / 2, -block_wid / 2, 0])
        cube([block_len, block_wid, block_ht]);

    // Parallel slots, centred as a group in X and Y
    for (i = [0 : slot_count - 1]) {
        x = (i - (slot_count - 1) / 2) * slot_pitch;
        translate([x - slot_len / 2, -slot_wid / 2, block_ht - slot_depth])
            cube([slot_len, slot_wid, slot_depth + eps]);
    }
}