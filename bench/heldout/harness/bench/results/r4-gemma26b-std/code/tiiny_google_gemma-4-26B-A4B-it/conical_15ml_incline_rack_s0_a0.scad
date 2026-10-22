// --- Parameters ---
// Block dimensions
block_x = 130;          // Length of the block (X)
block_y = 60;           // Depth of the block (Y)
block_z = 45;           // Height of the block (Z)

// Hole properties
hole_diameter = 17.5;   // Diameter of the conical tube holes
hole_depth = 40;        // Depth of the holes measured along their axis
hole_count = 5;         // Number of holes
hole_spacing = 24;      // Distance between hole centers along X
tilt_angle = 30;        // Tilt angle from vertical (YZ plane)

// Offset to center the holes along X
// The holes are centered on the block, so the middle hole is at X=0
// The sequence is: -(spacing*2), -(spacing*1), 0, +(spacing*1), +(spacing*2)
// We calculate the start position to ensure the whole group is centered.
hole_offset_x = (hole_spacing * (hole_count - 1)) / 2;

// Modeling constants
$fn = 64;               // Smoothness for cylinders
clearance = 0.1;        // Small clearance for boolean operations

// --- Main Model ---

// The block is centered on X and Y, resting on Z=0
// Since the user said "standing on the bed and centred on the origin in X and Y",
// and the block is 45mm tall, the Z range is [0, 45].
// To center X and Y, we translate the cube by [-block_x/2, -block_y/2, 0].

difference() {
    // The main block
    translate([-block_x/2, -block_y/2, 0])
        cube([block_x, block_y, block_z]);

    // The five blind holes
    for (i = [0 : hole_count - 1]) {
        // Calculate X position for this hole
        // Center of the block is 0. Holes are spaced 24mm apart.
        // We want the middle hole (index 2) to be at X=0.
        // X_pos = (i - (hole_count-1)/2) * hole_spacing
        // However, the user said "24mm apart along X and centred on the block".
        // This implies the group of holes is centered.
        x_pos = (i - (hole_count - 1) / 2) * hole_spacing;
        
        // The axis meets the top face at Y = -10.
        // The top face is at Z = block_z.
        // The tilt is 30 degrees from vertical in the YZ plane.
        // "Going down into the block, it moves toward +Y".
        // This means the tilt vector in YZ plane is (sin(30), -cos(30)).
        // Wait, if it moves toward +Y as it goes down (negative Z), 
        // the Y coordinate increases as Z decreases.
        
        // Let's define the center of the hole at the top face:
        top_y = -10;
        top_z = block_z;
        
        // We use a rotation and translation to place the cylinder.
        // The cylinder axis is tilted 30 degrees from vertical.
        // Vertical is (0, 0, -1). 
        // Tilted 30 deg towards +Y means the axis vector is (0, sin(30), -cos(30)).
        // In OpenSCAD, we rotate around X axis to tilt in YZ plane.
        
        translate([x_pos, top_y, top_z])
        rotate([-tilt_angle, 0, 0]) // Rotate around X to tilt in YZ plane
        // Note: A negative rotation around X tilts the Z-axis towards +Y.
        // Let's verify: rotate([-30, 0, 0]) of vector (0,0,-1) 
        // results in (0, sin(30), -cos(30)) -> (0, 0.5, -0.866).
        // This moves towards +Y as Z decreases. Correct.
        
        // We extend the cylinder slightly in Z to ensure a clean cut of the top face
        // and extend it downwards to ensure the "blind" bottom is clean.
        // Since it's a blind hole, we use a cylinder and the difference() handles the rest.
        // To make it a "flat end square to the axis", we just use a standard cylinder.
        // To ensure it cuts through the top, we translate it up slightly.
        translate([0, 0, clearance])
            cylinder(h = hole_depth + clearance, d = hole_diameter);
    }
}

// Note on orientation:
// The block is centered on X and Y.
// X range: [-65, 65]
// Y range: [-30, 30]
// Z range: [0, 45]
// Hole Y-intercept: -10
// Hole tilt: 30 degrees towards +Y as it goes down.