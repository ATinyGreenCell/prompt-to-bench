// --- Dimensions (mm) ---
block_length = 106;      // X dimension
block_width = 72;        // Y dimension
block_height = 30;       // Z dimension

rows = 4;                // Number of rows along Y
cols = 6;                // Number of columns along X
spacing_x = 16;          // Center-to-center distance X
spacing_y = 16;          // Center-to-center distance Y

hole_diameter = 11.2;    // Diameter of the tube holes
hole_depth = 25;         // Depth of the holes

// --- Internal Calculations ---
// Calculate the total span of the grid to find the starting offset
grid_width = (cols - 1) * spacing_x;
grid_height = (rows - 1) * spacing_y;

// To center the grid on the block:
// The block's center is at (block_length/2, block_width/2).
// The grid's center is at (grid_width/2, grid_height/2).
start_x = (block_length / 2) - (grid_width / 2);
start_y = (block_width / 2) - (grid_height / 2);

// Set resolution for curved surfaces
$fn = 64;

// --- Final Model ---
// The part rests on the XY plane at Z = 0.
// We use a difference() to subtract the holes from the solid block.

difference() {
    // 1. The main rectangular block
    // cube(center=false) starts at [0,0,0] and goes to [L, W, H]
    cube([block_length, block_width, block_height]);

    // 2. The 24 vertical holes
    for (i = [0 : cols - 1]) {
        for (j = [0 : rows - 1]) {
            // Calculate the center position of the current hole
            hole_pos_x = start_x + (i * spacing_x);
            hole_pos_y = start_y + (j * spacing_y);
            
            // The holes are open at the top (Z = block_height)
            // and 25mm deep.
            // The bottom of the hole is at Z = block_height - hole_depth.
            // To ensure a clean cut through the top surface, we extend 
            // the cylinder slightly above the top (Z_start = block_height - hole_depth)
            // and extend it by 0.1mm above the top surface.
            
            translate([hole_pos_x, hole_pos_y, block_height - hole_depth])
            cylinder(h = hole_depth + 0.1, d = hole_diameter);
        }
    }
}

/* 
   Correction Notes:
   1. Fixed the OpenSCAD Warning: The error "variable x/y/z not specified" 
      occurred because I used 'x = variable' inside the translate() 
      function. In OpenSCAD, translate() expects a vector [x, y, z] 
      or named parameters without the 'variable =' syntax in some versions.
      I have changed the translate call to the standard [x, y, z] vector 
      format to ensure compatibility and eliminate warnings.
   2. Verified Centering: The grid is centered on the block.
   3. Verified Z-axis: The block starts at Z=0.
   4. Verified Hole Depth: 30mm (total) - 25mm (hole) = 5mm floor.
*/