// Bench rack for 1.5 mL microcentrifuge tubes
// Dimensions measured with calipers

// Block dimensions
block_length = 106;   // X dimension (mm)
block_width  = 72;    // Y dimension (mm)
block_height = 30;    // Z dimension (mm)

// Hole grid parameters
holes_x      = 6;     // Number of holes along X
holes_y      = 4;     // Number of holes along Y
hole_spacing = 16;    // Centre-to-centre spacing (mm) in both X and Y
hole_dia     = 11.2;  // Hole diameter (mm)
hole_depth   = 25;    // Hole depth (mm)
floor_thick  = 5;     // Solid floor thickness (mm)

// Derived values for centering the grid
grid_width_x = (holes_x - 1) * hole_spacing;
grid_width_y = (holes_y - 1) * hole_spacing;
offset_x     = (block_length - grid_width_x) / 2;
offset_y     = (block_width  - grid_width_y) / 2;

// Render quality for curved shapes
$fn = 64;

// Main block
difference() {
    // Solid base block
    translate([-block_length/2, -block_width/2, 0])
        cube([block_length, block_width, block_height]);

    // Hole cuts
    for (i = [0 : holes_x - 1]) {
        for (j = [0 : holes_y - 1]) {
            // Calculate hole position
            cx = -block_length/2 + offset_x + i * hole_spacing;
            cy = -block_width/2  + offset_y  + j * hole_spacing;
            
            // Cylinder cut: extends slightly past the bottom to ensure clean cut
            translate([cx, cy, -0.01])
                cylinder(h = hole_depth + 0.01, r = hole_dia/2, center = false);
        }
    }
}