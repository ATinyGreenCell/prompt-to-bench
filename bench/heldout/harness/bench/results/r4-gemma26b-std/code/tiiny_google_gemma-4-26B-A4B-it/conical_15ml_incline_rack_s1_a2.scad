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
        // 3. A cylinder drawn from Z=0 to Z=H, when rotated by 30 deg around X,
        //    has its top face at Z = H * cos(30).
        // 4. To align the top face of the cylinder with the top face of the block (Z=45),
        //    we must translate the cylinder by (block_z - hole_depth * cos(30)).
        //    However, it is simpler to rotate the cylinder and then translate its 
        //    top-center to the target coordinate.
        
        // To tilt the Z-axis towards +Y, we rotate around the X-axis by -30 degrees.
        // Wait, let's re-verify: 
        // rotate([30, 0, 0]) on (0,0,1) -> (0, sin(30), cos(30)) = (0, 0.5, 0.866).
        // This vector points towards +Y and +Z.
        // Since we want the hole to go DOWN into the block (-Z) and towards +Y,
        // we want the vector to be (0, sin(30), -cos(30)).
        // This is achieved by rotating the cylinder by -30 degrees around X.
        
        // Let's use a more robust method:
        // We create a cylinder that is already oriented correctly, then move its top face.
        
        translate([current_x, tilt_y_offset, block_z])
            rotate([-tilt_angle, 0, 0]) // Rotate -30 deg around X to tilt Z towards +Y
                // We translate the cylinder downwards so its top face is at Z=0 
                // (relative to the rotation) and then move it to the top face.
                // Since the cylinder is drawn from Z=0 to Z=H, and we rotated it,
                // the top face is at Z=0 and the bottom is at Z=H*cos(30).
                // We need to translate it so the top face is at Z=block_z.
                // But the rotation is around the origin.
                // Let's use a simpler approach:
                // 1. Create cylinder from Z=0 to Z=H.
                // 2. Rotate it.
                // 3. Translate it so the top face (originally at Z=0) is at Z=block_z.
                //    Wait, if we rotate by -30, the top face (Z=0) stays at Z=0.
                //    The bottom face (Z=H) moves to Z = H * cos(-30) = H * cos(30).
                //    So we translate by block_z to put the top face at block_z.
                //    However, the rotation also shifts the Y coordinate.
                //    The center of the top face is (0,0,0).
                //    The center of the bottom face is (0, -H*sin(30), H*cos(30)).
                //    Wait, if we rotate by -30 around X, the Z axis (0,0,1) becomes (0, sin(-30), cos(-30)).
                //    That is (0, -0.5, 0.866). That tilts towards -Y.
                //    We want +Y. So we rotate by +30 degrees.
                //    rotate([30, 0, 0]) on (0,0,1) -> (0, sin(30), cos(30)) = (0, 0.5, 0.866).
                //    This tilts towards +Y.
                //    Now, the cylinder is at Z=0 to Z=H. The top face is at Z=H*cos(30).
                //    To put the top face at Z=block_z, we translate by (block_z - hole_depth * cos(30)).
                //    Wait, the user says "axis meets the top face at y = -10".
                //    This means the center of the top face is at (current_x, -10, 45).
                
                translate([0, 0, block_z]) // Move top face to block_z
                    rotate([30, 0, 0])    // Tilt Z towards +Y
                        translate([0, 0, -hole_depth - eps]) // Move cylinder down from top face
                            cylinder(h = hole_depth + eps, d = hole_diameter);
    }
}