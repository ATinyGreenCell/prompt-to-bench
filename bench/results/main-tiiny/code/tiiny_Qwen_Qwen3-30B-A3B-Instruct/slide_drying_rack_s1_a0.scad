// Dimensions for the drying rack
$fn = 64; // Smooth curves

// Base block dimensions
base_length = 90;   // X direction
base_width = 45;    // Y direction
base_height = 20;     // Z direction

// Slot dimensions
slot_length = 77;     // Along X
slot_width = 1.6;     // Y direction (width of slot)
slot_depth = 10;      // Z direction (depth into top face)

// Spacing between slots (center-to-center in Y)
slot_spacing = 3.5;

// Number of slots
num_slots = 10;

// Calculate total width occupied by slots (center-to-center)
total_slot_width = (num_slots - 1) * slot_spacing + slot_width;

// Centering offset for slots in Y
y_offset = (base_width - total_slot_width) / 2;

// Centering offset for slots in X
x_offset = (base_length - slot_length) / 2;

// Create the base block
cube(size = [base_length, base_width, base_height], center = true);

// Cut the slots using difference
difference() {
    // Keep the base block
    cube(size = [base_length, base_width, base_height], center = true);

    // For each slot, create a rectangular prism to cut out
    for (i = [0 : num_slots - 1]) {
        // Calculate Y position of this slot (center-to-center spacing)
        y_pos = y_offset + i * slot_spacing;

        // Create a rectangular prism for the slot
        // Extend slightly beyond the top face to ensure clean cut
        translate([0, y_pos, base_height - slot_depth - 0.01]) {
            cube(size = [slot_length, slot_width + 0.02, slot_depth + 0.02], center = false);
        }
    }
}