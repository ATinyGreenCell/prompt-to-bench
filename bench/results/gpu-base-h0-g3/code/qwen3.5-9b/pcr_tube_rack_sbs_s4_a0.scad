// PCR Tube Rack for 96-well Microplates (0.2 mL)
// Designed for FDM 3D printing.
// Orientation: Rests on XY plane at Z=0, builds upward.
// Centred on origin in X and Y.

// --- Dimensions (mm) ---
// Block Dimensions
$block_length = 127.76; // X dimension
$block_width  = 85.48;  // Y dimension
$block_height = 20;     // Z dimension

// Hole Specifications
$hole_diameter = 6.2;   // Hole diameter
$hole_spacing_x = 9.0;  // Centre-to-centre spacing X
$hole_spacing_y = 9.0;  // Centre-to-centre spacing Y
$hole_count_x = 12;     // Columns (along X)
$hole_count_y = 8;      // Rows (along Y)

// Grid Positioning (A1 corner reference)
// A1 is the first hole (bottom-left in standard plate notation, but here we map to geometry)
// "Left edge" = -X direction relative to block centre? 
// Standard Microplate: A1 is bottom-left. 
// User says: "14.38 mm from the left edge and 11.24 mm from the back edge".
// We assume "Left" is -X and "Back" is -Y relative to the block's local coordinate system.
// However, the block is centred on the origin.
// Let's define the block extents first to place the holes correctly.
// Block X range: [-127.76/2, 127.76/2]
// Block Y range: [-85.48/2, 85.48/2]

// Calculate A1 position relative to block centre
// Distance from Left Edge (-X) = 14.38
// Distance from Back Edge (-Y) = 11.24
// A1_X = -($block_length / 2) + 14.38
// A1_Y = -($block_width / 2) + 11.24

$a1_x_offset_from_edge = 14.38;
$a1_y_offset_from_edge = 11.24;

// Chamfer Specifications
$chamfer_angle = 45;
$chamfer_leg = 5;

// --- Derived Variables ---
$block_half_x = $block_length / 2;
$block_half_y = $block_width / 2;

// Calculate A1 absolute coordinates in the centred block system
$a1_x = -$block_half_x + $a1_x_offset_from_edge;
$a1_y = -$block_half_y + $a1_y_offset_from_edge;

// Calculate grid step offsets from A1
// Since A1 is the first hole, we iterate from 0 to count-1
// X increases to the right (+X), Y increases towards the front (+Y)
// Note: Standard plates have A1 at bottom-left. 
// If "Back" is -Y, then "Front" is +Y.
// If "Left" is -X, then "Right" is +X.
// This matches the user description.

// --- Main Block ---
difference() {
    // 1. Create the main block
    cube([
        $block_length, 
        $block_width, 
        $block_height
    ]);

    // 2. Cut the 96 holes
    // We use a loop to generate the 96 cylinders
    for (col = [0 : $hole_count_x - 1]) {
        for (row = [0 : $hole_count_y - 1]) {
            // Calculate position of current hole
            // Hole index from A1: col steps in X, row steps in Y
            current_x = $a1_x + (col * $hole_spacing_x);
            current_y = $a1_y + (row * $hole_spacing_y);
            
            // Cut the hole
            // Extend slightly past the face to ensure clean cut (Rule 5)
            difference() {
                translate([current_x, current_y, 0]) {
                    cylinder(
                        h = $block_height + 0.5, // Extend 0.5mm past top and bottom
                        d = $hole_diameter,
                        $fn = 64
                    );
                }
            }
        }
    }

    // 3. Cut the Chamfer at the A1 corner
    // A1 is at (-X, -Y). The corner is the intersection of the Left face and Back face.
    // We need to cut a 45-degree chamfer with leg length 5mm.
    // The chamfer plane passes through the block surface.
    // We can model this by cutting a wedge or using a plane.
    // Easiest way in OpenSCAD for a corner chamfer:
    // Create a shape that represents the material to be removed.
    // The chamfer removes the corner where X < -block_half_x + leg and Y < -block_half_y + leg.
    
    // Define the corner region to cut
    // The cut starts at the corner edge and goes inwards by $chamfer_leg along both axes.
    // The cut surface is at 45 degrees.
    
    // We can create a "chamfer cutter" shape.
    // It's a pyramid-like shape or a plane cut.
    // Let's use a plane cut approach by creating a large block with a sloped face and intersecting/differencing.
    // Actually, simpler: Create a cylinder or box that approximates the cut volume, or use a plane.
    // Since it's a corner, let's define the vertices of the cut face.
    // The cut face connects:
    // 1. Point on X-axis: (-block_half_x + leg, -block_half_y)
    // 2. Point on Y-axis: (-block_half_x, -block_half_y + leg)
    // 3. Inner corner point: (-block_half_x + leg, -block_half_y + leg)
    // And the outer corner: (-block_half_x, -block_half_y)
    
    // We will cut a wedge defined by these points.
    // To do this cleanly with difference(), we can create a shape that covers the corner and subtract it.
    // Shape: A prism with a triangular cross-section in the XY plane, extruded in Z.
    
    // Vertices of the triangular cut face (in XY):
    // P1: (-block_half_x + leg, -block_half_y)
    // P2: (-block_half_x, -block_half_y + leg)
    // P3: (-block_half_x + leg, -block_half_y + leg)
    // P4: (-block_half_x, -block_half_y) -> This is the corner vertex.
    
    // The material to remove is the tetrahedron/pyramid formed by the corner and the cut plane.
    // Actually, since the chamfer is 45 degrees, the cut plane equation is:
    // (X - X_corner) + (Y - Y_corner) = -leg (if moving inwards)
    // Wait, simpler geometry:
    // The cut removes the region where X < -block_half_x + leg AND Y < -block_half_y + leg?
    // No, that would be a square cut.
    // A 45 degree chamfer removes the region where (X - X_corner) + (Y - Y_corner) < -leg?
    // Let's construct the cutter explicitly.
    
    // Cutter Base (XY plane): A triangle with vertices:
    // V1: (-block_half_x + leg, -block_half_y)
    // V2: (-block_half_x, -block_half_y + leg)
    // V3: (-block_half_x + leg, -block_half_y + leg)
    // And the corner V_corner: (-block_half_x, -block_half_y)
    // The cutter is a pyramid with base V1-V2-V3-V_corner? No.
    // The cut surface is the plane connecting V1, V2, and the inner edge V3-V_corner?
    // No, the chamfer is a flat surface connecting the edge V1-V_corner and V2-V_corner?
    // No, standard chamfer: The corner is rounded off by a plane.
    // The plane passes through V1 and V2.
    // The volume removed is the pyramid with apex at V_corner and base being the triangle V1-V2-V3?
    // No, the base of the removed volume is the triangle V1-V2-V_corner? No.
    // The removed volume is the tetrahedron with vertices:
    // 1. V_corner (-block_half_x, -block_half_y)
    // 2. V1 (-block_half_x + leg, -block_half_y)
    // 3. V2 (-block_half_x, -block_half_y + leg)
    // 4. V3 (-block_half_x + leg, -block_half_y + leg) -- Wait, V3 is on the cut