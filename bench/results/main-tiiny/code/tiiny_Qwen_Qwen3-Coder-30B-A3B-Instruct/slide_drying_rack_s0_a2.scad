// Dimensions
block_length = 90;     // mm, X axis
block_width = 45;      // mm, Y axis
block_height = 20;     // mm, Z axis

slot_count = 10;
slot_length = 77;      // mm, X axis
slot_width = 1.6;      // mm, Y axis
slot_depth = 10;       // mm, Z axis
slot_spacing = 3.5;    // mm, center-to-center in Y

// Main block
base = cube([block_length, block_width, block_height], center=true);

// Slots
slots = [];
for (i = [0 : slot_count - 1]) {
    slot_x_offset = (slot_count - 1) * slot_spacing / 2 - i * slot_spacing;
    slot = translate([slot_x_offset, 0, block_height/2]) 
           cube([slot_length, slot_width, slot_depth + 1], center=true);
    slots = [slots, slot];
}

// Combine base and slots
difference() {
    base;
    union() {
        for (slot = slots) {
            slot;
        }
    }
}