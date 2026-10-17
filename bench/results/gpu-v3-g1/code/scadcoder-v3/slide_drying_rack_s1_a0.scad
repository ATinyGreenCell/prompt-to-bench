// Drying rack for 10 microscope slides, standing upright on their long edge
// Print orientation: base block rests on XY plane, slots open at top (+Z)

$fn = 64;

// ---- Block dimensions ----
block_x = 90;        // block length (X)
block_y = 45;        // block width (Y)
block_z = 20;        // block height (Z)

// ---- Slot dimensions ----
slot_n     = 10;     // number of slots
slot_len   = 77;     // slot length along X
slot_w     = 1.6;    // slot width along Y
slot_depth = 10;     // slot depth from top face

// ---- Slot spacing ----
slot_pitch = 3.5;    // centre-to-centre spacing (Y)

// ---- Cut clearance ----
eps = 0.5;           // overshoot past top face

// Slot group width
group_w = slot_n * slot_pitch;

// Position the group so it is centred on the block in X and Y
group_x0 = block_x / 2 - slot_len / 2;
group_y0 = block_y / 2 - group_w / 2;

difference() {
    // Solid base block, centred in X/Y, sitting on z = 0
    translate([-block_x / 2, -block_y / 2, 0])
        cube([block_x, block_y, block_z]);

    // 10 parallel slots, open at top
    for (i = [0 : slot_n - 1])
        translate([group_x0, group_y0 + i * slot_pitch, block_z - eps])
            cube([slot_len, slot_w, slot_depth + eps]);
}