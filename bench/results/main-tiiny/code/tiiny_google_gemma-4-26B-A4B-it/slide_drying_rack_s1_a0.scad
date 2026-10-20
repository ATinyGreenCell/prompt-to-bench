// --- Dimensions (mm) ---
block_length = 90;      // X dimension of the base block
block_width = 45;       // Y dimension of the base block
block_height = 20;      // Z dimension of the base block

slide_length = 75;      // Length of the slide (X direction)
slide_width = 25;       // Width of the slide (Y direction)
slide_thickness = 1;    // Thickness of the slide (Z direction)

slot_count = 10;         // Number of slots
slot_length = 77;       // Length of the slot (X direction)
slot_width = 1.6;       // Width of the slot (Y direction)
slot_depth = 10;        // Depth of the slot (Z direction)
slot_spacing = 3.5;     // Center-to-center distance between slots (Y direction)

// --- Resolution ---
$fn = 64;

// --- Implementation ---

// The base block
difference() {
    // Main block body
    cube([block_length, block_width, block_height], center = true);

    // Generate the slots
    // We use a loop to create 10 slots.
    // The slots are centered on the block in Y.
    // The total span of the slots is (slot_count - 1) * slot_spacing.
    // We calculate the starting Y position to ensure the group is centered.
    
    for (i = [0 : slot_count - 1]) {
        // Calculate Y position for the center of the current slot
        // Offset is calculated so the group of slots is centered on Y=0
        y_offset = (i * slot_spacing) - ((slot_count - 1) * slot_spacing / 2);
        
        translate([0, y_offset, block_height/2 - slot_depth/2 + 0.01]) {
            cube([slot_length, slot_width, slot_depth + 0.1], center = true);
        }
    }
}

// Note on Orientation:
// The block is centered on the origin (X=0, Y=0, Z=0).
// The bottom face of the block is at Z = -block_height/2.
// To print it resting on the XY plane at Z=0 as requested:
// We translate the whole object up by half the height.

// Re-defining the assembly to follow the "rests on XY plane at Z=0" rule
// We wrap the logic in a module to allow easy translation.

module drying_rack() {
    difference() {
        // Main block body
        cube([block_length, block_width, block_height], center = true);

        // Generate the slots
        for (i = [0 : slot_count - 1]) {
            y_offset = (i * slot_spacing) - ((slot_count - 1) * slot_spacing / 2);
            
            // We translate the slot to the top face. 
            // Top face is at Z = block_height/2.
            // We cut from block_height/2 down to block_height/2 - slot_depth.
            // To ensure a clean cut, we extend the Z slightly.
            translate([0, y_offset, (block_height/2) - (slot_depth/2)]) {
                cube([slot_length, slot_width, slot_depth + 0.1], center = true);
            }
        }
    }
}

// Final assembly positioned at Z=0
translate([0, 0, block_height/2]) {
    drying_rack();
}