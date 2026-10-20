// Bench rack for 1.5 mL microcentrifuge tubes
// Dimensions and parameters
block_length = 106;    // X: length of block (mm)
block_width  = 72;     // Y: width of block (mm)
block_height = 30;     // Z: height of block (mm)
hole_diameter = 11.2;  // Diameter of each hole (mm)
hole_depth = 25;       // Depth of each hole (mm)
floor_thickness = 5;   // Thickness of solid floor (mm)
hole_pitch_x = 16;     // Centre-to-centre spacing in X direction (mm)
hole_pitch_y = 16;     // Centre-to-centre spacing in Y direction (mm)
rows = 4;              // Number of rows (along Y)
cols = 6;              // Number of columns (along X)

// Derived calculations
hole_height = block_height - floor_thickness; // Height of hole from bottom
hole_z = floor_thickness; // Z position of hole top

// Calculate grid offset to centre the hole pattern
grid_width_x = (cols - 1) * hole_pitch_x;
grid_width_y = (rows - 1) * hole_pitch_y;
offset_x = (block_length - grid_width_x) / 2;
offset_y = (block_width - grid_width_y) / 2;

// Block base
module block_base() {
    cube([block_length, block_width, block_height]);
}

// Single hole
module single_hole(x, y) {
    translate([x, y, hole_z - 0.01]) {
        cylinder(h = hole_depth + 0.02, r = hole_diameter / 2, $fn = 64);
    }
}

// Generate all holes
module holes() {
    for (i = [0 : cols - 1]) {
        for (j = [0 : rows - 1]) {
            x = offset_x + i * hole_pitch_x;
            y = offset_y + j * hole_pitch_y;
            single_hole(x, y);
        }
    }
}

// Build the rack
difference() {
    block_base();
    holes();
}