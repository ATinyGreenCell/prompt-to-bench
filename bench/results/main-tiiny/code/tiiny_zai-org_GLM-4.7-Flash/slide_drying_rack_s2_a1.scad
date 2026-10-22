// Dimensions in millimetres
block_length = 90;      // X dimension
block_width = 45;       // Y dimension
block_height = 20;      // Z dimension

slide_length = 75;      // Length of the slide
slide_width = 25;       // Width of the slide
slide_thickness = 1;    // Thickness of the slide

slot_length = 77;       // Length of the slot (slightly shorter than block to allow for walls)
slot_width = 1.6;       // Width of the slot
slot_depth = 10;        // Depth of the slot (how deep the cut is)
slot_spacing = 3.5;     // Centre-to-centre distance between slots

// Derived dimensions
// Calculate the number of slots that fit within the block width
// We use a for loop to determine the exact count based on spacing
num_slots = 0;
for (i = [0 : 1]) {
    if ((i * slot_spacing) + (slot_width / 2) < (block_width / 2)) {
        num_slots = i + 1;
    }
}

// Calculate the total width occupied by the slots
total_slot_width = (num_slots * slot_width) + ((num_slots - 1) * slot_spacing);

// Calculate the offset to center the group of slots
slot_offset = (block_width - total_slot_width) / 2;

$fn = 64;

module base_block() {
    cube([block_length, block_width, block_height], center=true);
}

module slot_cutout() {
    // The slot is a rectangular prism cut into the top face
    // We extend it slightly past the block faces to ensure clean cuts
    // We translate by block_width/2 to ensure the cutout is relative to the block's center
    translate([0, block_width/2, block_height - slot_depth - 0.1])
    cube([slot_length + 0.1, slot_width + 0.1, slot_depth + 0.1], center=true);
}

module drying_rack() {
    difference() {
        base_block();
        
        // Create the slots
        for (i = [0 : num_slots - 1]) {
            // Calculate Y position for each slot
            y_pos = (i * slot_spacing) + (slot_width / 2);
            
            translate([0, y_pos, 0])
            slot_cutout();
        }
    }
}

// Render the part
drying_rack();