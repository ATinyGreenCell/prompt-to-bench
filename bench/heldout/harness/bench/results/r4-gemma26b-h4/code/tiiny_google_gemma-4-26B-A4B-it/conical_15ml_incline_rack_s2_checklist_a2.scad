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
        // Calculate X position for this specific hole
        x_pos = hole_x_start + (i * spacing);
        
        // We move to the top face (Z = H) and the specified Y offset.
        // Then we rotate the cylinder. 
        // To tilt 30 degrees from vertical (Z) towards +Y, we rotate around the X axis.
        // In OpenSCAD, a positive rotation around X moves the Z axis towards the Y axis.
        translate([x_pos, y_offset, H]) 
        rotate([30, 0, 0])
            // We use a cylinder to represent the hole.
            // To ensure the bottom is flat and perpendicular to the axis, 
            // we use a cylinder of the specified depth.
            // We translate it slightly in Z to ensure it cuts through the top face cleanly.
            translate([0, 0, -0.01]) 
                cylinder(h = hole_depth + 0.01, d = hole_d);
    }
}