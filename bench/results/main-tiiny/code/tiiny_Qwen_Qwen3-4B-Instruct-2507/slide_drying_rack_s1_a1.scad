// Dimensions in millimetres
$fn = 64;

// Base block dimensions
base_length = 90;        // X dimension
base_width = 45;         // Y dimension
base_height = 20;        // Z dimension

// Slot specifications
slot_count = 10;
slot_length = 77;        // along X
slot_width = 1.6;        // along Y
slot_depth = 10;         // along Z
slot_center_spacing = 3.5; // centre-to-centre in Y

// Calculate slot positions in Y (centered on the base)
slot_y_positions = [];
for (i = [0 : slot_count - 1]) {
    slot_y_positions.push_back(base_width / 2 - slot_center_spacing * i - slot_width / 2);
}

// Create the base block
base = cube([base_length, base_width, base_height]);

// Generate slots on the top face (cut from the top, going down)
// We use difference to subtract each slot from the base
// Each slot is a rectangular prism extending from the top face down
final_rack = base;

// Loop to cut each slot
for (i = [0 : slot_count - 1]) {
    y_offset = base_width / 2 - slot_center_spacing * i - slot_width / 2;
    // Slot is centered in X (symmetric about X=base_length/2)
    // Cut from the top face down, with a small extension to avoid coplanar faces
    slot = cube([slot_length, slot_width, slot_depth + 0.1]);
    final_rack = difference() {
        final_rack;
        translate([base_length / 2 - slot_length / 2, y_offset, base_height - slot_depth - 0.1])
            slot;
    };
}

// Final result
final_rack;