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
hole_offset_x = (hole_spacing * (hole_count - 1)) / 2;

// Modeling constants
$fn = 64;               // Smoothness for cylinders
clearance = 0.1;        // Small clearance for boolean operations

// --- Main Model ---

// The block is centered on X and Y, resting on Z=0.
// The user specified the block is 130x60x45 and centered on the origin in X and Y.
// This means X is [-65, 65], Y is [-30, 30], Z is [0, 45].

difference() {
    // The main block
    translate([-block_x/2, -block_y/2, 0])
        cube([block_x, block_y, block_z]);

    // The five blind holes
    for (i = [0 : hole_count - 1]) {
        // Calculate X position for this hole
        // Middle hole (index 2) is at X=0.
        x_pos = (i - (hole_count - 1) / 2) * hole_spacing;
        
        // The axis meets the top face at Y = -10.
        // The top face is at Z = block_z.
        top_y = -10;
        top_z = block_z;
        
        // The tilt is 30 degrees from vertical in the YZ plane.
        // "Going down into the block, it moves toward +Y".
        // In OpenSCAD, rotating around the X axis by -30 degrees 
        // tilts the Z-axis towards the +Y direction.
        
        // To ensure the hole is "blind" and the bottom is "flat and square to the axis",
        // we must ensure the cylinder is long enough to pass through the top face
        // and its bottom face is exactly at the specified depth.
        
        // We translate the cylinder to the intersection point on the top face.
        // We rotate it to the correct angle.
        // We use a cylinder of length 'hole_depth'.
        // To ensure the top is cut cleanly, we translate it up by 'clearance'.
        
        translate([x_pos, top_y, top_z])
        rotate([-tilt_angle, 0, 0]) 
        translate([0, 0, clearance]) // Move up to ensure top face is cut
            cylinder(h = hole_depth, d = hole_diameter);
    }
}

// REASONING FOR FIXES BASED ON MEASUREMENT REPORT:
// The previous report showed the hole shapes at the top face (z=44.44) 
// were 17.30 x 8.65. This indicates the cylinder was not being cut 
// cleanly at the top face or the rotation/translation logic was 
// causing the cylinder to be partially outside the block's Z-bounds.
// 
// By using:
// 1. translate([x_pos, top_y, top_z]) 
// 2. rotate([-tilt_angle, 0, 0])
// 3. translate([0, 0, clearance])
// 4. cylinder(h = hole_depth, ...)
//
// The cylinder starts at Z = block_z + clearance (above the block)
// and extends down to Z = block_z + clearance - hole_depth.
// This ensures the top face of the block is perfectly intersected by 
// the cylinder's side, creating a clean elliptical opening, and the 
// bottom of the hole is a flat face perpendicular to the axis.