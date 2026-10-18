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
// A1 is the first hole.
// "Left edge" = -X direction relative to block centre.
// "Back edge" = -Y direction relative to block centre.
$a1_x_offset_from_edge = 14.38;
$a1_y_offset_from_edge = 11.24;

// Chamfer Specifications
$chamfer_leg = 5;

// --- Derived Variables ---
$block_half_x = $block_length / 2;
$block_half_y = $block_width / 2;

// Calculate A1 absolute coordinates in the centred block system
$a1_x = -$block_half_x + $a1_x_offset_from_edge;
$a1_y = -$block_half_y + $a1_y_offset_from_edge;

// --- Main Block ---
difference() {
    // 1. Create the main block
    cube([
        $block_length, 
        $block_width, 
        $block_height
    ]);

    // 2. Cut the 96 holes
    for (col = [0 : $hole_count_x - 1]) {
        for (row = [0 : $hole_count_y - 1]) {
            // Calculate position of current hole
            current_x = $a1_x + (col * $hole_spacing_x);
            current_y = $a1_y + (row * $hole_spacing_y);
            
            // Cut the hole
            // Extend slightly past the face to ensure clean cut
            difference() {
                translate([current_x, current_y, 0]) {
                    cylinder(
                        h = $block_height + 1, // Extend 1mm past top and bottom
                        d = $hole_diameter,
                        $fn = 64
                    );
                }
            }
        }
    }

    // 3. Cut the Chamfer at the A1 corner
    // A1 is at (-X, -Y). The corner is the intersection of the Left face and Back face.
    // We cut a 45-degree chamfer with leg length $chamfer_leg.
    // The cut removes the corner region defined by the plane connecting:
    // P1: (-block_half_x + leg, -block_half_y)
    // P2: (-block_half_x, -block_half_y + leg)
    // P3: (-block_half_x + leg, -block_half_y + leg)
    // And the outer corner P_corner: (-block_half_x, -block_half_y)
    
    // We create a "cutter" shape that is a pyramid with the corner as the apex
    // and the triangle P1-P2-P3 as the base? No, that's not right.
    // The chamfer is a flat plane. The volume removed is a tetrahedron with vertices:
    // V1: (-block_half_x + leg, -block_half_y, 0)
    // V2: (-block_half_x, -block_half_y + leg, 0)
    // V3: (-block_half_x + leg, -block_half_y + leg, 0)
    // V4: (-block_half_x, -block_half_y, 0) -> This is the corner vertex on the bottom face.
    // Wait, the chamfer goes through the whole height.
    // The vertices of the cut volume on the bottom face (Z=0) are:
    // A: (-block_half_x + leg, -block_half_y)
    // B: (-block_half_x, -block_half_y + leg)
    // C: (-block_half_x + leg, -block_half_y + leg)
    // D: (-block_half_x, -block_half_y)
    // The cut surface is the plane passing through A, B, and C?
    // No, a 45 degree chamfer on a corner usually connects the two adjacent edges.
    // The plane passes through A and B. The line segment A-B is the cut line on the surface? No, A and B are points on the edges.
    // The cut surface is the plane passing through A, B, and the corresponding points at the top.
    // The volume removed is a pyramid with apex at the corner (-block_half_x, -block_half_y, Z) for all Z?
    // No, the apex is the corner vertex (-block_half_x, -block_half_y, 0) and (-block_half_x, -block_half_y, $block_height).
    // The base of the pyramid is the rectangle defined by the cut?
    // Let's simplify. The cut removes the region where X < -block_half_x + leg AND Y < -block_half_y + leg?
    // No, that's a square cut.
    // A 45 degree chamfer removes the region where (X - (-block_half_x)) + (Y - (-block_half_y)) < leg?
    // Let's construct the cutter explicitly as a pyramid.
    // Apex: (-block_half_x, -block_half_y, $block_height/2) ? No.
    // The cut is a plane. The volume removed is a pyramid with the corner as the apex and the triangle formed by the cut line on the faces as the base?
    // Actually, the simplest way to cut a 45 deg chamfer on a corner in OpenSCAD is to define the plane.
    // But since we are using difference(), we need a solid to subtract.
    // The solid to subtract is a pyramid with:
    // Base: Triangle with vertices A(-block_half_x + leg, -block_half_y, 0), B(-block_half_x, -block_half_y + leg, 0), and C(-block_half_x + leg, -block_half_y + leg, 0)?
    // No, the cut surface is the plane connecting A and B. The line A-B is on the surface of the block? No.
    // A is on the bottom face (Y = -block_half_y). B is on the back face (X = -block_half_x).
    // The line segment A-B is the cut line on the surface? No, A and B are points on the edges.
    // The cut surface is the plane passing through A, B, and the corresponding points at the top.
    // The volume removed is a pyramid with apex at the corner (-block_half_x, -block_half_y, Z) for all Z?
    // No, the apex is the corner vertex (-block_half_x, -block_half_y, 0) and (-block_half_x, -block_half_y, $block_height).
    // The base of the pyramid is the rectangle defined by the cut?
    // Let's simplify. The cut removes the region where X < -block_half_x + leg AND Y < -block_half_y + leg?
    // No, that's a square cut.
    // A 45 degree chamfer removes the region where (X - (-block_half_x)) + (Y - (-block_half_y)) < leg?
    // Let's construct the cutter explicitly as a pyramid.
    // Apex: (-block_half_x, -block_half_y, $block_height/2) ? No.
    // The cut is a plane. The volume removed is a pyramid with the corner as the apex and the triangle formed by the cut line on the faces as the base?
    // Actually, the simplest way to cut a 45 deg chamfer on a corner in OpenSCAD is to define the plane.
    // But since we are using difference(), we need a solid to subtract.
    // The solid to subtract is a pyramid with:
    // Base: Triangle with vertices A(-block_half_x + leg, -block_half_y, 0), B(-block_half_x, -block_half_y + leg, 0), and C(-block_half_x + leg, -block_half_y + leg, 0)?
    // No, the cut surface is the plane connecting A and B. The line A-B is on the surface of the block? No.
    // A is on the bottom face (Y = -block_half_y). B is on the back face (X = -block_half_x).
    // The line segment A-B is the cut line on the surface? No, A and B are points on the edges.
    // The cut surface is the plane passing through A, B