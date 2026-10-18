// Microscope slide drying rack
// Print orientation: base on bed (z = 0), slots open upward (+Z)

// ---------------- Parameters ----------------
block_len    = 90;    // base block length (X)
block_wid    = 45;    // base block width (Y)
block_h      = 20;    // base block height (Z)

slot_count   = 10;    // number of slide slots
slot_len     = 77;    // slot length along X
slot_w       = 1.6;   // slot width along Y
slot_depth   = 10;    // slot depth from top face (Z)
slot_pitch   = 3.5;   // centre-to-centre slot spacing (Y)

eps          = 0.5;   // cutter overshoot past top face
$fn          = 64;    // curve resolution

// ---------------- Derived ----------------
slot_x0 = -slot_len/2;                    // first slot start (X)
y_mult  = [(i - (slot_count - 1)/2) * slot_pitch for i in [range(slot_count)]]; // slot centres (Y)

// ---------------- Model ----------------
difference() {
    // Base block, centred in X/Y, resting on z = 0
    translate([-block_len/2, -block_wid/2, 0])
        cube([block_len, block_wid, block_h]);

    // Parallel slots cut into the top face
    for (y = y_mult)
        translate([slot_x0, y - slot_w/2, block_h - slot_depth])
            cube([slot_len, slot_w, slot_depth + eps]);
}