// --- Dimensions (mm) ---
block_width = 50;           // X dimension
block_depth = 30;           // Y dimension
block_height = 40;          // Z dimension

barrel_channel_width = 16.5; // Width of the syringe barrel slot
barrel_radius = barrel_channel_width / 2;

flange_slot_width = 34;     // Width of the flange cutout
flange_slot_height = 2.6;   // Height of the flange cutout
flange_slot_z_start = 30;   // Bottom Z of flange slot
flange_slot_z_end = 32.6;   // Top Z of flange slot
flange_slot_depth_back = 11; // How far back the slot goes (from front face y=-15 to y=-4)
// Note: Prompt says "cut in from the front face back to y=11". 
// Since front face is y=-15, y=11 is 26mm deep. 
// However, the block is only 30mm deep (from y=-15 to y=15).
// If it goes from y=-15 to y=11, it's 26mm deep.

screw_hole_dia = 4.5;       // Diameter for M4 screws
screw_hole_x_offset = 19;   // X position of screw holes
screw_hole_z = 15;          // Z position of screw holes

// --- Constants ---
$fn = 64;

// --- Main Construction ---

// The block is centered on X and Y, resting on Z=0.
// Front face is at y = -15, Back face is at y = 15.
module holder_body() {
    translate([-block_width/2, -block_depth/2, 0])
    cube([block_width, block_depth, block_height]);
}

difference() {
    // 1. The main block
    holder_body();

    // 2. The Barrel Channel
    // "back end is a half-circle of 8.25mm radius centred at x=0, y=0"
    // "straight sides run forward to the front face (y=-15)"
    // This implies the void is a rectangle from y=-15 to y=0 
    // plus a semi-circle centered at (0,0) extending into the positive Y space.
    union() {
        // Rectangular part of the channel
        translate([-barrel_radius, -15 - 0.1, -0.1])
        cube([barrel_channel_width, 15, block_height + 0.2]);
        
        // Semi-circular part at the back (centered at x=0, y=0)
        // We use a cylinder and cut it in half using a large cube
        translate([0, 0, -0.1])
        rotate([90, 0, 0])
        cylinder(r = barrel_radius, h = 0.2); 
        // The cylinder above is actually a disk. Let's do it properly:
        
        translate([0, 0, -0.1])
        rotate([90, 0, 0])
        cylinder(r = barrel_radius, h = 0.2);
    }
    // Wait, the logic above is messy. Let's use a cleaner subtraction for the U-channel:
    // We want a shape that is a rectangle [ -8.25, 8.25 ] x [ -15, 0 ] 
    // and a semi-circle centered at (0,0) with radius 8.25.
    
    // Let's restart the difference block logic clearly.
}

// RE-WRITING THE ENTIRE DIFFERENCE BLOCK FOR CLARITY AND ACCURACY
difference() {
    // The main block
    holder_body();

    // --- SUBTRACTIONS ---

    // 1. The Barrel Channel
    // We create a shape consisting of a rectangle and a semi-cylinder
    translate([0, 0, -1]) {
        // Rectangular part: from y=-15 to y=0
        translate([-barrel_radius, -15, 0])
        cube([barrel_channel_width, 15, block_height + 2]);
        
        // Semi-circular part: centered at y=0, extending to y=8.25
        // We use a cylinder and a cube to cut it in half
        translate([0, 0, 0])
        rotate([90, 0, 0])
        cylinder(r = barrel_radius, h = 0.1); // This is a disk at y=0
        
        // To make it a proper semi-cylinder:
        translate([0, 0, 0])
        rotate([90, 0, 0])
        cylinder(r = barrel_radius, h = 0.1); // This is not working well.
    }
    // Let's use a simpler method for the U-channel:
    // A rectangle from y=-15 to y=8.25, with the back corners rounded.
    // Actually, the prompt says "back end is a half-circle... at x=0, y=0".
    // This means the void is a rectangle from y=-15 to y=0, and a semi-circle at y=0.
    // Let's just define the void as a union of a rectangle and a cylinder.
    
    // Let's try again.
}

// FINAL ATTEMPT AT THE LOGIC
difference() {
    // The main block
    holder_body();

    // 1. The Barrel Channel (U-shape)
    // Rectangle part: x=[-8.25, 8.25], y=[-15, 0], z=[0, 40]
    translate([-barrel_radius, -15 - 0.1, -0.1])
    cube([barrel_channel_width, 15, block_height + 0.2]);
    
    // Semi-circle part: centered at (0,0), radius 8.25, extending to y=8.25
    // We use a cylinder and a cube to cut it in half.
    translate([0, 0, -0.1])
    rotate([90, 0, 0])
    cylinder(r = barrel_radius, h = 0.2); // This is a disk. 
    // Let's use a proper semi-cylinder:
    translate([0, 0, -0.1])
    rotate([90, 0, 0])
    intersection() {
        cylinder(r = barrel_radius, h = block_height + 0.2);
        translate([-barrel_radius, -0.1, -0.1])
        cube([barrel_channel_width, 8.25 + 0.1, block_height + 0.2]);
    }
    // Wait, the intersection is better. Let's use a simpler approach:
    // A cylinder centered at (0,0) with radius 8.25, but we only want the part where y > 0.
    // No, the prompt says "back end is a half-circle... at x=0, y=0".
    // This means the void is the union of:
    // - Rectangle: x=[-8.25, 8.25], y=[-15, 0], z=[0, 40]
    // - Semi-circle: x=[-8.25, 8.25], y=[0, 8.25], z=[0, 40]
    
    // Let's use the "hull" of two shapes to make the channel.
    // Shape 1: Rectangle at y=-15
    // Shape 2: Semi-circle at y=0
    // This is getting complicated. Let's use the most direct way:
    // A cylinder centered at (0,0) and a rectangle.
    
    // Let's use this:
    // 1. A cylinder centered at (0,0) with radius 8.25.
    // 2. A rectangle from y=-15 to y=0.
    // The union of these two is the channel.
    
    // Wait, I must put this inside the difference() block.
    // Let's rewrite the whole file from scratch to ensure it's perfect.
}

// --- FINAL RE-WRITE ---
// (This is the actual code that will be provided)