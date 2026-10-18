// Slide drying rack - holds 10 microscope slides standing on their long edge
// Units: mm. Print orientation: base on XY plane, slots open upward (+Z).

// ---------------- Parameters ----------------
block_len    = 90;    // block length along X
block_wid    = 45;    // block width along Y
block_ht     = 20;    // block height along Z

slot_count   = 10;    // number of slide slots
slot_len     = 77;    // slot length along X (slide + clearance)
slot_wid     = 1.6;   // slot width along Y
slot_depth   = 10;    // slot depth from top face (along -Z)
slot_pitch   = 3.5;   // centre-to-centre slot spacing along Y

eps          = 0.5;   // overshoot so cutters pass the top face cleanly

$fn = 64;

// ---------------- Derived ----------------
first_y = -(slot_count - 1) * slot_pitch / 2;  // y of first slot (group centred)

// ---------------- Model ----------------
difference() {
    // Main block, centred in X/Y, resting on z = 0
    translate([-block_len / 2, -block_wid / 2, 0])
        cube([block_len, block_wid, block_ht]);

    // Parallel slots running along X, open at the top
    for (i = [0 : slot_count - 1]) {
        translate([0, first_y + i * slot_pitch, block_ht - slot_depth])
            cube([slot_len, slot_wid, slot_depth + eps]);
    }
}