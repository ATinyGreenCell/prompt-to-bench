// Drying rack for 10 microscope slides
// Slide dimensions: 75 x 25 x 1 mm (L x W x T)
// Base block: 90 x 45 x 20 mm (X x Y x Z)
// Slots: 10 parallel slots along X, 77 mm long, 1.6 mm wide, 10 mm deep
// Slots spacing: 3.5 mm centre-to-centre in Y
// Slots group centred on block in X and Y

// Base block dimensions
base_length = 90;   // X
base_width  = 45;   // Y
base_height = 20;   // Z

// Slot dimensions
num_slots   = 10;
slot_length = 77;   // along X
slot_width  = 1.6;  // along Y
slot_depth  = 10;   // along Z
slot_pitch  = 3.5;  // centre-to-centre spacing in Y

// Calculate slot positions (centred in Y)
// Total slot group width = num_slots * slot_pitch - (num_slots - 1) * (slot_width - slot_pitch)
// But easier: first slot Y position = (base_width - (num_slots - 1)*slot_pitch - slot_width)/2
first_slot_y = (base_width - (num_slots - 1)*slot_pitch - slot_width) / 2;

// Slot group X-centre (base_length - slot_length)/2
slot_x_offset = (base_length - slot_length) / 2;

// Base block
module base_block() {
    cube([base_length, base_width, base_height]);
}

// Slot module
module slot(x_pos, y_pos) {
    // Slot extends 0.01mm past the block in all directions for clean cutting
    translate([x_pos - 0.01, y_pos - 0.01, base_height - slot_depth - 0.01])
        cube([slot_length + 0.02, slot_width + 0.02, slot_depth + 0.02]);
}

// Build the rack
difference() {
    base_block();
    
    // Cut slots
    for (i = [0 : num_slots - 1]) {
        // Calculate Y position of each slot centre
        slot_y = first_slot_y + i * slot_pitch;
        slot(slot_x_offset, slot_y);
    }
}