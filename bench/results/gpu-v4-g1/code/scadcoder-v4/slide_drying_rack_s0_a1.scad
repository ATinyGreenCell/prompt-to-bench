// Slide drying rack - holds 10 microscope slides (75 x 25 x 1 mm) upright on their long edge
// Print orientation: base block on the bed (z = 0), slots open upward (+Z)

// ---------------- Parameters ----------------
block_len    = 90;    // block length along X (mm)
block_wid    = 45;    // block width along Y (mm)
block_hgt    = 20;    // block height along Z (mm)

slot_len     = 77;    // slot length along X (mm)
slot_wid     = 1.6;   // slot width along Y (mm)
slot_depth   = 10;    // slot depth from top face (mm)
slot_pitch   = 3.5;   // centre-to-centre spacing of slots in Y (mm)
slot_count   = 10;    // number of slots

eps          = 0.5;   // overshoot of cutters past the top face (mm)
$fn          = 96;    // circle resolution (no curves here, set per the rules)

// ---------------- Derived ----------------
first_y = -(slot_count - 1) * slot_pitch / 2;   // Y of first slot, groups centred in Y
x_margin = (block_len - slot_len) / 2;          // X margin of slot in the block (11.5 mm)

// ---------------- Model ----------------
difference() {
    // Base block, centred in X and Y, sitting on z = 0
    translate([-block_len / 2, -block_wid / 2, 0])
        cube([block_len, block_wid, block_hgt]);

    // Parallel slots, open at the top
    for (i = [0 : slot_count - 1]) {
        translate([x_margin - eps, first_y + i * slot_pitch, block_hgt - slot_depth])
            cube([slot_len + 2 * eps, slot_wid, slot_depth + eps]);
    }
}