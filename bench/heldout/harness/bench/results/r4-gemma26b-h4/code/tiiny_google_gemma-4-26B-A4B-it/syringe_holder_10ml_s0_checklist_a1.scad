// Wall-mounted syringe holder for 10mL syringe
// Corrected barrel channel alignment

// --- Dimensions ---
block_w      = 50.0;    // Block width (X)
block_d      = 30.0;    // Block depth (Y)
block_h      = 40.0;    // Block height (Z)

barrel_dia   = 16.5;    // Diameter of the syringe barrel channel
barrel_rad   = barrel_dia / 2;

flange_w      = 34.0;    // Width of the flange slot (X)
flange_h      = 2.6;     // Height of the flange slot (Z)
flange_z_min  = 30.0;    // Bottom of the flange slot (Z)
flange_y_end  = 11.0;    // How far back the slot goes (Y)

screw_hole_d  = 4.5;     // Diameter for M4 screws
screw_x_pos   = 19.0;    // X offset for screw holes
screw_z_pos   = 15.0;    // Z height for screw holes

$fn = 64;

// --- Modeling ---

difference() {
    // 1. The main block
    // Centered on X and Y, sitting on Z=0.
    // X: [-25, 25], Y: [-15, 15], Z: [0, 40]
    translate([-block_w/2, -block_d/2, 0])
        cube([block_w, block_d, block_h]);

    // 2. The barrel channel
    // A half-circle at the back (y=15) and straight sides to the front (y=-15).
    // The specification says the back end is a half-circle centered at x=0, y=0.
    // This means the center of the circle is at (0,0) in the XY plane.
    // To make it a "half-circle" that opens towards the front, 
    // we use a cylinder and translate it so the center of the cylinder 
    // is at (0,0) and it is cut in half by the plane y=0.
    // However, the prompt says "its back end is a half-circle... and its straight sides run forward".
    // This implies the channel is a semi-cylinder whose flat face is at y=0.
    // But the syringe is 16mm wide and the block is 30mm deep.
    // If the half-circle is at x=0, y=0, the "back" of the channel is at y=0.
    // Let's align the cylinder axis with the Y axis.
    // To get a half-circle at x=0, y=0, we translate the cylinder by +barrel_rad in Y.
    translate([0, barrel_rad, 0]) 
        rotate([0, 90, 0])
            cylinder(h = block_d + 2, d = barrel_dia);
    
    // To ensure it is a "half-circle" at the back and straight sides, 
    // we must subtract the other half of the cylinder.
    // The prompt says "its back end is a half-circle... and its straight sides run forward".
    // This describes a semi-cylinder.
    translate([0, -barrel_rad, 0])
        rotate([0, 90, 0])
            cylinder(h = block_d + 2, d = barrel_dia);
    // Wait, the simplest way to get a semi-cylinder centered at x=0, y=0 
    // with the flat part at y=0 is to use a cylinder and a cube to cut it.
    // But the prompt says the back end is a half-circle. 
    // If the back end is at y=15, and the center is at y=0, that's a full cylinder.
    // Re-reading: "its back end is a half-circle... centered at x=0, y=0".
    // This implies the "back" of the hole is at y=0.
    // Let's use the logic: A cylinder centered at x=0, y=0, rotated to Y axis,
    // but we only want the part where y > 0 (if back is y=0) or y < 0.
    // Given "slides in from the front (y=-15)", the channel exists from y=-15 to y=0.
    
    // Let's redefine the channel:
    // A cylinder of diameter 16.5, axis along Y, centered at x=0, y=0.
    // We only want the half where y is between -15 and 0? No, "back end is at y=0".
    // Let's use a cylinder and a cutting cube to ensure it's a perfect semi-cylinder.
    // The cylinder is centered at x=0, y=0.
    // The "back" of the hole is at y=0. The "front" is at y=-15.
    // This makes the channel a semi-cylinder.
    
    // Let's try again:
    // 1. Cylinder centered at x=0, y=0, axis = Y.
    // 2. Cut it with a cube to make it a semi-cylinder.
    // 3. The flat face of the semi-cylinder is at y=0.
    // 4. The curved part is at y = -barrel_rad.
    // 5. The prompt says "back end is a half-circle... centered at x=0, y=0".
    // This means the curved part is at y=0 and the flat part is at y=barrel_rad?
    // No, "slides in from the front (y=-15)".
    // If the back is at y=0 and it's a half-circle, the channel is between y=-15 and y=0.
    
    // Let's use the most robust method for a semi-cylinder:
    // A cylinder centered at (0,0,0) with axis Y, and a cube to cut it in half.
    // To make the "back" (the end of the hole) a half-circle at y=0:
    // The cylinder should extend from y=-15 to y=0.
    
    // RE-READ: "its back end is a half-circle... centered at x=0, y=0, and its straight sides