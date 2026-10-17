// Drying rack for 10 microscope slides
// Print orientation: base on XY plane, slots open upward (+Z)

// ---------- Block ----------
block_l = 90;    // block length (X)
block_w = 45;    // block width (Y)
block_h = 20;    // block height (Z)

// ---------- Slots ----------
n_slots     = 10;     // number of slots
slot_len    = 77;     // slot length (X)
slot_w      = 1.6;    // slot width (Y)
slot_depth  = 10;     // slot depth from top face (Z)
slot_pitch  = 3.5;    // centre-to-centre spacing in (Y)

// ---------- Misc ----------
eps = 0.5;            // overshoot for clean boolean cuts
$fn = 64;             // curve resolution

// Derived
total_slot_w = n_slots * slot_w + (n_slots - 1) * slot_pitch;   // 32.5 mm
block_y0 = -block_w / 2;                                         // block bottom edge (Y)
slot_y0  = block_y0 + (block_w - total_slot_w) / 2;             // first slot centre (Y)

difference() {
    // Solid block, centred in X
    translate([-block_l / 2, block_y0, 0])
        cube([block_l, block_w, block_h]);

    // 10 parallel slots along X, open at top
    for (i = [0 : n_slots - 1])
        translate([-block_l / 2, slot_y0 + i * slot_pitch, block_h - slot_depth])
            cube([slot_len, slot_w, slot_depth + eps]);
}