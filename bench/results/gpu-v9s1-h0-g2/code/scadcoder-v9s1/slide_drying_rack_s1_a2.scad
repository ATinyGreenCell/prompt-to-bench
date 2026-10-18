// Slide drying rack - solid base with 10 upright slide slots
// Units: mm. Print orientation: base on XY plane, builds +Z.

// ---------- Block ----------
block_l = 90;    // block length (X)
block_w = 45;    // block width (Y)
block_h = 20;    // block height (Z)

// ---------- Slots ----------
slot_count = 10;     // number of slide slots
slot_len   = 77;     // slot length along X
slot_w     = 1.6;    // slot width along Y
slot_depth = 10;     // slot depth into block from top face
slot_pitch = 3.5;    // centre-to-centre spacing along Y
cut_extra  = 0.5;    // overshoot past cut faces to avoid coplanar faces

$fn = 64;

// Slot group centred on block in X and Y
slot_x0 = -(slot_count - 1) * slot_pitch / 2;
slot_y0 = -(slot_count - 1) * slot_pitch / 2;

difference() {
    // Base block
    translate([-block_l / 2, -block_w / 2, 0])
        cube([block_l, block_w, block_h]);

    // Parallel slots, open at the top
    for (i = [0 : slot_count - 1]) {
        translate([slot_x0 + i * slot_pitch - slot_len / 2,
                   slot_y0 + i * slot_pitch - slot_w / 2,
                   block_h - slot_depth])
            cube([slot_len, slot_w, slot_depth + cut_extra]);
    }
}