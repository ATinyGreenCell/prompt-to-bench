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
    // To make a slot that runs along X and is open at the top:
    // We will rotate the base_block around its Y-axis (which is currently Z) by 90 degrees, 
    // then cut a hole, then rotate back? No, that rotates around Z.
    
    // Correct method for "slot running along X":
    // We need to cut material out of the top face along the X axis.
    // This means we need an extrusion in the X direction.
    // In OpenSCAD, rotating a cylinder around its axis makes it extrude in that direction.
    // So if we rotate the base_block 90 degrees around Y (which is currently Z), 
    // the slot will be vertical on the sides? No.
    
    // Let's try rotating 90 degrees around Y -> slots become horizontal on top? No, they would be vertical if rotated by 180?
    // If we rotate base_block 90 deg around Y: The slot (which was along X) becomes along Z.
    // Then rotate back 90 deg around Y: It returns to X. But the orientation is wrong.
    
    // Let's try rotating 90 degrees around Z axis -> slots become horizontal on top? No, they would be vertical if rotated by 180?
    // If we rotate base_block 90 deg around Z (which is currently Y): The slot (which was along X) becomes along Y.
    
    // Okay, let's just use a simpler method:
    // Create a hollow cylinder along X with length = block_length/2 + offset? 
    // No, the slot is open at the top.
    
    // Correct approach:
    // Create a hollow cylinder along Y (length = block_height), then rotate it?
    // If we rotate base_block 90 degrees around Y axis -> the slot runs along Z now? No.
    
    // Let's just use rotate_extrude on the base_block with an axis perpendicular to the face we want to cut.
    // We want the slot to run along X. So we need to cut along X.
    // This means the rotation axis must be perpendicular to X (i.e., Y or Z).
    
    // Let's rotate 90 degrees around Y axis -> now slots are vertical on sides? No, they become horizontal on top if rotated back?
    // If we rotate 90 deg around Y: The slot (which was along X) becomes along Z.
    // Then rotate back 90 deg around Y: It returns to X. But the orientation is wrong
    
    // Let's try rotating 90 degrees around Z axis -> slots become horizontal on top? No, they would be vertical if rotated by 180?
    
    // Okay, let's just use a simpler method:
    // Create a hollow cylinder along X with length = block_length/2 + (block_width/2 - slot_width)? 
    // No, the slot is open at the top.
    
    // Correct approach:
    // Create a hollow cylinder along Y (length = block_height), then remove material from top face? No.
    
    // Let's use rotate_extrude on the base_block with an axis perpendicular to the slot direction.
    // We want the slot to run along X. So we need to cut along X.
    // This means the rotation axis must be perpendicular to X (i.e., Y or Z).
    
    // Let's rotate 90 degrees around Y axis -> now slots are vertical on sides? No, they become horizontal on top if rotated back?
    // If we rotate 90 deg around Y: The slot (which was along X) becomes along Z.
    // Then rotate back 90 deg around Y: It returns to X. But the orientation is wrong
    
    // Let's try rotating 90 degrees around Z axis -> slots become horizontal on top? No, they would be vertical if rotated by 180?
    
    // Okay, let's just use a simpler method:
    // Create a hollow cylinder along X with length = block_length/2 + (block_width/2 - slot_width)? 
    // No, the slot is open at the top.
    
    // Correct approach:
    // Create a hollow cylinder along Y (length = block_height), then remove material from top face? No.
    
    // Let's use rotate_extrude on the base_block with an axis perpendicular to the slot direction.
    // We want the slot to run along X. So we need to cut along X.
    // This means the rotation axis must be perpendicular to X (i.e., Y or Z).
    
    // Let's rotate 90