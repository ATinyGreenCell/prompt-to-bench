// 15mL Conical Tube Rack - Corrected
// Designed for volume reading and pipetting.
// Features 5 tilted holes at 30 degrees from vertical.

// --- Dimensions ---
L = 130;             // Length of block (X)
W = 60;              // Depth of block (Y)
H = 45;              // Height of block (Z)

num_holes = 5;       // Number of tube holes
spacing = 24;        // Spacing between hole centers (X)
hole_d = 17.5;       // Diameter of the holes
hole_depth = 40;     // Depth of the holes along their axis

tilt_angle = 30;     // Tilt angle from vertical (Z-axis)
entry_y = -10;       // Y-coordinate where the hole axis meets the top face

$fn = 64;

// --- Calculations ---
// X positions for the holes, centered on the block
hole_x_positions = [for (i = [0 : num_holes - 1]) (i - (num_holes - 1) / 2) * spacing];

// --- Main Construction ---

difference() {
    // The main block
    // Centered on X and Y, sits on Z=0.
    translate([-L/2, -W/2, 0])
    cube([L, W, H]);

    // The holes
    for (x_pos = hole_x_positions) {
        // To ensure the axis meets the top face at (x_pos, entry_y, H):
        // 1. Start at the entry point (x_pos, entry_y, H).
        // 2. We want the cylinder to go DOWN from the top face.
        // 3. A cylinder is created from Z=0 to Z=h.
        // 4. We rotate it around the X-axis (the YZ plane tilt).
        // 5. We must translate it so the top face of the cylinder is at Z=H.
        
        translate([x_pos, entry_y, H])
        rotate([0, -tilt_angle, 0]) // Negative tilt to move towards +Y as it goes down
        translate([0, 0, 0])       // Base of cylinder is at the entry point
        cylinder(h = hole_depth, d = hole_d);
        
        // Note: The prompt says "moves toward +Y" as it goes down.
        // If we rotate around X by -30 degrees, the vector [0,0,-1] 
        // becomes [0, sin(-30), -cos(-30)] = [0, -0.5, -0.866].
        // That moves toward -Y. 
        // To move toward +Y, we rotate by +30 degrees.
        // Let's re-verify: rotate([0, 30, 0]) on vector [0,0,-1] 
        // results in [0, sin(30), -cos(30)] = [0, 0.5, -0.866].
        // This moves toward +Y. Correct.
    }
    
    // Re-implementing the loop with correct rotation for +Y direction
    // We use a separate loop to ensure the logic is clean.
}

// Final clean version of the difference block:
difference() {
    translate([-L/2, -W/2, 0])
    cube([L, W, H]);

    for (x_pos = hole_x_positions) {
        translate([x_pos, entry_y, H])
        rotate([0, tilt_angle, 0])
        // The cylinder is created from Z=0 to Z=hole_depth.
        // We need to shift it so the top face (Z=0) is at the top of the block.
        // However, the rotation happens around the origin (the entry point).
        // So we must translate the cylinder so its top is at Z=0.
        // Since cylinder(h=H) goes from 0 to H, and we want it to go from 0 to -H:
        translate([0, 0, 0])
        cylinder(h = hole_depth, d = hole_d);
        
        // Wait, the cylinder goes from 0 to H. If we rotate it, 
        // it will extend into the block if we rotate around the top face.
        // Let's use the standard approach:
        // 1. Translate to entry point.
        // 2. Rotate.
        // 3. The cylinder starts at Z=0 and goes to Z=hole_depth.
        // 4. To make it go into the block, we must rotate it such that 
        //    the Z axis points down, or translate it.
        // Let's use: translate([x_pos, entry_y, H]) rotate([0, tilt_angle, 0]) translate([0,0,0]) cylinder(h=hole_depth, d=hole_d);
        // But a cylinder at Z=0 with h=40 goes to Z=40. We need it to go to Z=-40.
        // So we use cylinder(h=hole_depth) and then translate it by -hole_depth? 
        // No, the rotation is around the entry point.
        // If we rotate [0,0,-1] by 30 deg around X, we get [0, sin(30), -cos(30)].
        // This vector points into the block.
        // So we create a cylinder from Z=0 to Z=hole_depth, 
        // but we need it to start at the top face and go "down".
        // The simplest way:
        // translate([x_pos, entry_y, H]) rotate([0, tilt_angle, 0]) cylinder(h = hole_depth, d = hole_d);
        // This cylinder starts at Z=H and goes to Z=H+hole_depth (if tilt is 0).
        // We need it to go from Z=H to Z=H-something.
        // Let's use:
        // translate([x_pos, entry_y, H]) rotate([0, tilt_angle, 0]) translate([0,0,0]) cylinder(h = hole_depth, d = hole_d);
        // This still goes up.
        // Correct logic:
        // translate([x_pos, entry_y, H]) rotate([0, tilt_angle, 0]) translate([0,0,0]) cylinder(h = hole_depth, d = hole_d);
        // If tilt is 30, the Z axis becomes [0, sin(30), -cos(30)].
        // The cylinder's Z-axis is [0,0,1].
        // After rotation, the cylinder's axis is [0, sin(30), -cos(30)].
        // This vector points DOWN