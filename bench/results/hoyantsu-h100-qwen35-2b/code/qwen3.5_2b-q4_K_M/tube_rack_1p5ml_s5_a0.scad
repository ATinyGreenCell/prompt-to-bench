// Design parameters for bench rack with 1.5 mL microcentrifuge tubes
// All dimensions in millimeters

// Block dimensions (X, Y, Z)
block_length = 106; // mm
block_width   = 72;  // mm
block_height  = 30;  // mm

// Hole grid parameters
num_rows     = 4;    // holes along Y axis
holes_per_row = 6;   // holes along X axis
hole_center_y = 18.0; // mm (center of block width / 2)
hole_spacing_x = 16.0; // mm center-to-center in X
hole_spacing_y = 16.0; // mm center-to-center in Y

// Hole geometry parameters
hole_diameter = 11.2; // mm
hole_depth    = 25.0; // mm
floor_thickness = 5.0; // mm (solid floor at bottom)

// Floor dimensions (X, Y) - centered on block
floor_length   = block_length - 2 * hole_spacing_x;
floor_width    = block_width - 2 * hole_spacing_y;

// Create the solid block
block = cube([block_length, block_width, block_height]);

// Define a function to create a single tube slot
create_slot = function(x_start, y_start) {
    // The slot is defined by the floor thickness and depth.
    // We extrude from z=0 (floor bottom) to z=hole_depth.
    // However, we need to ensure the cut extends past faces as per rule 5.
    
    // Create a polygon for the hole cross-section at the current position
    // The floor is solid, so the hole starts at z = floor_thickness
    // and goes down to z = floor_thickness + hole_depth
    
    // We use rotate_extrude with a large offset (0.1 mm) to ensure faces are not coplanar
    // as requested in rule 5.
    
    return rotate_extrude([hole_diameter, block_height], 
                         [x_start - 0.1, y_start - 0.1, floor_thickness + hole_depth], 
                         [x_start + hole_diameter/2, y_start + hole_diameter/2, 0]);
};

// Create the grid of holes using a loop
for (i = 0; i < num_rows; i++) {
    for (j = 0; j < holes_per_row; j++) {
        // Calculate positions relative to block center
        x_pos = (block_length / 2) - (holes_per_row * hole_spacing_x / 2);
        y_pos = (block_width / 2) - (num_rows * hole_spacing_y / 2);
        
        create_slot(x_pos, y_pos);
    }
}

// Final assembly: union of block and all slots
bench_rack = union([block, bench_rack]);

// Optional: Add a small top cap to prevent tube sticking out if desired, 
// but the prompt implies just the rack body. The current design leaves the top open.