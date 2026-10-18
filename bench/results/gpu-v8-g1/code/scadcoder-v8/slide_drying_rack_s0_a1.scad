// Microscope slide drying rack
// Print orientation: base block on XY plane, slots open upward (+Z)

// ---------------- Parameters ----------------
block_len    = 90;    // base block length (X)
block_wid    = 45;    // base block width (Y)
block_h      = 20;    // base block height (Z)

slot_count   = 10;    // number of slide slots
slot_len     = 77;    // slot length along X
slot_w       = 1.6;   // slot width along Y
slot_depth   = 10;    // slot depth from top face
slot_pitch   = 3.5;   // centre-to-centre spacing in Y

eps          = 0.5;   // overshoot for clean boolean cuts
$fn          = 64;    // curve resolution (no curved features, set per rules)

// ---------------- Derived ----------------
slot_x0 = -slot_len / 2;          // slot start X
slot_y0 = -(slot_count - 1) * slot_pitch / 2;  // first slot Y (group centred)

// ---------------- Model ----------------
difference() {
    // Base block
    translate([-block_len / 2, -block_wid / 2, 0])
        cube([block_len, block_wid, block_h]);

    // Parallel slots, open at top
    for (i = [0 : slot_count - 1])
        translate([slot_x0, slot_y0 + i * slot_pitch, block_h - slot_depth])
            cube([slot_len, slot_w, slot_depth + eps]);
}