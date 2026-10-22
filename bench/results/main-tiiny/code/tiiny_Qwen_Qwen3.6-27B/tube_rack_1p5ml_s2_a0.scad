// Dimensions of the main block
block_length = 106; // X
block_width = 72;   // Y
block_height = 30;  // Z

// Hole grid parameters
holes_x = 6;        // Number of holes along X
holes_y = 4;        // Number of holes along Y
hole_spacing_x = 16; // Centre-to-centre spacing X
hole_spacing_y = 16; // Centre-to-centre spacing Y

// Hole dimensions
hole_diameter = 11.2;
hole_depth = 25;

// Quality setting for curved shapes
$fn = 64;

// Main solid block
difference() {
    cube([block_length, block_width, block_height], center = true);
    
    // Drill holes
    for (ix = [0 : holes_x - 1]) {
        for (iy = [0 : holes_y - 1]) {
            // Calculate position relative to center
            x_pos = (ix - (holes_x - 1) / 2) * hole_spacing_x;
            y_pos = (iy - (holes_y - 1) / 2) * hole_spacing_y;
            
            // Translate to hole position and drill
            translate([x_pos, y_pos, block_height / 2 - hole_depth / 2]) {
                // Extend slightly past the floor to ensure clean cut
                cylinder(r = hole_diameter / 2, h = hole_depth + 0.1, center = true);
            }
        }
    }
}