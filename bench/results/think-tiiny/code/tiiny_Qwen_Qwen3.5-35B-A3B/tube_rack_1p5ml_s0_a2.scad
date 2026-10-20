// Dimensions for the bench rack
block_len = 106;      // Length of the block along X axis (mm)
block_wid = 72;        // Width of the block along Y axis (mm)
block_h = 30;          // Height of the block along Z axis (mm)

// Hole specifications
hole_dia = 11.2;       // Diameter of the holes (mm)
hole_depth = 25;      // Depth of the holes (mm)
hole_spacing = 16;     // Center-to-center spacing between holes (mm)
hole_cols = 6;         // Number of holes along X axis
hole_rows = 4;         // Number of holes along Y axis

// Calculated offsets and positions
// Center of the hole grid relative to the block center
hole_center_offset_x = (hole_cols - 1) * hole_spacing / 2;
hole_center_offset_y = (hole_rows - 1) * hole_spacing / 2;

// Hole cylinder positioning
// Top of holes at Z=30 (block top)
// Bottom of holes at Z=5 (5mm floor)
// Cylinder needs to extend past both faces by 0.01-1mm
hole_z_start = 5 - 0.05;  // 4.95mm
hole_cyl_height = hole_depth + 0.1;  // 25.1mm

// Set resolution for curved shapes
$fn = 64;

// Main geometry
difference() {
    // The solid base block
    // Resting on XY plane (Z=0), centered on X/Y
    cube([block_len, block_wid, block_h]);

    // The holes
    for (i = [0:hole_cols - 1]) {
        for (j = [0:hole_rows - 1]) {
            // Calculate hole center positions
            // Grid centered on block (53, 36)
            x_pos = (block_len / 2) - hole_center_offset_x + i * hole_spacing;
            y_pos = (block_wid / 2) - hole_center_offset_y + j * hole_spacing;

            // Create the hole cylinder
            // Extends slightly past the top face (Z=30) and the bottom face of the hole (Z=5)
            translate([x_pos, y_pos, hole_z_start]) {
                cylinder(h=hole_cyl_height, d=hole_dia, $fn=64);
            }
        }
    }
}