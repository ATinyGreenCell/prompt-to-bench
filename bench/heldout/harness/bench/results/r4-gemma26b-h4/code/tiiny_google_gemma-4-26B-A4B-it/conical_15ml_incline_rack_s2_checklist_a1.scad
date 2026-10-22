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
        let (x_pos = hole_x_start + (i * spacing)) = 
        translate([x_pos, y_offset, H]) 
        // To tilt the hole 30 degrees from vertical (Z) towards +Y,
        // we rotate around the X axis. 
        // A positive rotation around X moves the +Z axis towards the +Y axis.
        rotate([30, 0, 0])
            // We translate the cylinder down by 0.01 to ensure a clean cut through the top face
            // and extend the height by 0.01 to ensure it cuts through the bottom if necessary.
            translate([0, 0, -0.01]) 
                cylinder(h = hole_depth + 0.01, d = hole_d);
    }
}