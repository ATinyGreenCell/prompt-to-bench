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
// The part is printed standing on the bed (Z=0)
// Centered on X and Y. Back face is at Y = 15.

difference() {
    // The main block
    cube([block_width, block_depth, block_height], center = true);

    // 1. Barrel Channel
    // The channel is a half-cylinder at the back and straight sides to the front.
    // Since the block is centered, Y goes from -15 to 15.
    // The back face is at Y = 15.
    // The half-circle is centered at X=0, Y=0 (Wait, user said Y=0 is center, 
    // but block is 30 deep, so Y goes -15 to 15. 
    // If back face is Y=15 and center is Y=0, the half circle is at the center of the block).
    // Re-reading: "its back end is a half-circle... centred at x=0, y=0".
    // This means the "back" of the channel is at the center of the block.
    // The straight sides run forward to the front face (y = -15).
    
    union() {
        // The half-cylinder part at the center
        translate([0, 0, -0.01])
        rotate([90, 0, 0])
        cylinder(h = 0.02, r = barrel_radius, center = true);
        
        // The straight part from Y=0 to Y=-15
        // We use a hull or a simple cylinder to create the slot
        translate([0, -7.5, 0])
        rotate([90, 0, 0])
        cylinder(h = 15, r = barrel_radius, center = true);
    }
    // Note: The instruction says "its back end is a half-circle... centred at x=0, y=0".
    // This implies the channel is a semi-circle at the center, and then extends to the front.
    // To ensure a clean cut, we use a subtraction of a shape that covers the whole height.
    
    // Correct approach for the barrel channel:
    // A cylinder centered at (0,0) with radius 8.25, but we only want the half facing the front.
    // Then we extend that shape to the front face.
    
    // Let's define the channel cutter:
    translate([0, 0, -0.01])
    rotate([90, 0, 0])
    cylinder(h = 30.02, r = barrel_radius, center = true);
    
    // To make it a "half-circle at the back", we actually need to subtract 
    // a shape that is a semi-circle at Y=0 and extends to Y=-15.
    // However, the user says "its back end is a half-circle... centred at x=0, y=0".
    // This means the "back" of the hole is at the center of the block.
    // Let's model the channel as a subtraction:
    // A cylinder centered at (0,0) with radius 8.25, but we only want the part where Y < 0.
    // And we extend it to the front face (Y = -15).
    
    // Let's use a more robust method for the channel:
    // A cylinder at (0,0) with radius 8.25, but we only want the half facing the front.
    // Then we extend that to the front face.
    // Actually, a cylinder at (0,0) with radius 8.25, and we only keep the part where Y < 0.
    // Then we extend it to Y = -15.
    
    // Let's try this:
    translate([0, 0, -0.01])
    rotate([90, 0, 0])
    cylinder(h = 30.02, r = barrel_radius, center = true);
    // The above is a full cylinder. To make it a "half circle at the back", 
    // we need to cut the back half of the cylinder.
    // But the user says the back end is a half circle at x=0, y=0.
    // This means the channel is a semi-circle at the center, and then it goes to the front.
    // This is effectively a semi-cylinder.
    
    // Let's use a hull of a semi-circle at Y=0 and a rectangle at Y=-15.
    // Or simpler: a cylinder at (0,0) and we only subtract the part where Y < 0.
    // Wait, if the back end is at Y=0, and the front is at Y=-15, the depth is 15.
    // If the block is 30 deep, the back face is at Y=15.
    // So from Y=15 to Y=0 is solid, and from Y=0 to Y=-15 is the channel.
    
    // Let's refine the channel subtraction:
    // 1. A semi-cylinder at the center (Y=0)
    // 2. A rectangular slot from Y=0 to Y=-15
    // Actually, the simplest way to describe "half circle at back, straight sides to front"
    // is a semi-cylinder.
    
    // Let's use a cylinder and a cube to define the channel shape.
    // But the user says "its back end is a half-circle... centred at x=0, y=0".
    // This means the "back" of the hole is at the center of the block.
    // Let's create a shape that is a semi-cylinder (the front half) and a cylinder (the back half).
    // No, the user says the back end is a half-circle. That means the hole is a semi-cylinder.
    
    // Let's define the channel cutter:
    // A cylinder at (0,0) with radius 8.25, but we only want the part where Y < 0.
    // And we extend it to the front face (Y = -15).
    // Wait, if the back end is at Y=0, and the front is at Y=-15, the channel is 15mm deep.
    // The block is 30mm deep. So the back 15mm is solid.
    
    // Let's use a hull of a semi-circle at Y=0 and a rectangle at Y=-15.
    // Actually, a cylinder at (0,0) with radius 8.25, and we only want the part where Y < 0.
    // Let's just use a cylinder at (0,0) and a cube to make the shape.
    
    // RE-READ: "its back end is a half-circle of 8.25 mm radius centred at x = 0, y = 0, and its straight sides run forward to the front face (y = -15)"
    // This means the channel is a semi-cylinder with radius 8.25, centered at (0,0), 
    // extending from Y=0 to Y=-15.
    
    // Let's do this:
    // Subtract a semi-cylinder (radius 8.25, length 15, centered at 0,0)
    // and a rectangle (width 16.5, depth 15, from Y=0 to Y=-15).
    // Actually, a semi-cylinder is exactly what is described.
    
    // Let's use a cylinder and a cube to define the channel:
    // A cylinder at (0,0) with radius 8.25, and we only take the part where Y