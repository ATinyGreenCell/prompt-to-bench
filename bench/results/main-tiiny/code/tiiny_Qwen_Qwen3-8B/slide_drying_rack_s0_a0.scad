// Dimensions for the drying rack
base_length = 90;       // Length of the base block in X direction
base_width = 45;        // Width of the base block in Y direction
base_height = 20;       // Height of the base block in Z direction

slot_length = 77;       // Length of each slot in X direction
slot_width = 1.6;       // Width of each slot in Y direction
slot_depth = 10;        // Depth of each slot in Z direction
slot_spacing = 3.5;     // Centre-to-centre spacing between slots in Y direction

// Calculate the number of slots that fit in the base_width
num_slots = floor(base_width / slot_spacing);

// Calculate the total width occupied by slots and spacing
total_slot_width = (num_slots * slot_width) + ((num_slots - 1) * slot_spacing);

// Calculate the offset to center the slots in Y
slot_offset_y = (base_width - total_slot_width) / 2;

// Create the base block
base_block = cube([base_length, base_width, base_height], center=true);

// Create the slots using a for loop
slots = [
  for (i = [0 : num_slots - 1])
    translate([0, slot_offset_y + i * slot_spacing + slot_width / 2, 0])
      cube([slot_length, slot_width, slot_depth], center=true)
];

// Combine the base block with the slots using difference
drying_rack = difference() {
  base_block;
  for (slot = slots) {
    slot;
  }
};

// Render the final part
drying_rack;