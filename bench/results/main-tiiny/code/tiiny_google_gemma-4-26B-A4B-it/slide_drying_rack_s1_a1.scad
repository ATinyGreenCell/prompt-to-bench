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

// The user requested the part to rest on the XY plane at Z = 0.
// In the previous version, the center-based cube logic caused the 
// bottom to be at Z = -10. We must translate the object so the 
// bottom face (Z_min) is at Z = 0.

module drying_rack() {
    difference() {
        // Main block body
        // We create the cube starting from Z=0 to avoid negative Z coordinates.
        cube([block_length, block_width, block_height]);

        // Generate the slots
        for (i = [0 : slot_count - 1]) {
            // Calculate Y position for the center of the current slot
            // The group of slots is centered on the block in Y.
            // Total span of centers is (slot_count - 1) * slot_spacing.
            y_offset = (i * slot_spacing) - ((slot_count - 1) * slot_spacing / 2);
            
            // The slots are centered on the block in X.
            // The block is 90mm long, slot is 77mm. 
            // X-offset = (90 - 77) / 2 = 6.5
            x_offset = (block_length - slot_length) / 2;
            
            // The slots are cut into the top face.
            // Top face is at Z = block_height.
            // We cut from Z = block_height down to Z = block_height - slot_depth.
            // To ensure a clean cut, we extend the cutting shape slightly.
            translate([x_offset, y_offset, block_height - slot_depth + 0.01]) {
                cube([slot_length, slot_width, slot_depth + 0.01]);
            }
        }
    }
}

// Final assembly:
// To center the part on the origin in X and Y:
// X_offset = -block_length / 2
// Y_offset = -block_width / 2
// Z_offset = 0 (since the cube starts at 0)

translate([-block_length/2, -block_width/2, 0]) {
    drying_rack();
}