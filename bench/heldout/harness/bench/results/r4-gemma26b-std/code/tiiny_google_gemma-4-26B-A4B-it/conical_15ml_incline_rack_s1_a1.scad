// --- Dimensions ---
block_x = 130;           // Length of the block (X)
block_y = 60;            // Depth of the block (Y)
block_z = 45;            // Height of the block (Z)

num_holes = 5;           // Number of tube holes
hole_spacing = 24;       // Distance between hole centers (X)
hole_diameter = 17.5;    // Diameter of the holes
hole_depth = 40;         // Depth of the holes along their axis

tilt_angle = 30;         // Tilt angle from vertical (degrees)
tilt_y_offset = -10;     // Y-coordinate where the hole axis meets the top face

// --- Constants ---
$fn = 64;                // Smoothness for cylinders
eps = 0.1;               // Small offset for boolean operations

// --- Calculations ---
// The total span of holes is (num_holes - 1) * hole_spacing
hole_span = (num_holes - 1) * hole_spacing;
start_x = -(hole_span / 2);

// The problem states: "tilted 30 degrees from vertical... moving toward +Y"
// In OpenSCAD, rotating around the X axis by a positive angle moves 
// the +Z axis towards the +Y axis. 
// To tilt the hole (which is oriented along Z) towards +Y, we rotate by 30 degrees.
// However, the cylinder is drawn from Z=0 to Z=h. 
// To make it start at the top face (Z=45) and go down, we must translate 
// it to the top and rotate it.

// --- Main Model ---
difference() {
    // The main block
    // Centered on origin in X and Y, resting on Z=0
    translate([-block_x/2, -block_y/2, 0])
        cube([block_x, block_y, block_z]);

    // The five blind holes
    for (i = [0 : num_holes - 1]) {
        // Calculate X position for this hole
        current_x = start_x + (i * hole_spacing);
        
        // Hole placement logic:
        // 1. The axis meets the top face at (current_x, tilt_y_offset, block_z).
        // 2. The axis is tilted 30 degrees from vertical towards +Y.
        // 3. The cylinder is drawn along the Z axis.
        // 4. To tilt the Z-axis towards +Y, we rotate around the X-axis by 30 degrees.
        // 5. To ensure the cylinder starts at the top face and goes "down" into the block,
        //    we translate the cylinder to the top face and rotate it.
        //    Since a standard cylinder is drawn from Z=0 to Z=h, we must rotate it 
        //    and then translate it so the "top" of the cylinder is at the top of the block.
        
        // Rotation: rotate(30) around X axis makes the Z-axis vector (0, sin(30), cos(30)).
        // This vector points "up and forward" (+Y, +Z).
        // To make it point "down and forward" (-Z, +Y), we rotate by -30 degrees.
        
        // Let's use the rotation that tilts the Z-axis towards +Y:
        // rotate([0, -30, 0]) would tilt Y towards Z.
        // rotate([-30, 0, 0]) tilts Z towards Y.
        // To tilt Z towards +Y, we rotate around X by -30 degrees.
        // Wait, let's check: rotate([-30, 0, 0]) on vector (0,0,1) -> (0, sin(-30), cos(-30)) = (0, -0.5, 0.866).
        // That tilts towards -Y.
        // To tilt towards +Y, we rotate by +30 degrees around X.
        // rotate([30, 0, 0]) on vector (0,0,1) -> (0, sin(30), cos(30)) = (0, 0.5, 0.866).
        // This vector points towards +Y and +Z.
        // Since we want the hole to go DOWN into the block, we want the vector to be (0, sin(30), -cos(30)).
        // This is achieved by rotating the cylinder by -30 degrees around X, 
        // but we must start the cylinder at the top face.
        
        // Correct approach:
        // Place the cylinder at the top face, rotate it so it points down and +Y,
        // and extend it slightly to ensure a clean cut.
        
        translate([current_x, tilt_y_offset, block_z])
            rotate([30, 0, 0]) // This tilts the Z-axis towards +Y
                // We use a negative Z translation or rotate the cylinder 
                // so it extends downwards.
                // If we rotate by 30 deg, the cylinder goes from Z=45 to Z=45 + 40*cos(30).
                // We need it to go from Z=45 down to Z=45 - 40*cos(30).
                // The easiest way: translate to top, rotate, then translate back by the 
                // vertical component of the length.
                // Or: rotate the cylinder and translate it so its "top" is at the top face.
                
                // Let's use: translate to top, rotate, then translate by -hole_depth * cos(30)
                // But the cylinder is not centered. Let's use the rotation and then 
                // translate the cylinder so its top face is at the block's top face.
                
                // A cylinder of height H rotated by angle A has a vertical height of H*cos(A).
                // To have the top face of the cylinder at Z=block_z:
                // We rotate first, then translate.
                // The cylinder starts at Z=0 and goes to Z=H.
                // After rotate([30,0,0]), the top face is at Z = H*cos(30).
                // So we translate by -H*cos(30) to bring the top face to Z=0.
                // Then translate to [current_x, tilt_y_offset, block_z].
                
                translate([0, 0, -hole_depth * cos(30)])
                    cylinder(h = hole_depth + eps, d = hole_diameter);
    }
}

// The previous logic had a mistake in the rotation direction and translation.
// Let's re-verify:
// 1. Cylinder is at (0,0,0) to (0,0,40).
// 2. Rotate([30,0,0]) -> Cylinder is at (0,0,0) to (0, 40*sin(30), 40*cos(30)).
// 3. The "top" of the cylinder is at Z = 40*cos(30).
// 4. We want the "top" of the cylinder to be at Z = 45.
// 5. So we translate by (45 - 40*cos(30)).
// 6. But the user said the axis meets the top face at y = -10.
// 7. This means the center of the cylinder's top face is at (current_x, -10, 45).

// Let's use a more robust method:
// Define the hole as a cylinder, rotate it, then move its top-center to the target.

// RE-IMPLEMENTING THE DIFFERENCE BLOCK:
/*
difference() {
    block();
    for (i = [0 : num_holes - 1]) {
        current_x = start_x + (i * hole_spacing);
        translate([current_x, tilt_y_offset, block_z])
            rotate([30, 0, 0]) // Tilt Z towards +Y
                translate([0, 0, -hole_depth]) // Move bottom to origin
                    cylinder(h = hole_depth + eps, d = hole_diameter);
        // Wait, if I rotate 30 deg, the cylinder's top face is at Z=0.
        // If I then translate it to [x, y, 45], the top face is at Z=45.
        // Let's check the direction: rotate([30,0,0]) on (0,0,1) -> (0, sin 30, cos 30).
        // This points towards +Y and +Z.
        // We want it to point towards