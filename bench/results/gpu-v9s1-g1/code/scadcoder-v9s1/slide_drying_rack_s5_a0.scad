// Slide drying rack
// Print orientation: base block on XY plane, slots open upward (+Z)

// ---------- Parameters ----------
block_len    = 90;    // block length along X (mm)
block_wid    = 45;    // block width along Y (mm)
block_ht     = 20;    // block height along Z (mm)

slot_count   = 10;    // number of slide slots
slot_len     = 77;    // slot length along X (mm)
slot_wid     = 1.6;   // slot width along Y (mm)
slot_depth   = 10;    // slot depth from top face (mm)
slot_pitch   = 3.5;   // centre-to-centre slot spacing along Y (mm)

eps          = 0.5;   // overcut past faces to avoid coplanar surfaces (mm)

$fn = 64;

// ---------- Derived ----------
slot_x0 = -(slot_len - block_len) / 2;              // first slot start X
slot_y0 = -(slot_count - 1) * slot_pitch / 2;       // first slot centre Y

// ---------- Model ----------
difference() {
    // Base block
    translate([-block_len / 2, -block_wid / 2, 0])
        cube([block_len, block_wid, block_ht]);

    // Parallel slots along X, centred on block in X and Y
    for (i = [0 : slot_count - 1]) {
        translate([slot_x0, slot_y0 + i * slot_pitch, block_ht - slot_depth])
            cube([slot_len, slot_wid, slot_depth + eps]);
    }
}