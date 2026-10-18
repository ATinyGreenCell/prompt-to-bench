// Sliding rack for 10 microscope slides, standing on their long edge
// Print orientation: base block rests on XY plane, slots open upward (+Z)

// ---------------- Parameters ----------------
n_slots      = 10;    // number of slide slots
slot_len     = 77;    // slot length along X (mm)
slot_w       = 1.6;   // slot width along Y (mm)
slot_depth   = 10;    // slot depth into block along Z (mm)
slot_pitch   = 3.5;   // centre-to-centre spacing of slots along Y (mm)

block_len    = 90;    // base block length along X (mm)
block_w      = 45;    // base block width along Y (mm)
block_h      = 20;    // base block height along Z (mm)

eps          = 0.5;   // overcut so cutting faces are not coplanar (mm)

// ---------------- Model ----------------
difference() {
    // Base block, centred in X and Y, sitting on z = 0
    translate([-block_len/2, -block_w/2, 0])
        cube([block_len, block_w, block_h]);

    // Row of parallel slots, centred on the block in X and Y
    for (i = [0 : n_slots - 1]) {
        y_c = (i - (n_slots - 1)/2) * slot_pitch;
        translate([-slot_len/2, y_c, block_h - slot_depth])
            cube([slot_len, slot_w, slot_depth + eps]);
    }
}