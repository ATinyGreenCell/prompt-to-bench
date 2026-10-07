// Dimensions
base_length = 90; // X dimension of the base block
base_width = 45; // Y dimension of the base block
base_height = 20; // Z dimension of the base block

slot_length = 77; // Length of each slot
slot_width = 1.6; // Width of each slot (Y dimension)
slot_depth = 10; // Depth of each slot (Z dimension)

slot_spacing = 3.5; // Centre-to-centre spacing between slots in Y

// Base block
base = cube([base_length, base_width, base_height]);

// Slots
slots = for(i = [0:9])
    translate([(i * (slot_length + slot_spacing) - base_length / 2 + slot_length / 2), base_width / 2 - slot_width / 2, 0])
        linear_extrude(height = slot_depth)
            square([slot_length, slot_width], center = true);

// Final model
difference() {
    base;
    slots;
}