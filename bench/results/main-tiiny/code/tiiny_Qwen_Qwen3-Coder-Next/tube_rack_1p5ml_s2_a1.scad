// Bench rack for 1.5 mL microcentrifuge tubes
// Dimensions and parameters
block_length = 106;    // X dimension (mm)
block_width  = 72;     // Y dimension (mm)
block_height = 30;     // Z dimension (mm)
hole_diameter = 11.2;  // Hole diameter (mm)
hole_depth = 25;       // Hole depth (mm)
floor_thickness = 5;   // Solid floor thickness (mm)
rows = 4;              // Number of rows (along Y)
cols = 6;              // Number of columns (along X)
hole_pitch_x = 16;     // Centre-to-centre spacing in X (mm)
hole_pitch_y = 16;     // Centre-to-centre spacing in Y (mm)

// Calculate hole positions (centred on block)
// Grid dimensions
grid_width_x = (cols - 1) * hole_pitch_x;  // 5 * 16 = 80 mm
grid_width_y = (rows - 1) * hole_pitch_y;  // 3 * 16 = 48 mm

// Block is created from (0,0,0) to (block_length, block_width, block_height)
// So block centre is at (block_length/2, block_width/2, block_height/2)
block_centre_x = block_length / 2;  // 53 mm
block_centre_y = block_width / 2;   // 36 mm

// First hole position (bottom-left of grid)
first_hole_x = block_centre_x - grid_width_x / 2;  // 53 - 40 = 13 mm
first_hole_y = block_centre_y - grid_width_y / 2;  // 36 - 24 = 12 mm

// Set resolution for smooth curves
$fn = 64;

module block_with_holes() {
    difference() {
        // Base block - positioned from (0,0,0)
        cube([block_length, block_width, block_height]);
        
        // Cut holes
        for (i = [0 : cols - 1]) {
            for (j = [0 : rows - 1]) {
                // Calculate hole position
                hole_x = first_hole_x + i * hole_pitch_x;
                hole_y = first_hole_y + j * hole_pitch_y;
                
                // Translate hole to position and extend through block + extra
                translate([hole_x, hole_y, 0]) {
                    cylinder(h = block_height + 1, r = hole_diameter / 2, center = false);
                }
            }
        }
    }
}

// Build the rack
block_with_holes();