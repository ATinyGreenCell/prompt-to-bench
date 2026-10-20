// Bench rack for 1.5 mL microcentrifuge tubes
// Dimensions measured with calipers, units in millimetres

// Overall block dimensions
block_length = 106;  // X dimension
block_width = 72;    // Y dimension
block_height = 30;   // Z dimension

// Hole grid dimensions
rows_count = 4;      // Number of rows along Y
cols_count = 6;      // Number of columns along X
hole_pitch_x = 16; // Centre-to-centre spacing in X
hole_pitch_y = 16; // Centre-to-centre spacing in Y

// Hole dimensions
hole_diameter = 11.2;
hole_depth = 25;
floor_thickness = 5;

// Calculate grid centering offsets
// Total grid width = (cols_count - 1) * pitch_x
// Total grid height = (rows_count - 1) * pitch_y
grid_width = (cols_count - 1) * hole_pitch_x;
grid_height = (rows_count - 1) * hole_pitch_y;

offset_x = (block_length - grid_width) / 2;
offset_y = (block_width - grid_height) / 2;

// Hole radius
hole_radius = hole_diameter / 2;

// Define the base block
module base_block() {
    translate([offset_x, offset_y, 0])
        cube([block_length, block_width, block_height], center = false);
}

// Define a single hole cylinder
// Extends slightly past the bottom to ensure clean cut (Rule 5)
module single_hole(x_pos, y_pos) {
    translate([x_pos, y_pos, 0])
        cylinder(h = hole_depth + 0.01, r = hole_radius, $fn = 64);
}

// Main assembly
// We use a single difference operation: Base Block minus all Holes
union() {
    // The base block
    base_block();
    
    // The holes are subtracted from the base block in the difference operation below
    // We create a union of all holes to subtract them all at once
    difference() {
        base_block();
        
        // Generate hole grid
        for (i = [0 : cols_count - 1]) {
            for (j = [0 : rows_count - 1]) {
                x_pos = offset_x + i * hole_pitch_x;
                y_pos = offset_y + j * hole_pitch_y;
                single_hole(x_pos, y_pos);
            }
        }
    }
}