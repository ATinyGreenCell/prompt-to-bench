// Design a drying rack for microscope slides.
// Dimensions in millimeters (mm).

// Define dimensions based on user measurements
block_length = 90;   // X dimension: total length of base block
block_width  = 45;   // Y dimension: width of base block
block_height = 20;   // Z dimension: height of base block

// Slide specifications
slide_thickness = 1.0; // mm (height)
slide_length = 75.0;   // mm (long edge, along X)
slide_width    = 25.0;  // mm (short edge, along Y)
slot_depth     = 10.0;  // mm

// Slot specifications
slot_length = 77.0;    // mm (along X)
slot_width  = 1.6;     // mm (Y dimension of slot opening)
slot_spacing = 3.5;    // mm (center-to-center spacing in Y)

fn = 64;               // Number of turns for curved features

// Create the base block
base_block = cube([block_length, block_width, block_height]);

// Create a single slot template using polygonal sides in Y to simulate an open top
// We create a hollow cylinder with polygonal walls centered at X=0.
// The 'height' is set to slide_thickness so it sits flush on the base block's top face (z=1).
// The 'length' is along X.
slot_template = rotate_extrude(
    [slot_length, 0], 
    [-(slot_width / 2), +(slot_width / 2)], // Y extent of the opening
    [slide_thickness, 0]                   // Height of the slot walls (1mm)
);

// Create the group of slots using a loop over Y positions.
// The center of each slot is placed at X = -(slot_length/2).
for (y_pos = -block_width / 2; y_pos < block_width / 2; y_pos += slot_spacing) {
    // Calculate the center X coordinate for this specific slot instance
    slot_center_x = -(slot_length / 2);
    
    // Create a hollow cylinder with polygonal Y-sides.
    // This object has material on its bottom (z=1), vertical sides, and an open top face.
    // The 'height' is the slide thickness (1mm).
    slot_instance = rotate_extrude(
        [slot_length, 0], 
        [y_pos - slot_width / 2, y_pos + slot_width / 2], 
        [slide_thickness, 0]
    );
    
    // Use 'difference' to remove the material of this slot instance from the base block.
    // Since the slot_instance has an open top face (it's a hollow cylinder with polygonal walls),
    // subtracting it removes those walls from the base_block. The resulting surface will expose 
    // the opening in the top face, creating the desired rectangular slot.
    // Note: We use 'difference' here because we are removing material from an existing solid (base_block).
    
    difference = base_block - slot_instance;
}

// Final assembly: Union all parts to ensure they fit together perfectly without gaps at edges
final_rack = union([
    base_block,
    for (y_pos = -block_width / 2; y_pos < block_width / 2; y_pos += slot_spacing) {
        rotate_extrude(
            [slot_length, 0], 
            [y_pos - slot_width / 2, y_pos + slot_width / 2], 
            [slide_thickness, 0]
        )
    }
]);

// Save the file
save("slide_drying_rack_s2_a0.scad", "openscad");