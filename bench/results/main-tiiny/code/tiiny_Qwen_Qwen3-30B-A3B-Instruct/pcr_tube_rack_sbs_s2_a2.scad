// Dimensions for 96-well PCR tube rack (ANSI/SLAS footprint)
$fn = 64;

// Overall dimensions
length_X = 127.76;   // Length along X-axis
width_Y = 85.48;        // Width along Y-axis
height_Z = 20.0;        // Height of rack

// Hole grid parameters
num_rows = 8;         // 8 rows along Y (A to H)
num_cols = 12;        // 12 columns along X (1 to 12)
hole_diameter = 6.2;   // Diameter of each through-hole
hole_spacing_X = 9.0; // Center-to-center spacing along X
hole_spacing_Y = 9.0; // Center-to-center spacing along Y

// Position of first hole (A1) relative to left and back edges
offset_X = 14.38;   // From left edge
offset_Y = 11.24;  // From back edge

// Chamfer parameters
chamfer_leg = 5.0; // Length of each leg of 45-degree chamfer

// The rack must rest on the XY plane at z = 0 and build upward (+Z)
// The current model is shifted so that bottom is at z = 0, but the hole grid is not centered in X and Y

// The bounding box shows:
// X: 0.00 .. 127.76 (size 127.76) → correct
// Y: 0.00 .. 85.48 (size 85.48) → correct
// Z: 0.00 .. 20.00 (size 20.00) → correct
// But the hole grid is not centered: the grid centre is at (27.00, 18.00) in the slice report, but should be at (length_X/2, width_Y/2) = (63.88, 42.74)

// The hole grid is currently placed with its origin at (0, 0) in X and Y, but it should be centered.

// The specification says: "the grid is centred on the block"
// So the hole grid should be centered in X and Y.

// The first hole (A1) is at 14.38 mm from the left edge and 11.24 mm from the back edge.
// The block is 127.76 mm long and 85.48 mm wide.
// So the centre of the block is at (63.88, 42.74) in X and Y.

// The hole grid has 12 columns (X) and 8 rows (Y), with 9.0 mm spacing.
// The centre of the grid should be at:
//   X: -length_X/2 + offset_X + (num_cols - 1)/2 * hole_spacing_X
//   Y: -width_Y/2 + offset_Y + (num_rows - 1)/2 * hole_spacing_Y

// But we want the grid to be centred on the block, so the centre of the grid should be at (0, 0) in the block's local coordinate system.

// The current model has the block from X=0 to X=127.76 and Y=0 to Y=85.48.
// So the centre of the block is at (63.88, 42.74).

// The hole grid should be placed so that its centre is at (63.88, 42.74).

// The first hole (A1) is at:
//   X = 14.38 (from left edge) → so X = 14.38
//   Y = 11.24 (from back edge) → so Y = 11.24

// The centre of the grid is at:
//   X = 14.38 + (12 - 1) * 9.0 / 2 = 14.38 + 5.5 * 9.0 = 14.38 + 49.5 = 63.88
//   Y = 11.24 + (8 - 1) * 9.0 / 2 = 11.24 + 3.5 * 9.0 = 11.24 + 31.5 = 42.74

// So the grid is correctly centred.

// However, the slice report shows:
//   "24 x circle d=6.20 [6 x 4 grid (X x Y), pitch X 9.00 / Y 9.00, grid centre (27.00, 18.00)]"
// This is wrong — it shows only 24 holes in a 6x4 grid, but we have 96 holes.

// The issue is that the hole grid is not properly placed in the model.
// The model has the block from X=0 to X=127.76 and Y=0 to Y=85.48.
// But the hole grid is placed with its first hole at (14.38, 11.24), which is correct.

// The problem is in the hole generation: the for loops are correct, but the hole positions are not being computed correctly.

// Let's recompute the hole positions:
//   col from 0 to 11 (12 columns)
//   row from 0 to 7 (8 rows)
//   x_pos = 14.38 + col * 9.0
//   y_pos = 11.24 + row * 9.0

// The first hole (A1) is at (14.38, 11.24) — correct.
// The last hole (H12) is at (14.38 + 11*9.0, 11.24 + 7*9.0) = (14.38 + 99, 11.24 + 63) = (113.38, 74.24)
// The block is 127.76 mm long and 85.48 mm wide, so this is within bounds.

// The issue is that the slice report shows only 24 holes in a 6x4 grid, which is not correct.

// The problem is likely in the way the holes are subtracted: we are using a single cylinder for each hole, but the positions are not correct.

// Let's fix the hole positions to be computed correctly and ensure the grid is properly placed.

// We'll create the base block from (0, 0, 0) to (length_X, width_Y, height_Z)
// Then subtract 96 holes at the correct positions.

// The hole grid is 12 columns (X) and 8 rows (Y), with 9.0 mm spacing.
// The first hole (A1) is at (14.38, 11.24) from the left and back.

// We'll generate the holes with a for loop.

// Create the base block
cube(size = [length_X, width_Y, height_Z], center = false);

// Subtract the 96 holes
difference() {
    cube(size = [length_X, width_Y, height_Z], center = false);
    
    for (col = [0 : num_cols - 1]) {
        for (row = [0 : num_rows - 1]) {
            // Calculate the X and Y position of the hole centre
            x_pos = offset_X + col * hole_spacing_X;
            y_pos = offset_Y + row * hole_spacing_Y;
            
            // Create a cylinder hole through the entire rack
            // Use a cylinder that extends 0.1 mm beyond the block to ensure full cut
            cylinder(h = height_Z + 0.1, d = hole_diameter, center = false, $fn = 64);
            translate([x_pos, y_pos, 0]) {
                cylinder(h = height_Z + 0.1, d = hole_diameter, center = false, $fn = 64);
            }
        }
    }
}

// Chamfer at A1 corner (front-left bottom corner in standard orientation)
// A1 is at (left, back) = (14.38, 11.24) in the current coordinate system
// The chamfer is a 45-degree bevel with 5 mm legs

// The chamfer is on the vertical edge at the A1 corner: where X = 0 and Y = 0 (the left and back edges)
// The chamfer removes a region that is 5 mm long along both X and Y directions from the corner

// We'll define a polyhedron that removes a tetrahedron from the A1 corner

// The chamfer is a 45-degree bevel on the vertical edge at the A1 corner.
// It removes a region bounded by:
// - A plane at 45 degrees in the XZ plane: from (0, 0, 0) to ( -chamfer_leg, 0, height_Z) — but