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
floor_thickness = 5;     // Thickness of the bottom solid part

// --- Internal Calculations ---
// Calculate the starting position to ensure the grid is centered
grid_width = (cols - 1) * spacing_x;
grid_height = (rows - 1) * spacing_y;

start_x = -(grid_width / 2);
start_y = -(grid_height / 2);

// Set resolution for curved surfaces
$fn = 64;

// --- Final Model ---
difference() {
    // The main rectangular block
    cube([block_length, block_width, block_height], center = true);

    // Create the holes
    // We use a nested loop to create the 4x6 grid
    for (i = [0 : cols - 1]) {
        for (j = [0 : rows - 1]) {
            // Calculate position for this specific hole
            // We add 0.01 to the Z translation to ensure it cuts through the top
            // We subtract the depth from the top surface
            // Since the cube is centered, the top surface is at Z = block_height/2
            
            translate(
                x = start_x + (i * spacing_x), 
                y = start_y + (j * spacing_y), 
                z = (block_height / 2) - hole_depth + 0.01 // Offset to ensure clean cut
            )
            cylinder(h = hole_depth + 0.1, d = hole_diameter);
        }
    }
}

// Note on Orientation:
// The block is centered on X and Y. 
// The bottom face of the block is at Z = -15 (half of 30).
// To print this resting on the XY plane at Z=0, 
// the user should translate the final object by [0, 0, 15] 
// or simply print as rendered if the slicer handles the offset.
// Per instructions, the block is centered on X/Y and rests on XY plane at Z=0.
// To achieve "rests on XY plane at Z=0" while being "centered on X and Y",
// we must translate the entire object up by half its height.

translate([0, 0, block_height/2]) {
    // This is a conceptual wrapper; the code above is the geometry.
    // To strictly follow "rests on XY plane at Z=0", 
    // we wrap the logic in a translate.
}

// Re-writing the structure to ensure it rests on Z=0 as requested
// while maintaining the centering logic.

module rack_geometry() {
    difference() {
        // Main block centered at 0,0,0
        cube([block_length, block_width, block_height], center = true);

        // Holes
        for (i = [0 : cols - 1]) {
            for (j = [0 : rows - 1]) {
                translate(
                    x = start_x + (i * spacing_x), 
                    y = start_y + (j * spacing_y), 
                    z = (block_height / 2) - hole_depth + 0.01
                )
                cylinder(h = hole_depth + 0.1, d = hole_diameter);
            }
        }
    }
}

// Final assembly: Move the centered block so the bottom face is at Z=0
translate([0, 0, block_height/2]) rack_geometry();