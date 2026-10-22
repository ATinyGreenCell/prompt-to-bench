// Bench rack for 1.5 mL microcentrifuge tubes
// Solid block with 24 vertical holes (4 rows x 6 columns)

// Block dimensions
block_length = 106;   // X
block_width  = 72;    // Y
block_height = 30;    // Z

// Hole grid parameters
rows = 4;             // along Y
cols = 6;             // along X
pitch = 16;           // centre-to-centre spacing in both X and Y

// Hole dimensions
hole_diameter = 11.2;
hole_depth    = 25;   // open at top, closed at bottom
floor_height  = 5;    // solid floor (block_height - hole_depth = 30 - 25 = 5)

// Grid extents (centre-to-centre span)
grid_span_x = (cols - 1) * pitch;  // 5 * 16 = 80
grid_span_y = (rows - 1) * pitch;  // 3 * 16 = 48

// Hole centre positions (grid centred on origin in X and Y)
hole_x = [for (i = [0:cols-1]) -grid_span_x/2 + i * pitch];
hole_y = [for (j = [0:rows-1]) -grid_span_y/2 + j * pitch];

// Hole top is at z = block_height, bottom at z = floor_height
hole_top_z = block_height;
hole_bottom_z = floor_height;

// Build the rack
$fn = 64;

difference() {
    // Solid rectangular block
    translate([-block_length/2, -block_width/2, 0])
        cube([block_length, block_width, block_height]);

    // Cut 24 vertical holes
    for (x = hole_x) {
        for (y = hole_y) {
            // Each hole: cylinder from z = hole_bottom_z to z = hole_top_z + 1 (extend 1 mm past top face)
            translate([x, y, hole_bottom_z])
                cylinder(h = hole_depth + 1, d = hole_diameter);
        }
    }
}