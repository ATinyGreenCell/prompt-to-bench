$fn = 64;

// Dimensions (mm)
block_x = 90;
block_y = 45;
block_z = 20;
slot_length = 77;
slot_width = 1.6;
slot_depth = 10;
slot_spacing = 3.5;
num_slots = 10;

// Calculations for centering the slots
total_slot_width = num_slots * slot_spacing;
first_slot_y = (block_y / 2) - (total_slot_width / 2);

module rack() {
    difference() {
        // Base Block
        cube([block_x, block_y, block_z], center=false);

        // Slots
        for (i = [0 : num_slots - 1]) {
            // Calculate Y position for this slot
            current_y = first_slot_y + (i * slot_spacing);

            // The cutting shape (void)
            // We extend the depth by 0.1mm to ensure it cuts past the top face
            // as per the "extend past faces" rule
            void_depth = slot_depth + 0.1;
            
            translate([0, current_y, block_z - void_depth])
                cube([slot_length, slot_width, void_depth], center=false);
        }
    }
}

rack();