$fn = 64;

// Block dimensions (mm)
block_length = 90;   // X
block_width  = 45;  // Y
block_height = 20;  // Z

// Slot dimensions (mm)
slot_length  = 77;   // X
slot_width   = 1.6;  // Y
slot_depth   = 10;   // Z
slot_spacing = 3.5; // centre‑to‑centre Y
slot_count   = 10;

// Offsets to centre the slot group
offset_x = (block_length - slot_length)/2;
total_slots_width = slot_count*slot_width + (slot_count-1)*(slot_spacing - slot_width);
offset_y = (block_width - total_slots_width)/2;

// Base block
base_block = cube([block_length, block_width, block_height]);

// Slots
slots = union() {
    for (i = 0; i < slot_count; i++) {
        y = offset_y + slot_width/2 + i*slot_spacing;
        translate([offset_x, y, block_height - slot_depth - 0.01]) {
            cube([slot_length, slot_width, slot_depth]);
        }
    }
}; // <‑‑ semicolon added

// Final rack
difference() {
    base_block;
    slots;
}