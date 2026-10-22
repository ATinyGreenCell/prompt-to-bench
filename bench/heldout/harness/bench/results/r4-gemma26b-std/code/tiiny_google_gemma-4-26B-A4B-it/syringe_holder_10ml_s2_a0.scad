// --- Dimensions (mm) ---
block_width = 50;          // X dimension
block_depth = 30;          // Y dimension
block_height = 40;         // Z dimension

barrel_channel_width = 16.5; // Width of the syringe barrel slot
barrel_radius = barrel_channel_width / 2;

flange_slot_width = 34;     // Width of the flange cutout
flange_slot_height = 2.6;   // Height of the flange cutout
flange_slot_z_start = 30;   // Bottom Z of flange slot
flange_slot_z_end = 32.6;   // Top Z of flange slot
flange_slot_depth_back = 11; // How far back the slot goes (y = 11)

screw_hole_dia = 4.5;       // Diameter for M4 screws
screw_hole_x_offset = 19;   // X position of screw holes
screw_hole_z = 15;          // Z position of screw holes

// --- Constants ---
$fn = 64;

// --- Main Block Construction ---
// The block is centered on X and Y, resting on Z=0.
// Back face is at y = 15, Front face is at y = -15.

difference() {
    // The main body of the holder
    cube([block_width, block_depth, block_height], center = true);
    // Note: cube(center=true) centers on X, Y, and Z. 
    // To match "rests on bed at Z=0", we must translate the cube.
    // However, the prompt says "standing on the bed and centred on the origin in X and Y".
    // This implies the base is at Z=0.
    
    // Correcting the base: We will build the block using translate to ensure Z=0 is the floor.
    // But to keep logic simple, I will define the block starting from Z=0.
}

// Re-writing the block to ensure Z=0 is the base and it is centered on X,Y
module holder_body() {
    translate([-block_width/2, -block_depth/2, 0])
    cube([block_width, block_depth, block_height]);
}

difference() {
    // 1. The main block
    holder_body();

    // 2. The Barrel Channel
    // Back end is a half-circle of 8.25mm radius centered at x=0, y=0 (relative to block center)
    // The prompt says "back end is a half-circle... at x=0, y=0". 
    // Since the block is 30mm deep, y=0 is the center of the block.
    // The back face is at y=15. If the half-circle is at y=0, it's in the middle.
    // Re-reading: "its back end is a half-circle... at x=0, y=0, and its straight sides run forward to the front face (y=-15)".
    // This implies the "back" of the channel is at y=0 and it extends to y=-15.
    // However, the block's back face is at y=15. 
    // Let's interpret "back end" of the channel as the part furthest from the user (closest to the wall).
    // If the channel is 16.5mm wide, radius is 8.25.
    // The channel runs from the front (y=-15) to the back.
    
    // Let's define the channel shape:
    // It's a U-shape. A rectangle with a semi-circle at the back.
    // The prompt says "back end is a half-circle... at x=0, y=0".
    // This means the center of the circle is at (0, 0, z).
    // The straight sides run to y = -15.
    
    translate([-barrel_radius, -15, -1]) // Extend slightly in Y and Z
    union() {
        // The rectangular part of the channel
        cube([barrel_channel_width, 15, block_height + 2]);
        // The semi-circular part at the back (y=0)
        // Since the rectangle goes from y=0 to y=-15, the semi-circle must be at y=0
        // to make the "back" of the channel rounded.
        // To make it a "back end" at y=0, we place the half-circle there.
        translate([0, 0, 0])
        rotate([0, 0, 0])
        cylinder(r = barrel_radius, h = block_height + 2);
    }
    // Wait, the above logic creates a full cylinder. 
    // Let's use a more precise subtraction for the U-channel.
    
    // Corrected Barrel Channel Subtraction:
    // We want a shape that is a rectangle from y=-15 to y=0, 
    // and a semi-circle at y=0.
    // Actually, the prompt says "back end is a half-circle... at x=0, y=0".
    // This means the "bottom" of the U is at y=0.
    // Let's create the shape:
    /*
    union() {
       cube([16.5, 15, 40]); // from y=-15 to y=0
       cylinder(r=8.25, h=40); // centered at y=0
    }
    */
    // But we only want the half-circle that goes into the positive Y space? 
    // No, the channel is a void.
    // Let's define the void:
    // A rectangle from y=-15 to y=0, and a semi-circle centered at y=0.
    // But the block only goes to y=15.
    // If the semi-circle is at y=0, the "back" of the channel is at y=8.25.
    // Let's follow the prompt literally: "back end is a half-circle... at x=0, y=0".
    // This means the void's deepest point is at y=0.
    // The sides run from y=0 to y=-15.
    
    // Let's use a hull of a rectangle and a cylinder to be safe.
    // Or simply:
    translate([-barrel_radius, -15, -1])
    union() {
        cube([barrel_channel_width, 15, block_height + 2]);
        translate([0, 0, 0])
        cylinder(r = barrel_radius, h = block_height + 2);
    }
    // Wait, the cylinder is centered at 0,0. The rectangle is from -15 to 0.
    // This creates a shape that is a rectangle + a full cylinder.
    // We need to cut the cylinder so it's only the part that makes the "back" rounded.
    // If the rectangle is from y=-15 to y=0, the semi-circle at y=0 
    // would extend from y=0 to y=8.25.
    
    // Let's try this:
    // 1. Rectangle: x=[-8.25, 8.25], y=[-15, 0], z=[0, 40]
    // 2. Semi-circle: x=[-8.25, 8.25], y=[0, 8.25], z=[0, 40]
    // This makes the "back" of the channel at y=8.25.
    // But the prompt says "back end is a half-circle... at x=0, y=0".
    // This implies the center of the circle is at y=0.
    // If the center is at y=0, and it's a "back end", the void exists for y > 0.
    // Let's assume the void is the union of:
    // - A rectangle from y=-15 to y=0
    // - A semi-circle (the half where y > 0) centered at y=0.
    
    // Let's use a simpler approach for the channel:
    // A rectangle from y=-15 to y=8.25, but with rounded corners at the back?
    // No, let's follow: "back end is a half-circle... at x=0, y=0, and its straight sides run forward to the front face (y=-15)".
    // This means the void is:
    // A rectangle from y=-15 to y=0, width 16.5.
    // A semi-circle centered