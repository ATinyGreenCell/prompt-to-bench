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
flange_slot_depth_back = 11; // How far back the slot goes from front face (y = -15 + 11 = -4)
// Note: The prompt says "cut in from the front face back to y = 11". 
// In a coordinate system where front is y = -15 and back is y = 15, 
// "back to y = 11" means the slot extends from y = -15 to y = 11.

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
    // This means the void is a rectangle from y=-15 to y=0, 
    // and a semi-circle centered at (0,0) extending into the positive Y space.
    union() {
        // Rectangular part: x=[-8.25, 8.25], y=[-15, 0]
        translate([-barrel_radius, -15 - 0.1, -0.1])
        cube([barrel_channel_width, 15.1, block_height + 0.2]);
        
        // Semi-circular part: centered at (0,0), radius 8.25, extending to y=8.25
        // We create a full cylinder and use a cube to cut it in half (keeping y > 0)
        translate([0, 0, -0.1])
        rotate([90, 0, 0])
        intersection() {
            cylinder(r = barrel_radius, h = block_height + 0.2);
            translate([-barrel_radius, 0, -0.1])
            cube([barrel_channel_width, barrel_radius + 0.1, block_height + 0.2]);
        }
    }

    // 3. The Flange Slot
    // "34 mm wide (X, centred) and 2.6 mm tall (z = 30 to 32.6), cut in from the front face back to y = 11"
    translate([-flange_slot_width/2, -15 - 0.1, flange_slot_z_start - 0.1])
    cube([flange_slot_width, 11 - (-15) + 0.2, flange_slot_height + 0.2]);

    // 4. Screw Holes
    // "Two 4.5 mm holes... go straight through from front to back (along Y) at x = -19 and 19, z = 15"
    // Note: The prompt says x = -19 and 19. However, the block width is 50 (x from -25 to 25).
    // If the holes are at x = 19 and -19, they are inside the block.
    // If the holes are at x = -19 and 19, they are inside the block.
    // Wait, the prompt says "at x = -19 and 19". 
    // But the block is 50mm wide. x=19 is inside.
    // Let's check the math: x = -19 and 19 are within [-25, 25].
    // However, the prompt says "at x = -19 and 19". 
    // If the holes are at x = -19 and 19, they are 19mm from center.
    // Let's use the values provided.
    for (x_pos = [-19, 19]) {
        translate([x_pos, -15 - 0.1, screw_hole_z])
        rotate([0, 90, 0])
        cylinder(d = screw_hole_dia, h = block_depth + 0.2);
    }
}