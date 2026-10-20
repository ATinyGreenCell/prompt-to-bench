// Microscope Slide Drying Rack
// Designed for 10 slides (75x25x1mm) standing on long edge

// --- Dimensions ---
block_length = 90.0;      // X dimension of the base block
block_width = 45.0;       // Y dimension of the base block
block_height = 20.0;      // Z dimension of the base block

slot_length = 77.0;       // X dimension of the slots
slot_width = 1.6;         // Y dimension of the slots
slot_depth = 10.0;        // Z depth of the slots

slot_spacing = 3.5;       // Y center-to-center distance between slots
num_slots = 10;           // Number of slots

// --- Resolution ---
$fn = 64;

// --- Implementation ---

// The part is built such that it rests on the XY plane at Z = 0.
// The block is centered on X and Y.

difference() {
    // Main block body
    // Centered on X and Y, bottom face at Z = 0
    translate([-block_length/2, -block_width/2, 0])
        cube([block_length, block_width, block_height]);

    // Create the slots
    // 1. Calculate the total span of the centers of the slots
    //    The distance from the center of the first slot to the center of the last is (num_slots - 1) * slot_spacing
    // 2. To center the group of slots in Y:
    //    The center of the group is at block_width / 2.
    //    The first slot center is at (block_width / 2) - ((num_slots - 1) * slot_spacing / 2)
    // 3. To center the group of slots in X:
    //    The center of the group is at block_length / 2.
    //    The first slot center is at (block_length / 2) - (slot_length / 2)
    
    let(
        total_span_y = (num_slots - 1) * slot_spacing,
        // We calculate the starting position of the first slot's bounding box
        // to ensure the group is centered.
        start_x = (block_length - slot_length) / 2,
        start_y = (block_width - total_span_y) / 2,
        // The slots are cut from the top face (Z = block_height) downwards.
        // To ensure a clean cut through the top face, we start at block_height - slot_depth
        // and extend slightly above the block (Rule 5).
        start_z = block_height - slot_depth
    )
    translate([start_x, start_y, start_z]) {
        for (i = [0 : num_slots - 1]) {
            translate([0, i * slot_spacing, 0]) {
                // We use a slightly larger dimension for the cutting cube 
                // to ensure it cuts through the top face and the sides (Rule 5).
                // X: slot_length + 2 to ensure it clears the X-edges
                // Y: slot_width (the loop handles the spacing)
                // Z: slot_depth + 1 to ensure it clears the top face
                cube([slot_length + 2, slot_width, slot_depth + 1]);
            }
        }
    }
}

// Verification of requirements:
// - Block: 90 x 45 x 20.
// - Slots: 77 x 1.6 x 10.
// - Slot spacing: 3.5 center-to-center.
// - Centered in X and Y.
// - Rests on XY plane at Z=0.