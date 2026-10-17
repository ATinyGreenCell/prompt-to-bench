// Drying rack for 10 microscope slides
// Print orientation: base on XY plane, slots open at top (+Z)

$fn = 64;

// ---- Block dimensions ----
block_x = 90;        // block length (X)
block_y = 45;        // block width (Y)
block_z = 20;        // block height (Z)

// ---- Slot dimensions ----
slot_n     = 10;     // number of slots
slot_len   = 77;     // slot length (X)
slot_w     = 1.6;    // slot width (Y)
slot_depth = 10;     // slot depth from top face (Z)

// ---- Layout ----
slot_pitch = 3.5;    // centre-to-centre spacing in Y
group_y    = 0;      // Y position of the slot group (will be centred)

// ---- Cutting overlap ----
eps = 0.5;           // extension past top face to avoid coplanar faces

// Y position of first slot so the group is centred on the block
first_y = group_y - (slot_n - 1) * slot_pitch / 2;

difference() {
    // Solid base block, centred in X and Y, resting on z = 0
    translate([-block_x / 2, -block_y / 2, 0])
        cube([block_x, block_y, block_z]);

    // 10 parallel slots along X, open at top
    for (i = [0 : slot_n - 1])
        translate([-slot_len / 2, first_y + i * slot_pitch, block_z - slot_depth])
            translate([0, 0, -eps])
                cube([slot_len, slot_w, slot_depth + eps]);
}