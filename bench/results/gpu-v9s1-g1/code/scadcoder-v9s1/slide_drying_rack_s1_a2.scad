// Slide drying rack
// Print orientation: base on XY plane, slots open upward (+Z)

// ---------- Block ----------
block_l = 90;    // block length along X (mm)
block_w = 45;    // block width along Y (mm)
block_h = 20;    // block height along Z (mm)

// ---------- Slots ----------
slot_n     = 10;   // number of slide slots
slot_len   = 77;   // slot length along X (mm)
slot_w     = 1.6;  // slot width along Y (mm)
slot_depth = 10;   // slot depth into block (mm)
slot_pitch = 3.5;  // centre-to-centre spacing along Y (mm)

// ---------- Misc ----------
eps = 0.5;       // overcut past faces to avoid coplanar faces
$fn = 64;       // curve resolution (no curves used, kept per convention)

// X position of first slot centre (group centred on block)
slot_x0 = -(slot_n * slot_pitch - slot_len) / 2;

difference() {
    // Base block
    translate([-block_l / 2, -block_w / 2, 0])
        cube([block_l, block_w, block_h]);

    // Parallel slots open at the top
    for (i = [0 : slot_n - 1]) {
        translate([slot_x0 + i * slot_pitch - slot_len / 2,
                   -slot_w / 2,
                   block_h - slot_depth])
            cube([slot_len, slot_w, slot_depth + eps]);
    }
}