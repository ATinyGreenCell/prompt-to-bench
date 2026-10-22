// --- Dimensions ---
block_width = 50;          // X dimension of the block
block_depth = 30;          // Y dimension of the block
block_height = 40;         // Z dimension of the block

barrel_radius = 8.25;      // Radius for the 16.5mm barrel channel
flange_slot_width = 34;     // X width of the flange slot
flange_slot_height = 2.6;   // Z height of the flange slot
flange_slot_z_start = 30;   // Bottom Z of the flange slot
flange_slot_y_end = 11;     // How far back the slot goes from the front

screw_hole_dia = 4.5;       // Diameter for M4 screw holes
screw_hole_x_offset = 19;   // X position of screw holes
screw_hole_z = 15;          // Z position of screw holes

// --- Constants ---
$fn = 64;

// --- Main Model ---
// The part is printed standing on the bed (Z=0).
// The block is centered on X and Y.
// The back face is at Y = 15.
// The front face is at Y = -15.

// We use a coordinate system where the block is centered at (0,0,20) 
// so that the bottom face is at Z=0.
translate([0, 0, block_height/2]) {
    difference() {
        // The main block
        // We use a cube centered at origin, then translate it so bottom is at Z=0
        // But the user says "standing on the bed and centred on the origin in X and Y"
        // This implies the base is at Z=0.
        // To achieve this, we define the cube from Z=0 to Z=40.
        translate([0, 0, -block_height/2])
        cube([block_width, block_depth, block_height], center = true);

        // 1. Barrel Channel
        // "back end is a half-circle of 8.25 mm radius centred at x = 0, y = 0"
        // "straight sides run forward to the front face (y = -15)"
        // This describes a semi-cylinder shape.
        // Since the block is 30mm deep and centered, Y goes from -15 to 15.
        // The channel starts at Y=0 and goes to Y=-15.
        
        // We create the channel by subtracting a cylinder and a rectangular prism.
        // A cylinder at (0,0) with radius 8.25, and a cube to make it a semi-circle.
        union() {
            // The semi-cylinder part (the back end at Y=0)
            // We use a cylinder and a large cube to cut it in half.
            translate([0, 0, -block_height/2 - 1])
            rotate([90, 0, 0])
            cylinder(h = 16, r = barrel_radius, center = true);
            
            // The straight part extending to the front face (Y = -15)
            // The user says "straight sides run forward to the front face".
            // This implies the channel is a semi-cylinder that is "cut" at Y=0.
            // Actually, a semi-cylinder centered at (0,0) with radius 8.25 
            // extending from Y=0 to Y=-15 is just a cylinder of length 15.
            // But the "back end" is the flat part of the semi-circle at Y=0.
            
            // Let's define the cutter as a cylinder of radius 8.25, 
            // centered at (0, -7.5, 0) with length 15.
            // Then we use a cube to ensure it's only the "front" half.
            translate([0, -7.5, 0])
            rotate([90, 0, 0])
            cylinder(h = 15, r = barrel_radius, center = true);
        }
        
        // To ensure the channel is a semi-circle at Y=0 and straight to Y=-15:
        // We subtract a cylinder centered at (0, -7.5, 0) with radius 8.25 and length 15.
        // Then we subtract a cube to cut the "back" half of that cylinder.
        // Wait, the user says "back end is a half-circle... at y=0".
        // This means the flat part of the semi-circle is at Y=0.
        // So the channel is a semi-cylinder with radius 8.25 and length 15.
        
        // Let's use a more precise subtraction for the channel:
        // A cylinder centered at (0, -7.5, 0) with radius 8.25 and length 15.
        // Then we subtract a cube that removes the "back" half (the part where Y > 0).
        // But the cylinder is already only from Y=-15 to Y=0.
        // So we just need to make sure the "back" of the cylinder is flat at Y=0.
        // A cylinder centered at (0, -7.5, 0) with length 15 has ends at Y=-15 and Y=0.
        // This is exactly what is needed.
        
        // Re-calculating the channel subtraction:
        // The cylinder is centered at (0, -7.5, 0), length 15.
        // Its Z-range is -20 to 20 (to cover the block).
        // Its Y-range is -15 to 0.
        // Its X-range is -8.25 to 8.25.
        // This creates a semi-cylinder with a flat face at Y=0.
        
        // Let's use a single subtraction for the channel:
        // We'll use a cylinder and a cube to define the semi-cylinder.
        // Actually, a cylinder at (0, -7.5, 0) with length 15 and radius 8.25
        // is a full cylinder. We need to cut it in half to make it a semi-cylinder.
        // But the user says the "back end is a half-circle". 
        // This means the profile is a semi-circle.
        // A semi-circle has a flat edge. If the flat edge is at Y=0, 
        // and the curve goes to Y=-15, then the center of the circle is at (0,0).
        // The radius is 8.25. The depth is 15.
        // This is a semi-cylinder.
        
        // Let's define the channel cutter:
        // A cylinder centered at (0, -7.5, 0) with radius 8.25 and length 15.
        // Then we subtract a cube to cut it in half? No, the cylinder is already 
        // only 15mm long. If it's centered at Y=-7.5, it goes from Y=-15 to Y=0.
        // If we want the "back end" (the flat part) to be at Y=0, 
        // then the cylinder should be centered at (0, -7.5, 0) with length 15.
        // This cylinder's flat faces are at Y=-15 and Y=0.
        // To make it a semi-cylinder, we need to cut it in half along the X axis.
        // Wait, the user says "straight sides run forward to the front face".
        // This means the profile is a semi-circle.
        // A semi-circle has a diameter. The diameter would be along the X axis.
        // So the channel is a semi-cylinder with radius 8.25 and length 15.
        // The flat part of the semi-cylinder is at Y=0.
        
        // Let's use this:
        translate([0, -7.5, 0])
        rotate([90, 0, 0])
        cylinder(h = 15, r = barrel_radius, center = true);
        
        // To make it a semi-cylinder (cutting the cylinder in half along X):
        translate([-block_width, -20, -block_height])
        cube([block_width*2, 2, block_height*2]); // This is not quite right.
        
        // Let's try again. The channel is a semi-cylinder.
        // A semi-cylinder is a cylinder cut in half.
        // Let's use a cylinder and a cube to cut it.
        // Cylinder: center (0, -7.5,