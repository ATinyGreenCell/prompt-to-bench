// Drying rack for 10 microscope slides
// Slide dimensions: 75 x 25 x 1 mm (L x W x T)
// Base dimensions: 90 x 45 x 20 mm (X x Y x Z)
// Slots: 10 parallel slots, 77 mm long (X), 1.6 mm wide (Y), 10 mm deep (Z)
// Slot spacing: 3.5 mm centre-to-centre in Y
// Slots centred on block in X and Y

// Base dimensions
base_length = 90;   // X
base_width  = 45;   // Y
base_height = 20;   // Z

// Slot dimensions
num_slots   = 10;
slot_length = 77;   // X
slot_width  = 1.6;  // Y
slot_depth  = 10;   // Z
slot_pitch  = 3.5;  // Y spacing between centres

// Calculate slot positions
// Total slot width + gaps: num_slots * slot_width + (num_slots - 1) * (slot_pitch - slot_width)
// But easier: centre the group in Y
// Group width = num_slots * slot_pitch - (slot_pitch - slot_width)
group_width = num_slots * slot_pitch - (slot_pitch - slot_width);
group_half_width = group_width / 2;

// Slot offset from centre in Y
slot_offset_y = (base_width - group_width) / 2;

// Slot offset from front edge in X (slots are 77 mm long, block is 90 mm long)
slot_offset_x = (base_length - slot_length) / 2;

// Base block
module base_block() {
    cube([base_length, base_width, base_height]);
}

// Slot module
module slot(x_offset, y_offset) {
    // Slot extends 0.01 mm past the block in all directions to ensure clean cutting
    translate([x_offset - 0.01, y_offset - 0.01, base_height - slot_depth - 0.01])
        cube([slot_length + 0.02, slot_width + 0.02, slot_depth + 0.02]);
}

// Build the rack
difference() {
    base_block();
    // Generate slots with for loop
    for (i = [0 : num_slots - 1]) {
        // Calculate Y position of each slot centre
        y_pos = -group_half_width + i * slot_pitch + slot_width/2;
        // Translate slot to position
        slot(slot_offset_x, y_pos);
    }
}

// Set resolution for smooth curves
$fn = 64;