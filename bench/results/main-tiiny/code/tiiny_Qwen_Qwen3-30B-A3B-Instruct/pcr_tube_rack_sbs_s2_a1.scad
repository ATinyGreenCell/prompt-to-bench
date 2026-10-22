// Dimensions for 96-well PCR tube rack (ANSI/SLAS footprint)
$fn = 64;

// Overall dimensions
length_X = 127.76;   // Length along X-axis
width_Y = 85.48;    // Width along Y-axis
height_Z = 20.0;    // Height of rack

// Hole grid parameters
num_rows = 8;     // 8 rows along Y (A to H)
num_cols = 12;    // 12 columns along X (1 to 12)
hole_diameter = 6.2; // Diameter of each through-hole
hole_spacing_X = 9.0; // Center-to-center spacing along X
hole_spacing_Y = 9.0; // Center-to-center spacing along Y

// Position of first hole (A1) relative to left and back edges
offset_X = 14.38;   // From left edge
offset_Y = 11.24; // From back edge

// Chamfer parameters
chamfer_leg = 5.0; // Length of each leg of 45-degree chamfer

// The rack must rest on the XY plane at z = 0 and build upward (+Z)
// The current model is centered at z = 0, but the bed contact is at z = -10.00
// We need to shift the entire model so that the bottom is at z = 0

// Recalculate the hole centers
// We'll generate hole positions using for loops

// Create the base block, now shifted so that bottom is at z = 0
// The block should extend from z = 0 to z = height_Z

// We'll use a cube from (0, 0, 0) to (length_X, width_Y, height_Z), but centered in X and Y
// So we need to shift the entire model so that the bottom is at z = 0

// First, define the base block from z = 0 to z = height_Z
// And center it in X and Y

// Create the base block from z = 0 to z = height_Z, centered in X and Y
// So the block goes from -length_X/2 to +length_X/2 in X, -width_Y/2 to +width_Y/2 in Y, 0 to height_Z in Z

// Subtract holes for 96 wells
difference() {
    // Outer block: from -length_X/2 to +length_X/2 in X, -width_Y/2 to +width_Y/2 in Y, 0 to height_Z in Z
    cube(size = [length_X, width_Y, height_Z], center = false);
    
    for (col = [0 : num_cols - 1]) {
        for (row = [0 : num_rows - 1]) {
            // Calculate center of each hole
            x_pos = -length_X / 2 + offset_X + col * hole_spacing_X;
            y_pos = -width_Y / 2 + offset_Y + row * hole_spacing_Y;
            
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
// A1 is at (left, back) = (-length_X/2 + offset_X, -width_Y/2 + offset_Y)
// So chamfer is on the negative X and negative Y side, at z = 0

// We'll chamfer the vertical edge at the A1 corner: the edge where X = -length_X/2 and Y = -width_Y/2
// The chamfer is a 45-degree bevel with 5 mm legs

// The chamfer is a 45-degree bevel on the vertical edge at the A1 corner.
// It removes a region that is bounded by:
// - A plane at 45 degrees in the XZ plane: from (A1_x, A1_y, 0) to (A1_x - chamfer_leg, A1_y, height_Z)
// - A plane at 45 degrees in the YZ plane: from (A1_x, A1_y, 0) to (A1_x, A1_y - chamfer_leg, height_Z)
// - The vertical face at X = -length_X/2 and Y = -width_Y/2

// We'll define a polyhedron that removes a tetrahedron from the A1 corner

// Define the A1 corner in absolute coordinates
A1_x = -length_X / 2 + offset_X;
A1_y = -width_Y / 2 + offset_Y;

// The chamfer removes a region that is 5 mm along both X and Y directions from the corner
// The chamfer is a 45-degree bevel, so the cut goes from the bottom (z=0) to the top (z=height_Z)

// The chamfer region is a tetrahedron with 4 vertices:
// - P1: (A1_x, A1_y, 0)  // the corner at the bottom
// - P2: (A1_x - chamfer_leg, A1_y, 0)  // 5 mm along -X at bottom
// - P3: (A1_x, A1_y - chamfer_leg, 0)  // 5 mm along -Y at bottom
// - P4: (A1_x - chamfer_leg, A1_y - chamfer_leg, height_Z)  // apex at top, 5 mm along both -X and -Y

// But this is not correct for a 45-degree chamfer.

// Correct: a 45-degree chamfer means that the bevel angle is 45 degrees, so the cut goes from the bottom at (A1_x, A1_y, 0) to a point at height_Z that is 5 mm along both -X and -Y from the corner.

// So the apex of the chamfer is at (A1_x - chamfer_leg, A1_y - chamfer_leg, height_Z)

// The chamfer is a pyramid with:
// - Apex: (A1_x - chamfer_leg, A1_y - chamfer_leg, height_Z)
// - Base: a square at z = 0 from (A1_x, A1_y, 0) to (A1_x - chamfer_leg, A1_y - chamfer_leg, 0)

// But that would be a pyramid that goes from the top to the base.

// Actually, the chamfer is a 45-degree bevel on the vertical edge at the A1 corner.
// It removes a region that is bounded by:
// - A plane from (A1_x, A1_y, 0) to (A1_x - chamfer_leg, A1_y, height_Z) — 45 deg in XZ
// - A plane from (A1_x, A1_y, 0) to (A1_x, A1_y - chamfer_leg, height_Z) — 45 deg in YZ
// - A plane from (A1_x - chamfer_leg, A1_y, height_Z) to (A1_x, A1_y - chamfer_leg, height_Z) — top edge

// So the chamfer is a tetrahedron with 4 vertices:
// - A: (A1_x, A1_y, 0)  // corner at bottom
// - B: (A1_x - chamfer_leg, A1_y, 0)  // 5 mm along -X at bottom
// - C: (A1_x, A1_y - chamfer_leg, 0)  // 5 mm along -Y at bottom
// - D: (A1_x - chamfer_leg, A1_y - chamfer_leg, height_Z)  // apex at top

// But this is not correct because the top edge is not at z = height_Z.

// For a 45-degree chamfer with leg length L, the apex is at (A1_x - L, A1_y - L, height_Z) only if the bevel is 45 degrees and the height is L.
// But we want the chamfer to have legs of 5 mm, so the apex should be at (A1_x - 5, A1_y - 5, height_Z) only if the bevel is 45 degrees and the height is 5 mm.

// Actually, for a 45-degree chamfer with leg length L, the height of the chamfer is L.
// But our rack is 20 mm tall, so the chamfer should extend from z = 0 to z = 5 mm? No.

// The chamfer is a 45-degree bevel on the vertical edge at the A1 corner.
// The chamfer has two legs: one along the X direction and one along the Y direction, each 5 mm long.
// The chamfer is a 45-degree bevel, so the cut goes from the bottom (z=0)