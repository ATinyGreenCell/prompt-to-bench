// 15mL Conical Tube Rack
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
// For 5 holes with 24mm spacing: -48, -24, 0, 24, 48
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
        // 1. We translate to the entry point (x_pos, entry_y, H).
        // 2. We rotate the coordinate system so the Z-axis tilts 30 degrees towards +Y.
        //    Rotating around X by 30 degrees makes the new Z-axis [0, sin(30), -cos(30)].
        //    This vector points "down and forward" into the block.
        // 3. We create a cylinder starting at the origin (the entry point) 
        //    extending along this new Z-axis.
        
        translate([x_pos, entry_y, H])
        rotate([0, tilt_angle, 0])
        // We use a small epsilon (0.01) to ensure the cylinder cuts through the top face
        cylinder(h = hole_depth + 0.01, d = hole_d);
    }
}