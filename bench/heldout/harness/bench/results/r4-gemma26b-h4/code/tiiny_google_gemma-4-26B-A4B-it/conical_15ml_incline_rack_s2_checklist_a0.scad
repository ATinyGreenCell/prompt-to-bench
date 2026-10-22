// 15mL Conical Tube Rack
// Designed for volume reading and pipetting.
// Features 5 holes tilted 30 degrees in the YZ plane.

// Dimensions
L = 130;             // Length along X (mm)
W = 60;              // Depth along Y (mm)
H = 45;              // Height along Z (mm)

num_holes = 5;       // Number of tube holes
spacing = 24;        // Spacing between hole centers along X (mm)
hole_d = 17.5;       // Diameter of the holes (mm)
hole_depth = 40;     // Depth of the holes along their axis (mm)

tilt_angle = 30;     // Tilt angle from vertical (degrees)
y_offset = -10;      // Y-coordinate where the hole axis meets the top face

$fn = 64;

// Calculation for centering the holes along X
// The holes are centered on the block, so the first hole is at -(spacing * (num_holes-1)/2)
hole_x_start = -(spacing * (num_holes - 1) / 2);

module tube_hole() {
    // The hole is a cylinder. To make the bottom flat and perpendicular to the axis,
    // we use a cylinder. To ensure it's a "blind hole" with a flat bottom, 
    // we define the cylinder height and rotate it.
    // Since the user wants the axis to meet the top face at y = -10, 
    // and the block is centered on Y, the top face is at Z = H/2.
    // However, the prompt says "standing on the bed and centred on the origin in X and Y".
    // This implies the base is at Z=0 and the top is at Z=45.
    // The prompt says "axis meets the top face at y = -10". 
    // In OpenSCAD, if the block is centered on Y, Y ranges from -30 to +30.
    // If the axis meets the top face at Y = -10, it is 20mm from the center.
    
    // We will model the hole as a cylinder and rotate it.
    // The axis is tilted 30 degrees from vertical in the YZ plane.
    // "Going down into the block, it moves toward +Y" means the tilt direction is +Y.
    // Vertical is Z. Tilt 30 deg from Z towards +Y.
    // Rotation: rotate([30, 0, 0]) would tilt around X. 
    // To tilt in YZ plane, we rotate around X.
    // A 30 degree tilt from vertical (Z) towards +Y means the axis vector is (0, sin(30), -cos(30)).
    
    rotate([30, 0, 0]) 
        cylinder(h = hole_depth + 1, d = hole_d);
}

// The block is centered on X and Y, sitting on Z=0.
// X range: [-65, 65]
// Y range: [-30, 30]
// Z range: [0, 45]

difference() {
    // The main block
    translate([-L/2, -W/2, 0])
        cube([L, W, H]);

    // The holes
    for (i = [0 : num_holes - 1]) {
        let (x_pos = hole_x_start + (i * spacing)) = 
        translate([x_pos, y_offset, H]) // Move to top face and the specified Y offset
        rotate([0, 0, 0]) // Placeholder for clarity
        // We need to tilt the hole. The prompt says "axis meets the top face at y = -10".
        // If the hole is tilted 30 degrees from vertical towards +Y, the rotation 
        // is around the X axis.
        // A rotation of 30 degrees around X: 
        // New Z = Z * cos(30) - Y * sin(30)
        // New Y = Z * sin(30) + Y * cos(30)
        // To tilt "down and towards +Y", we rotate the Z-axis cylinder around X.
        // A positive rotation around X moves +Z towards +Y.
        rotate([30, 0, 0])
            translate([0, 0, -1]) // Ensure it cuts through the top face
                cylinder(h = hole_depth + 1, d = hole_d);
    }
}

// Note on the rotation: 
// The prompt says: "axis meets the top face at y = -10 and is tilted 30 degrees from vertical in the YZ plane: going down into the block, it moves toward +Y."
// If we rotate the cylinder around the X axis by 30 degrees:
// The Z axis vector [0,0,1] becomes [0, sin(30), cos(30)].
// This means as Z decreases (going into the block), Y increases.
// This matches "moves toward +Y".