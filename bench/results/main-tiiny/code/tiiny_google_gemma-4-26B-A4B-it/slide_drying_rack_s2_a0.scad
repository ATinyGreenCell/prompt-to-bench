// --- Dimensions (mm) ---
block_length = 90.0;      // X dimension of the base block
block_width = 45.0;       // Y dimension of the base block
block_height = 20.0;      // Z dimension of the base block

slide_length = 75.0;      // Length of the slide (for reference)
slot_length = 77.0;       // Length of the slot along X
slot_width = 1.6;         // Width of the slot along Y
slot_depth = 10.0;        // Depth of the slot along Z

num_slots = 10;           // Number of slots
slot_spacing = 3.5;       // Center-to-center distance between slots in Y

// --- Resolution ---
$fn = 64;

// --- Implementation ---

// The part is centered on X and Y, resting on Z=0
module drying_rack() {
    difference() {
        // The main base block
        cube([block_length, block_width, block_height], center = true);

        // The slots
        // We calculate the starting Y position to ensure the group is centered.
        // Total span of centers = (num_slots - 1) * slot_spacing
        // We subtract half the width of one slot to find the edge of the first slot center.
        // However, to center the group, we calculate the total width occupied by the slots.
        
        let (
            total_span = (num_slots - 1) * slot_spacing,
            start_y = -total_span / 2
        )
        for (i = [0 : num_slots - 1]) {
            translate([0, start_y + (i * slot_spacing), block_height/2 - slot_depth/2 + 0.01])
            cube([slot_length, slot_width, slot_depth + 0.02], center = true);
        }
    }
}

// Render the part
// Note: The cube is centered, so we translate it to sit on Z=0
translate([0, 0, block_height/2])
drying_rack();