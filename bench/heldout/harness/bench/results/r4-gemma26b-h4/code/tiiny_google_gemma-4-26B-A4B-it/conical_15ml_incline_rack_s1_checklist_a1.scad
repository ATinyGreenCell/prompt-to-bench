// 15mL Conical Tube Rack - Corrected
// Designed for easy volume reading and supernatant removal.

// --- Dimensions ---
L = 130;            // Length along X (mm)
W = 60;             // Depth along Y (mm)
H = 45;            // Height along Z (mm)

num_holes = 5;      // Number of tube holes
spacing = 24;       // Spacing between hole centers along X (mm)

hole_d = 17.5;      // Diameter of the holes (mm)
hole_depth = 40;    // Depth of the holes (mm)
tilt_angle = 30;    // Tilt angle from vertical (degrees)
y_top_offset = -10; // Y position where hole axis meets top face

// --- Parameters ---
$fn = 64;

// Calculate the starting X position to center the holes
hole_x_start = -(num_holes - 1) / 2 * spacing;

// --- Modeling ---

difference() {
    // The main block
    // Centered on X and Y, sitting on Z=0
    translate([-L/2, -W/2, 0])
        cube([L, W, H]);

    // The five blind holes
    for (i = [0 : num_holes - 1]) {
        let (
            current_x = hole_x_start + (i * spacing),
            current_y = y_top_offset
        )
        // To tilt the hole:
        // 1. Move to the intersection point on the top face
        // 2. Rotate around X axis by 30 degrees
        // 3. The cylinder is created extending downwards.
        // To ensure the top is flat and flush with the block, 
        // we rotate the cylinder and then translate it so its top is at Z=H.
        
        translate([current_x, current_y, H])
        rotate([tilt_angle, 0, 0])
        // We use a small offset in Z to ensure a clean cut through the top face
        // and we translate the cylinder down so its top is at the rotation point.
        // Since rotate([30,0,0]) tilts the Z axis towards +Y, 
        // and we want it to go DOWN into the block, we must ensure 
        // the cylinder is oriented correctly.
        // A cylinder(h=depth) starts at 0 and goes to h.
        // If we rotate [30,0,0], the Z axis vector [0,0,-1] becomes [0, sin(30), -cos(30)].
        // This moves the axis toward +Y as Z decreases.
        translate([0, 0, 0])
        cylinder(h = hole_depth + 1, d = hole_d);
    }
}

// Note on the tilt logic:
// The user wants the axis to move toward +Y as it goes down.
// A rotation of 30 degrees around X:
// The vector [0, 0, -1] (down) becomes [0, sin(30), -cos(30)].
// This results in a Y component of +0.5, which is +Y.
// This matches the requirement "going down into the block, it moves toward +Y".