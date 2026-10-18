// Microscope slide drying rack
// Print orientation: base block on XY plane, slots open upward (+Z)

// ---------------- Parameters ----------------
block_len    = 90;    // block length along X (mm)
block_wid    = 45;    // block width along Y (mm)
block_h      = 20;    // block height along Z (mm)

slot_count   = 10;    // number of slide slots
slot_len     = 77;    // slot length along X (mm)
slot_w       = 1.6;   // slot width along Y (mm)
slot_depth   = 10;    // slot depth from top face (mm)
slot_pitch   = 3.5;   // centre-to-centre slot spacing along Y (mm)

eps          = 0.5;   // overcut past faces to avoid coplanar surfaces (mm)

$fn = 64;

// ---------------- Derived ----------------
slot_group_wid  = (slot_count - 1) * slot_pitch;   // span of slots in Y
slot_y_start    = -slot_group_wid / 2;             // first slot centre Y

// ---------------- Model ----------------
difference() {
    // Solid base block, centred in X and Y, resting on z = 0
    translate([-block_len / 2, -block_wid / 2, 0])
        cube([block_len, block_wid, block_h]);

    // Parallel slots running along X, open at the top
    for (i = [0 : slot_count - 1]) {
        translate([0, slot_y_start + i * slot_pitch, block_h - slot_depth])
            cube([slot_len, slot_w, slot_depth + eps]);
    }
}