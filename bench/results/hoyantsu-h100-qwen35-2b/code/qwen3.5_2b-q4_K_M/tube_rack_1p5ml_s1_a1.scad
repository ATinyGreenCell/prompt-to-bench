// --- Dimensions in millimeters ---
block_length = 106.0; // X
block_width  = 72.0;  // Y
block_height = 30.0;  // Z

hole_diameter = 11.2;
hole_depth   = 25.0;
floor_thickness = 5.0;

// --- Geometry Setup ---
// Create the main rectangular block
main_block = cube([block_length, block_width, block_height]);

// Define hole parameters for the grid
num_rows     = 4;       // Along Y (vertical in print)
holes_per_row = 6;      // Along X
hole_spacing_x = 16.0;   // Center-to-center along X
hole_spacing_y = 16.0;   // Center-to-center along Y

// Create the hole grid using a loop
for(h = 0; h < num_rows; h++) {
    for(i = 0; i < holes_per_row; i++) {
        // Calculate center coordinates of each hole relative to block origin
        x_center = (i * hole_spacing_x) + (block_length / 2.0);
        y_center = (h * hole_spacing_y) + (block_width / 2.0);

        // Create a hollow cylinder for the hole
        // Radius is half of diameter
        r = hole_diameter / 2.0;
        
        // Extrude upwards from floor level to top
        // Floor thickness is subtracted, so we start at floor_thickness/2 and go up
        height_from_floor = block_height - (floor_thickness * 2);
        extrude(height_from_floor) cylinder(r, r, hole_depth);

        // Rotate the hole grid 90 degrees around Z axis to align with bench orientation
        rotate_extrude(90) main_block;
    }
}

// Finalize the part by rotating it back so it sits flat on the XY plane (bench top)
rotate_extrude(-90) main_block;