// Design for 96 PCR tubes (0.2 mL) microplate rack
// Dimensions in millimeters

// Define the physical block dimensions based on standard ANSI/SLAS specifications
block_size_X = 127.76; // Length along X axis
block_size_Y = 85.48;  // Width along Y axis
block_height_Z = 20.0; // Height of the rack

// Define hole parameters
hole_diameter_mm = 6.2;
hole_rows = 8;        // Along Y axis (rows)
hole_cols = 12;       // Along X axis (columns)
hole_spacing_mm = 9.0; // Center-to-center spacing between holes
corner_chamfer_deg = 45; // Chamfer angle at A1 corner

// Calculate grid parameters to ensure perfect alignment with the block center
// Grid starts at half a hole diameter from the edge, then adds spacing
grid_start_x_mm = (block_size_X / 2) - (hole_diameter_mm / 2);
grid_start_y_mm = (block_size_Y / 2) - (hole_diameter_mm / 2);

// Calculate total grid extent to define the cutout area
total_grid_width_mm = hole_spacing_mm * (hole_cols + 1);
total_grid_height_mm = hole_spacing_mm * (hole_rows + 1);

// Define chamfer geometry for orientation mark at A1 corner
chamfer_leg_mm = 5.0; // Legs of the chamfer
chamfer_depth_mm = 2.0; // Depth of the chamfer cut into the block edge

// Create the main block (the rack body)
block = cube([block_size_X, block_size_Y, block_height_Z]);

// Create the grid of holes using a for loop
for(hole_idx = 1 to hole_cols) {
    // Calculate position along X and Y axes
    pos_x_mm = grid_start_x_mm + (hole_spacing_mm * (hole_idx - 1));
    pos_y_mm = grid_start_y_mm + (hole_spacing_mm * (hole_rows - hole_idx));

    // Create a cylinder for each hole
    hole = cylinder([hole_diameter_mm, 0.5]); // Radius is diameter/2
    
    // Translate the hole to its specific position on the block surface
    translate([pos_x_mm, pos_y_mm, 0]) rotate_extrude(hole);

    // Add a small gap between holes (optional but good for print quality)
    if(hole_idx < hole_cols) {
        translate([hole_spacing_mm, 0.5, 0]) rotate_extrude(hole);
    }
}

// Create the chamfer at corner A1 (bottom-left-front relative to block orientation)
// The user specified "A1" as the first hole's position. 
// In standard microplate notation, this is typically bottom-left or top-left depending on convention.
// Assuming standard matrix indexing where A1 is row 1, col 1.
// We cut from the corner of the block towards the center to create a chamfer.

chamfer = polygon([
    [0, chamfer_depth_mm], // Bottom edge of chamfer depth
    [block_size_X - chamfer_leg_mm, chamfer_depth_mm], // Right edge (relative to start point)
    [block_size_X - chamfer_leg_mm, 0]                // Top edge of chamfer depth
]);

// Translate the chamfer polygon so its origin is at the corner A1 on the block surface.
// Since we are cutting into the block, we need to move the polygon inward by half the leg length 
// and adjust coordinates based on the block's orientation (X=Length, Y=Width).
// The corner is effectively at (block_size_X/2 - chamfer_leg_mm, block_size_Y/2 - chamfer_depth_mm) relative to the center.
translate([block_size_X / 2 - chamfer_leg_mm, block_size_Y / 2 - chamfer_depth_mm]) rotate_extrude(chamfer);

// Final assembly: Union all parts (Block + Holes + Chamfer)
final_part = union(block, hole, chamfer);

// Print orientation settings
print_settings([
    "orientation", [0, 0, 1], // Default print orientation
    "material", "PLA"         // Common FDM material for biology labs
]);

print("Part dimensions: X=" + block_size_X_mm + ", Y=" + block_size_Y_mm + ", Z=" + block_height_Z + " mm");
print("Holes: 96 total, 8x12 grid");
print("Chamfer leg length: 5.0 mm");