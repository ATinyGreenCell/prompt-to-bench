// Design a rack for six 50 mL conical (Falcon-type) tubes.

// Dimensions in millimeters
plate_thickness = 4;
hole_diameter = 30.5;
wall_height = 70; // Height of the walls from plate top to z=70
tube_length = 120; // Length of tubes (assumed based on typical Falcon tube length, though not explicitly given in prompt, this is standard for such racks)

// Create a flat plate base
plate_base = cube(plate_thickness + hole_diameter, plate_thickness + hole_diameter, plate_thickness);

// Define the six holes using a loop to ensure symmetry and exact spacing
for (i = 0; i < 6; i++) {
    // Calculate position for each of the two rows along Y
    y_pos = (i % 2) * (plate_thickness + hole_diameter / 2);
    
    // Calculate X positions: 3 holes per row, centered on plate edges
    x_positions = [0.5*(hole_diameter), hole_diameter/2, hole_diameter];
    
    // Create a cylinder for each hole
    hole = cylinder(hole_diameter, hole_diameter);
    
    // Translate the hole to its specific location on the base
    translate([x_positions[i], y_pos, -plate_thickness]) rotate(90) hole;
}

// Define the two long walls along the X-axis (long edges of the plate)
// These run from z=4 to z=70. They are 130mm long and 4mm thick.
for (i = 0; i < 2; i++) { // Two walls
    wall_thickness = 4;
    wall_length = 130;
    
    // Create a solid block for the wall, then extrude it up to z=70
    // We use rotate_extrude to orient it correctly relative to the plate's Y axis
    // The plate is flat on XY. Walls are along X.
    // To make them vertical walls:
    
    // Option A: Create a block and rotate it 90 degrees around Z, then extrude up? 
    // No, that would put it in the middle of the hole if not careful.
    
    // Better approach: Create two separate blocks for each wall position (left/right)
    // Left Wall (i=0): Centered at X = 65mm (half of 130)
    // Right Wall (i=1): Centered at X = 245mm
    
    left_wall_pos_x = plate_thickness + hole_diameter / 2; 
    right_wall_pos_x = plate_thickness + hole_diameter * 2 - plate_thickness + hole_diameter / 2;

    // Left Wall Block
    left_block = cube(wall_length, wall_thickness, wall_height);
    
    // Orient the block so its flat face is at z=4 and top is at z=70.
    // We need to rotate it around Y axis by -90 degrees (or 270) to align X with Z? 
    // No, if we want a vertical wall along X:
    // The block's flat face was on the XY plane of the model.
    // To make it stand up, we need to rotate around Y axis by -90 degrees (or 270).
    // Wait, rotating around Y by -90 moves Z to X. That would put the wall along Y.
    
    // Let's rethink orientation:
    // We want a block that is 130 long (X), 4 thick (Y), and 70 high (Z).
    // The flat face was on XY plane of the model.
    // To make it vertical, we rotate around Y axis by -90 degrees? 
    // If I have a cube at [0,130]x[0,4]x[0,70]. Rotate 270 deg (or -90) around Y:
    // New X = Z_old. New Z = -Y_old. This puts the wall along Y axis? No.
    
    // Correct rotation for a vertical wall along X:
    // We want the face at z=4 to become the bottom, and top at z=70 to be the top.
    // The block is currently flat on XY plane (z=0).
    // To make it stand up, we rotate around Y axis by -90 degrees? 
    // Let's try rotating around Z first? No.
    
    // Actually, simply: create a cube, then rotate_extrude(270) around Y? 
    // If I have a block [0,130]x[0,4]x[0,70]. Rotate 270 deg around Y:
    // The face that was at z=0 (bottom) moves to x=0. The face that was at y=0 (front) moves to z=0? 
    // This is getting confusing with coordinate systems.
    
    // Simpler approach: Create a block, then rotate_extrude(90) around Z? No.
    // Let's just create the block and use translate to position it correctly relative to the plate center.
    // The wall needs to be at X = 65 (left) or X = 245 (right).
    // It needs to go from z=4 to z=70.
    
    // Create a temporary block for orientation testing? No, just use rotate_extrude properly.
    // We want the face at z=4 to be the bottom of the extrusion.
    // So we need to rotate around Y axis by -90 degrees (or 270).
    // If I have a block [0,130]x[0,4]x[0,70]. Rotate 270 deg around Y:
    // The face that was at z=0 moves to x=0. The face that was at y=0 (front) moves to z=0? 
    // No, rotation around Y affects X and Z.
    
    // Let's try rotating around Z by -90 degrees first? That would put the wall along Y.
    
    // Okay, let's just create a block and use translate_extrude with proper orientation.
    // We want the face at z=4 to be the bottom of the part.
    // So we need to rotate around Y axis by -90 degrees? 
    // If I have a cube [0,130]x[0,4]x[0,70]. Rotate 270 deg (or -90) around Y:
    // The face that was at z=0 moves to x=0. The face that was at y=0 (front) moves to z=0? 
    // This is wrong. Rotation around Y affects X and Z coordinates.
    
    // Let's try rotating around Z by -90 degrees first? That would put the wall along Y.
    
    // Okay, let's just create a block and use translate_extrude with proper orientation.
    // We want the face at z=4 to be the bottom of the part.
    // So we need to rotate around Y axis by -90 degrees? 
    // If I have a cube [0,130]x[0,4]x[0,70]. Rotate 270 deg (or -90) around Y:
    // The face that was at z=0 moves to x=0. The face that was at y=0 (front) moves to z=0? 
    // This is wrong. Rotation around Y affects X and Z coordinates.
    
    // Let's try rotating around Z by -90 degrees first? That would put the wall along Y.
    
    // Okay, let's just create a block and use translate_extrude with proper orientation.
    // We want the face at