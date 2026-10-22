// Dimensions for 96 PCR tube rack (ANSI/SLAS footprint)
// All units in millimetres (mm)

// Block dimensions
block_length = 127.76;   // X dimension (length)
block_width = 85.48;     // Y dimension (width)
block_height = 20.0;     // Z dimension (height)

// Hole specifications
hole_diameter = 6.2;    // Diameter of PCR tube holes
hole_radius = hole_diameter / 2;

// Grid layout
rows = 8;                // Number of rows (along Y)
cols = 12;               // Number of columns (along X)
pitch_x = 9.0;           // Center-to-center spacing in X (mm)
pitch_y = 9.0;           // Center-to-center spacing in Y (mm)

// Position of first hole (A1) relative to block edges
// Distance from left edge (X=0) to first hole center
offset_x = 14.38;
// Distance from back edge (Y=0) to first hole center
offset_y = 11.24;

// Chamfer dimensions
chamfer_leg = 5.0;      // Length of chamfer legs (mm)

// Ensure high resolution for round holes
$fn = 64;

// Main block
module main_block() {
    // Center the block on origin in X and Y
    translate([-block_length/2, -block_width/2, 0]) {
        cube([block_length, block_width, block_height]);
    }
}

// Create the grid of holes
module holes_grid() {
    // Calculate hole positions
    // The block is centered at 0,0.
    // Left edge is at -block_length/2.
    // First hole X center = -block_length/2 + offset_x
    // First hole Y center = -block_width/2 + offset_y
    
    for (i = [0 : cols-1]) {
        for (j = [0 : rows-1]) {
            hole_x = -block_length/2 + offset_x + i * pitch_x;
            hole_y = -block_width/2 + offset_y + j * pitch_y;
            
            translate([hole_x, hole_y, 0]) {
                // Cylinder extends slightly past the block to ensure clean cut
                cylinder(h = block_height + 0.1, r = hole_radius, center = true);
            }
        }
    }
}

// Create the 45-degree chamfer at the A1 corner
// A1 corner is the bottom-left corner of the block (X negative, Y negative).
// We subtract a triangular prism that cuts the corner.
module chamfer_corner() {
    // Define the triangular prism to subtract
    // The corner is at (-block_length/2, -block_width/2)
    // We cut a triangle with legs of chamfer_leg along X and Y axes.
    // The triangle vertices in local coordinates (relative to corner):
    // (0, 0), (chamfer_leg, 0), (0, chamfer_leg)
    // We extrude this to the full height of the block.
    
    // Create the base triangle
    polygon([[0, 0], [chamfer_leg, 0], [0, chamfer_leg]]);
    
    // Extrude to full height
    linear_extrude(height = block_height) {
        polygon([[0, 0], [chamfer_leg, 0], [0, chamfer_leg]]);
    }
}

// Main assembly
union() {
    main_block();
    // Subtract the holes
    difference() {
        main_block();
        holes_grid();
    }
    // Subtract the chamfer
    difference() {
        main_block();
        chamfer_corner();
    }
}