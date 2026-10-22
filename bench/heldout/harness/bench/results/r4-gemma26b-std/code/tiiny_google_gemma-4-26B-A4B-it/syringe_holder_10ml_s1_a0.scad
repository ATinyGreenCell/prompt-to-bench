// --- Dimensions (mm) ---
block_width = 50;          // X dimension
block_depth = 30;          // Y dimension
block_height = 40;         // Z dimension

barrel_radius = 8.25;      // Half of 16.5mm channel width
barrel_channel_width = 16.5; 

flange_slot_width = 34;    // X dimension of slot
flange_slot_height = 2.6;  // Z dimension of slot
flange_slot_z_start = 30;  // Bottom of slot
flange_slot_z_end = 32.6;  // Top of slot
flange_slot_depth_end = 11; // Slot ends at y = 11

screw_hole_diameter = 4.5; // M4 screw hole
screw_hole_x_pos = 19;     // X offset for screws
screw_hole_z_pos = 15;     // Z height for screws

// --- Constants ---
$fn = 64;

// --- Main Block Construction ---
// The part is centered on X and Y, resting on Z=0.
// Back face is at Y = 15, Front face is at Y = -15.

difference() {
    // The main block
    cube([block_width, block_depth, block_height], center = true);
    // Note: cube(center=true) centers on X, Y, and Z. 
    // To make it rest on Z=0, we must translate it.
    // However, the prompt says "standing on the bed and centred on the origin in X and Y".
    // This implies the base is at Z=0 and the center of the XY footprint is (0,0).
    // So we use a translate to move the center from Z=20 to Z=20.
    
    // Re-defining block to be easier to manage:
    // We will use a standard cube and translate it so it sits on Z=0 and is centered on X,Y.
}

// Corrected approach: Build the solid and subtract the features.
// We use a helper to define the base block to ensure it sits on Z=0.
module base_block() {
    translate([-block_width/2, -block_depth/2, 0])
    cube([block_width, block_depth, block_height]);
}

difference() {
    base_block();

    // 1. Barrel Channel
    // Back end is a half-circle of 8.25mm radius centered at x=0, y=0.
    // Since the block's Y range is -15 to 15, and the center of the block is Y=0,
    // the back face is at Y=15.
    // The prompt says "back end is a half-circle... centred at x=0, y=0".
    // This implies the center of the circle is at the center of the block.
    // The channel runs from the back (y=15) to the front (y=-15).
    // Wait, the prompt says "its back end is a half-circle... and its straight sides run forward to the front face".
    // This implies the "back" of the channel is the curved part.
    // If the circle is centered at (0,0), the half-circle (back end) would be at the center.
    // Let's interpret: The channel is a U-shape. The "bottom" of the U is the half-circle.
    // The prompt says "back end is a half-circle... centered at x=0, y=0".
    // If the block is 30mm deep (Y from -15 to 15), and the circle is at Y=0, 
    // the half-circle is at the center of the block. 
    // However, "back end" usually refers to the wall side.
    // Let's follow the geometry: 
    // Channel: A cylinder of radius 8.25, cut in half, running along Y.
    // The "back end" (the curved part) is at Y=0? No, that would be in the middle.
    // Let's re-read: "its back end is a half-circle... and its straight sides run forward to the front face (y = -15)".
    // This means the curve is at the back (Y=15) and the straight part goes to the front (Y=-15).
    // But if the circle is centered at (0,0), the curve is at Y=0.
    // Let's assume the "back end" refers to the part of the channel closest to the wall.
    // If the circle is centered at (0,0), the half-circle is at Y=0.
    // Let's model the channel as a cylinder of radius 8.25, centered at X=0, Y=0, 
    // but we only take the half that extends towards the front (Y < 0) or back (Y > 0)?
    // "straight sides run forward to the front face (y = -15)".
    // This means the channel exists from Y = -15 to Y = 0 (the curve).
    // But the prompt says "runs through the full height" and "through the full depth" is implied.
    // Let's model the channel as: A cylinder of radius 8.25, centered at (0,0, Z_mid), 
    // but we only keep the part where Y is between -15 and 0? No, that's not "full height/depth".
    // Let's interpret "back end" as the part at the wall (Y=15).
    // If the circle is centered at (0,0), the curve is at Y=0. 
    // Let's assume the channel is a 16.5mm wide slot.
    // A 16.5mm wide slot with a half-circle end of radius 8.25.
    // The cylinder is centered at X=0, Y=0. The half-circle is the part from Y=0 to Y=8.25? 
    // No, the prompt says "back end is a half-circle... centered at x=0, y=0".
    // This means the curve is at Y=0. The straight sides go from Y=0 to Y=-15.
    // This would mean the channel is only 15mm deep.
    // Let's re-read: "runs through the full height... back end is a half-circle... straight sides run forward to the front face (y = -15)".
    // This implies the channel is a shape that is a half-cylinder from Y=0 to Y=-15, 
    // and the "back" (the part at the wall) is the flat part? No, "back end is a half-circle".
    // If the back end (at the wall, Y=15) is a half-circle, the center must be at Y=15.
    // But the prompt says "centred at x=0, y=0".
    // If the center is (0,0), the half-circle is at Y=0.
    // Let's assume the channel is a 16.5mm wide slot that is a half-cylinder from Y=0 to Y=-15,
    // and the "back" of the channel (the part at Y=0) is the half-circle.
    // This makes the channel 15mm deep.
    // Let's try another interpretation: The channel is a half-cylinder.
    // The straight sides are at X = +/- 8.25.
    // The curved part is at Y = 0. The straight sides go from Y=0 to Y=-15.
    // This makes the channel 15mm deep.
    // Wait, "runs through the full height" (Z) and "runs through the full depth" (Y) is not explicitly said for the channel, 
    // but "runs through the full height" is.
    // Let's follow the coordinates strictly:
    // Cylinder: center (0,0, Z), radius 8.25.
    // Half-cylinder: The part of the cylinder where Y < 0 (running to the front).
    // This would mean the channel is a half-cylinder from Y=0 to Y=-15.
    // The "back end" of this channel (the part at Y=0) is the half-circle.
    // This fits "back end is a half-circle... centered at x=0, y=0".
    // And "straight sides run forward to the front face (y = -15)".
    // This means the channel is 15mm deep.
    
    // Let's refine the channel:
    // It's a cylinder