// Drying rack for 10 microscope slides
// Slide dimensions: 75 x 25 x 1 mm (L x W x T)
// Base dimensions: 90 x 45 x 20 mm (X x Y x Z)
// Slots: 10 parallel slots along X, 77 mm long, 1.6 mm wide, 10 mm deep
// Slot spacing: 3.5 mm centre-to-centre in Y
// Slots centred on block in X and Y

// Base dimensions
base_length = 90;   // X
base_width  = 45;   // Y
base_height = 20;   // Z

// Slot dimensions
num_slots    = 10;
slot_length  = 77;  // along X
slot_width   = 1.6; // along Y
slot_depth   = 10;  // along Z
slot_pitch   = 3.5; // centre-to-centre spacing in Y

// Calculate slot positions
// Total slot width + gaps: num_slots * slot_width + (num_slots - 1) * slot_pitch
// But we want slots centred, so we compute the total width occupied by slots and gaps
total_slot_width = num_slots * slot_width + (num_slots - 1) * slot_pitch;
// Offset from centre to first slot centre
first_slot_offset = -(total_slot_width - slot_width) / 2;

// Set resolution for curves
$fn = 64;

// Base block
module base_block() {
    cube([base_length, base_width, base_height]);
}

// Slot module
module slot() {
    // Slot runs along X, so extrude along X
    translate([0, 0, 0]) {
        cube([slot_length + 2, slot_width, slot_depth + 0.01]);
    }
}

// Build the rack
module drying_rack() {
    difference() {
        // Base block
        base_block();
        
        // Cut slots
        for (i = [0 : num_slots - 1]) {
            // Calculate Y position of each slot centre
            y_pos = first_slot_offset + i * slot_pitch + slot_width / 2;
            // Position slot: centred in X (base_length/2 - slot_length/2), at y_pos, at top (base_height - slot_depth)
            translate([
                (base_length - slot_length) / 2,
                y_pos - slot_width / 2,  // Adjust for slot width
                base_height - slot_depth
            ]) {
                slot();
            }
        }
    }
}

drying_rack();