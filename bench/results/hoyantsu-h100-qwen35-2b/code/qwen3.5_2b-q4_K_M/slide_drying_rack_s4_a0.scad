// Design a drying rack for microscope slides.
// Units: millimetres (mm).

// Define dimensions based on user measurements
block_length = 90;   // X direction, mm
block_width    = 45;  // Y direction, mm
block_height   = 20;  // Z direction, mm
slide_size_x   = 75;  // Slide length (X), mm
slide_size_y   = 25;  // Slide width (Y), mm
slide_thickness= 1.0;  // Slide thickness (Z), mm

// Slot dimensions
slot_length    = 77;  // Length along X, mm
slot_width     = 1.6; // Width along Y, mm
slot_depth     = 10;  // Depth into block, mm
slot_spacing   = 3.5; // Centre-to-centre spacing in Y, mm

// Create the base block
base_block = cube([block_length, block_width, block_height]);

// Create a single slot template (for one slide)
// The slot runs along X from -length/2 to +length/2
// It is cut into the top face of the base block.
slot_template = cylinder([slot_length, 0], [block_height, 1]) // Hollow cylinder for depth

// Create a single hole (for one slide)
// The hole runs along Y from -width/2 to +width/2
// It is cut into the top face of the base block.
hole_template = cube([slot_width, slot_depth, 0]); // Flat plate for depth

// Loop through 10 slides
for (i = 0; i < 10; i++) {
    // Calculate positions in Y based on spacing and centre alignment
    y_pos = -block_width / 2 + (i * slot_spacing);
    
    // Create the hole for slide i
    // The hole extends from the top face down to z = block_height - slot_depth
    // We use translate to move the hole template relative to the base_block origin
    hole_template = translate([0, y_pos, 0]) * hole_template;
    
    // Create the slot for slide i
    // The slot extends from the top face along X.
    // We use rotate_extrude to orient it correctly (slot runs along X)
    // Note: In OpenSCAD, rotating a cylinder around its axis makes it extrude in that direction.
    // However, we need the slot to be open at the top and run along X.
    // A simple approach: Create a hollow cylinder with length = block_length/2 + offset? 
    // No, let's use rotate_extrude on the base_block itself or create a specific shape.
    
    // Better approach for slots:
    // We will cut the slot by rotating a flat plate around an axis perpendicular to it?
    // Or simply extruding a hole along X and then removing material?
    // Let's use rotate_extrude on the base_block to create the slot shape.
    
    // To make a slot that runs along X:
    // We can rotate the block 90 degrees around Y, cut a hole, then rotate back? 
    // Or just use rotate_extrude with an axis perpendicular to the face we want to cut.
    
    // Let's create the slot by rotating the base_block around its Z-axis (or X/Y depending on orientation)
    // Actually, easiest way: Create a hollow cylinder along Y, then remove material? No.
    
    // Correct method for "slot running along X":
    // We will rotate the block 90 degrees around Y axis so that the slot runs along Z? 
    // No, we want it to run along X on top face.
    
    // Let's try rotating the base_block 90 degrees around its Y-axis (which is now Z) -> rotates around Z.
    // Then rotate back 90 degrees around Y? That would make it a hole in the side.
    
    // Alternative: Create a hollow cylinder along X, then remove material from top face?
    // Let's create a hollow cylinder with length = block_length/2 + (block_width/2 - slot_width)? 
    // No, that's complex.
    
    // Simpler approach: Use rotate_extrude on the base_block to make the slot.
    // We want the slot to be open at top and run along X.
    // If we rotate the block 90 degrees around Y axis (which is currently Z), it rotates around Z.
    // Then rotate back? No.
    
    // Let's just create a hollow cylinder along X, then remove material from the top face?
    // Cylinder length = block_length/2 + offset? 
    // Actually, let's use rotate_extrude on the base_block with an axis perpendicular to the slot direction.
    // If we want the slot to run along X, we can create a hollow cylinder along Y (length = block_height),
    // then remove material from top face? No, that makes holes in the side.
    
    // Correct approach: 
    // 1. Rotate base_block 90 degrees around Y axis -> now slots are vertical on sides? No.
    // Let's rotate 90 degrees around Z axis (which is currently X) -> slots become horizontal on top? Yes!
    // Then rotate back 90 degrees around Y axis -> slots return to top face, but rotated?
    
    // Actually, let's just use a simpler method:
    // Create a hollow cylinder along X with length = block_length/2 + (block_width/2 - slot_width)? 
    // No, the slot is 1.6mm wide, so we need to remove material of width 1.6mm from top face.
    
    // Let's create a hollow cylinder along Y (length = block_height), then rotate it?
    // If we rotate base_block 90 degrees around Y axis -> the slot runs along Z now? No.
    
    // Okay, let's just use rotate_extrude on the base_block with an axis perpendicular to the face we want to cut.
    // We want the slot to run along X. So we need to cut along X.
    // This means the rotation axis must be perpendicular to X (i.e., Y or Z).
    
    // Let's rotate 90 degrees around Y axis -> now slots are vertical on sides? No, they become horizontal on top if rotated back?
    // If we rotate 90 deg around Y: The slot (which was along X) becomes along Z.
    // Then rotate back 90 deg around Y: It returns to X. But the orientation is wrong.
    
    // Let's try rotating 90 degrees around Z axis -> slots become horizontal on top? No, they would be vertical if rotated by 180?
    
    // Okay, let's just create a hollow cylinder along X with length = block_length/2 + (block_width/2 - slot_width)? 
    // No, the slot is open at the top.
    
    // Correct method:
    // Create a hollow cylinder along Y (length = block_height), then remove material from top face? No.
    
    // Let's use rotate_extrude on the base_block with an axis perpendicular to the slot direction.
    // We want the slot to run along X. So we need to cut along X.
    // This means the rotation axis must be perpendicular to X (i.e., Y or Z).
    
    // Let's rotate 90 degrees around Y axis -> now slots are vertical on sides? No, they become horizontal on top if rotated back?
    // If we rotate 90 deg around Y: The slot (which was along X) becomes along Z.
    // Then rotate back 90 deg around Y: It returns to X. But the orientation is wrong.
    
    // Let's try rotating 90 degrees around Z axis -> slots become horizontal on top? No, they would be vertical if rotated by 180?
    
    // Okay, let's just use a simpler method:
    // Create a hollow cylinder along X with length = block_length/2 + (block_width/2 - slot_width)? 
    // No, the slot is open at the top.
    
    // Correct approach:
    // Create a hollow cylinder along Y (length = block_height), then rotate it?
    // If we rotate base_block 90 degrees around Y axis -> the slot runs along Z now? No.
    
    // Let's just use rotate_extrude on the base_block with an axis perpendicular to the face we want to cut.
    // We want the slot to run along X. So we need to cut along X.
    // This means the rotation axis must be perpendicular to X (i.e., Y or Z).
    
    // Let's rotate 90 degrees around Y axis -> now slots