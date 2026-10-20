// Dimensions for 96-well PCR tube rack (0.2 mL tubes)
// Standard ANSI/SLAS microplate footprint

// Block dimensions
block_length = 127.76;   // X dimension (mm)
block_width  = 85.48;    // Y dimension (mm)
block_height = 20.0;     // Z dimension (mm)

// Hole specifications
hole_diameter = 6.2;     // Diameter of each tube hole (mm)
hole_radius   = hole_diameter / 2;

// Grid layout
rows = 8;                // Number of rows (along Y)
cols = 12;               // Number of columns (along X)
spacing_x = 9.0;         // Centre-to-centre spacing in X (mm)
spacing_y = 9.0;         // Centre-to-centre spacing in Y (mm)

// Position of first hole (A1)
a1_offset_x = 14.38;     // Distance from left edge to A1 centre (mm)
a1_offset_y = 11.24;     // Distance from back edge to A1 centre (mm)

// Chamfer specifications
chamfer_leg = 5.0;       // Leg length of 45-degree chamfer at A1 corner (mm)

// Rendering quality
$fn = 64;

// Define the main block
module main_block() {
    translate([-block_length/2, -block_width/2, 0])
        cube([block_length, block_width, block_height]);
}

// Define the hole grid
module hole_grid() {
    for (row = [0 : rows-1]) {
        for (col = [0 : cols-1]) {
            // Calculate hole position relative to block centre
            x_pos = -block_length/2 + a1_offset_x + col * spacing_x;
            y_pos = -block_width/2 + a1_offset_y + row * spacing_y;
            
            // Create through-hole (extends slightly past top and bottom)
            translate([x_pos, y_pos, -0.5])
                cylinder(h = block_height + 1, r = hole_radius, center = false);
        }
    }
}

// Define the chamfer at A1 corner
module chamfer() {
    // A1 corner is at the left-back-top of the block
    // Left edge: x = -block_length/2
    // Back edge: y = -block_width/2
    // Top edge: z = block_height
    
    // Create a triangular prism for the chamfer
    // The chamfer removes material from the corner
    translate([-block_length/2, -block_width/2, block_height]) {
        // Create a cube that will be cut by a plane
        // We'll use a polygon extruded along Y to create the chamfer shape
        linear_extrude(height = chamfer_leg, center = false) {
            // Triangle in XZ plane
            polygon(points = [
                [0, 0],           // Corner point (left-back-top)
                [chamfer_leg, 0], // Along X edge
                [0, -chamfer_leg] // Along Z edge (downward)
            ]);
        }
    }
}

// Assemble the final part
difference() {
    main_block();
    hole_grid();
    chamfer();
}