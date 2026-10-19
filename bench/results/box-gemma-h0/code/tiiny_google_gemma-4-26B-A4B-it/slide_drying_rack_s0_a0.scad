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

// The base block
difference() {
    // Main block body
    cube([block_length, block_width, block_height], center = true);

    // Create the slots
    // We calculate the starting Y position to center the group of slots
    // Total span of centers = (num_slots - 1) * spacing
    // We subtract half the slot width to find the edge of the first slot
    translate([0, -(num_slots - 1) * slot_spacing / 2, block_height / 2 - slot_depth + 0.01]) {
        for (i = [0 : num_slots - 1]) {
            translate([0, i * slot_spacing, 0]) {
                // Each slot is a cube. 
                // We extend the length slightly in X to ensure a clean cut through the block
                cube([slot_length + 2, slot_width, slot_depth + 0.01], center = true);
            }
        }
    }
}

// Note: The block is centered on the origin. 
// The base of the block is at Z = -block_height/2.
// To make the base sit at Z = 0 as requested:
translate([0, 0, block_height / 2]) {
    // This is a trick to shift the whole object so the bottom face is at Z=0
    // However, the prompt says "rests on the XY plane at z = 0".
    // I will wrap the whole logic in a translation to ensure Z=0 is the bottom.
}

// Corrected assembly to ensure Z=0 is the bottom face
// (Re-writing the logic to be absolute)

module rack_geometry() {
    difference() {
        // Base block
        cube([block_length, block_width, block_height]);

        // Slots
        // Calculate Y offset to center the group of slots
        // The center of the group is at block_width / 2
        // The distance from center of first slot to center of last slot is (num_slots-1)*slot_spacing
        let(total_slot_span = (num_slots - 1) * slot_spacing)
        translate([(block_length - slot_length) / 2, (block_width - total_slot_span) / 2, block_height - slot_depth]) {
            for (i = [0 : num_slots - 1]) {
                translate([0, i * slot_spacing, 0]) {
                    // We use a slightly larger length and width to ensure clean cuts
                    cube([slot_length + 0.1, slot_width, slot_depth + 0.1]);
                }
            }
        }
    }
}

// Final Rendered Object
// Positioned so the bottom face is at Z=0
translate([0, 0, 0]) {
    // Center the block on X and Y
    translate([-block_length/2, -block_width/2, 0]) {
        rack_geometry();
    }
}