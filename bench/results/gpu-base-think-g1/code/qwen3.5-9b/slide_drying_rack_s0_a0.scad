$fn = 64; // Good practice, though mostly rectangular

    // Dimensions
    block_x = 90;
    block_y = 45;
    block_z = 20;
    slot_count = 10;
    slot_len = 77;
    slot_w = 1.6;
    slot_depth = 10;
    slot_spacing = 3.5;

    // Calculations
    block_x_half = block_x / 2;
    block_y_half = block_y / 2;
    block_z_half = block_z / 2;

    // Slot Group Centering
    // Total span from center of first slot to center of last slot
    total_center_span = (slot_count - 1) * slot_spacing;
    first_slot_center_y = -total_center_span / 2;

    // Main Block
    difference() {
        translate([0, 0, 0])
            cube([block_x, block_y, block_z]);

        // Slots
        for (i = [0 : slot_count - 1]) {
            y_pos = first_slot_center_y + i * slot_spacing;
            // Cutters extend 0.1mm past top face (Z=20)
            translate([0, y_pos, block_z - slot_depth])
                cube([slot_len, slot_w, slot_depth + 0.1]);
        }
    }