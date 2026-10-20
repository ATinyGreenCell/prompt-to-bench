$fn = 64;

// Dimensions
block_length_x = 90;
block_width_y = 45;
block_height_z = 20;

slot_length_x = 77;
slot_width_y = 1.6;
slot_depth_z = 10;

slot_spacing_y = 3.5;

// Derived Dimensions
// Calculate offset from center to place slots symmetrically
// Total width of slots = (slots - 1) * spacing
// Offset = (Total width / 2) + (Slot width / 2)
num_slots = 10;
total_slot_width = (num_slots - 1) * slot_spacing_y;
slot_offset_y = (total_slot_width / 2) + (slot_width_y / 2);

module base_block() {
    cube([block_length_x, block_width_y, block_height_z], center=true);
}

module slot_cutout() {
    // Translate to the edge of the block in Y
    // We cut from the center, so we move half the block width
    translate([0, block_width_y / 2, 0]) {
        // Cut the slot
        translate([-slot_length_x / 2, -slot_width_y / 2, -slot_depth_z]) {
            cube([slot_length_x, slot_width_y, slot_depth_z + 0.1], center=true);
        }
    }
}

module drying_rack() {
    difference() {
        base_block();
        
        // Create 10 slots centered in X and Y
        for (i = [0 : num_slots - 1]) {
            // Calculate Y position for each slot
            // Center of the block is 0. 
            // Slot i is at i * spacing.
            // We need to account for the offset calculated earlier.
            y_pos = (i * slot_spacing_y) - slot_offset_y;
            
            translate([0, y_pos, 0]) {
                slot_cutout();
            }
        }
    }
}

drying_rack();