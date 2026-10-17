// 96-Well PCR Tube Rack (ANSI/SLAS Footprint)
// Designed for FDM 3D printing.
// Orientation: Rests on XY plane at Z=0, builds upward.
// Centred on origin in X and Y.

// --- Dimensions (mm) ---
// Block Dimensions
$block_length = 127.76;
$block_width  = 85.48;
$block_height = 20;

// Hole Specifications
$hole_diameter = 6.2;
$hole_spacing_x = 9.0;
$hole_spacing_y = 9.0;
$hole_count_x = 12;
$hole_count_y = 8;

// Grid Positioning (Distance from edge to first hole centre)
$offset_x = 14.38;
$offset_y = 11.24;

// Chamfer Specifications (Orientation Mark at A1 corner)
$chamfer_leg = 5;

// --- Configuration ---
$fn = 100; // High resolution for smooth holes and chamfers

// --- Main Block ---
difference() {
    // 1. Create the main block
    block = cube([
        $block_length,
        $block_width,
        $block_height
    ]);
    
    // 2. Cut the 96 holes
    // Loop through columns (X) and rows (Y)
    for (col = [0 : $hole_count_x - 1]) {
        for (row = [0 : $hole_count_y - 1]) {
            // Calculate position of current hole centre
            pos_x = $offset_x + (col * $hole_spacing_x);
            pos_y = $offset_y + (row * $hole_spacing_y);
            
            // Create hole cylinder
            // Extend slightly past the block height to ensure clean cut
            hole = cylinder(
                h = $block_height + 0.1,
                r = $hole_diameter / 2,
                center = [pos_x, pos_y, $block_height / 2]
            );
            
            difference() {
                block;
                hole;
            }
        }
    }
    
    // 3. Cut the Chamfer at the A1 corner
    // A1 is the first hole (col=0, row=0).
    // Corner coordinates relative to block origin (bottom-left-back):
    // X = $offset_x
    // Y = $offset_y
    // Z = 0 (bottom edge)
    
    // We need to cut a 45-degree chamfer with leg length 5mm.
    // The cut removes the corner tetrahedron defined by points:
    // P1: ($offset_x + $chamfer_leg, $offset_y, 0)
    // P2: ($offset_x, $offset_y + $chamfer_leg, 0)
    // P3: ($offset_x, $offset_y, $chamfer_leg)
    
    // To cut this in OpenSCAD, we create a "knife" shape: a large cylinder 
    // oriented along the normal of the cut plane, with a radius large enough 
    // to cover the block, but we must be careful not to cut the rest of the block.
    // A better approach for a specific planar cut is to use a large cylinder 
    // whose axis is the normal to the plane, positioned such that it slices the corner.
    
    // Normal vector of the plane passing through P1, P2, P3 is [1, 1, 1].
    // We create a cylinder with axis [1, 1, 1].
    // The radius must be large enough to cover the extent of the block in that direction 
    // from the cut plane, but small enough not to cut the main body elsewhere?
    // Actually, if we place the cylinder correctly, it will only cut the corner.
    
    // Let's define the plane equation: x + y - z = C
    // At P1 ($offset_x + L, $offset_y, 0): ($offset_x + L) + $offset_y - 0 = C
    // C = $offset_x + $offset_y + $chamfer_leg
    
    // We create a cylinder with axis [1, 1, -1] (or [1,1,1] depending on direction)
    // Let's use a large cylinder with axis [1, 1, 1] (normalized).
    // We need to position it so it cuts the corner.
    
    // Alternative robust method: Create a polygon extrusion of the cut surface?
    // No, difference() requires a solid.
    
    // Let's use a large cylinder with a very small radius? No.
    // Let's use a large cylinder with radius R, axis [1, 1, 1], positioned at the corner.
    // The distance from the corner ($offset_x, $offset_y, 0) to the plane x+y-z = C is 0.
    // We want to cut everything on one side of the plane.
    
    // Let's try a different geometric construction:
    // Create a large cylinder with axis [1, 1, 1] and radius R.
    // Position the center of the cylinder at ($offset_x, $offset_y, $chamfer_leg).
    // The distance from this center to the plane x+y-z = ($offset_x+$offset_y+$chamfer_leg) is:
    // |1*$offset_x + 1*$offset_y + 1*$chamfer_leg - ($offset_x+$offset_y+$chamfer_leg)| / sqrt(3) = 0.
    // So the center lies on the plane.
    // If we use a large radius, it will cut a huge chunk.
    
    // Correct approach for a planar cut in OpenSCAD:
    // Create a large cylinder with axis perpendicular to the plane.
    // The radius should be large enough to cover the block's extent in the direction of the normal.
    // The position should be such that the cylinder's surface coincides with the cut plane.
    
    // Normal n = [1, 1, 1].
    // Plane: n . (r - r0) = 0. r0 = ($offset_x, $offset_y, $chamfer_leg).
    // We want to remove the side where n . (r - r0) < 0 (assuming we want to keep the main block).
    // Wait, the corner is at ($offset_x, $offset_y, 0).
    // n . (corner - r0) = 1*($offset_x - $offset_x) + 1*($offset_y - $offset_y) + 1*(0 - $chamfer_leg) = -$chamfer_leg.
    // So the corner is on the negative side.
    // We want to cut the negative side.
    
    // Create a cylinder with axis [1, 1, 1], center at r0, radius R.
    // The cylinder surface is at distance R from r0 along the axis.
    // We want the surface to be the plane. So R must be 0? No.
    // A cylinder with R=0 is a line.
    // We need a shape that approximates a half-space.
    
    // Let's use a large sphere? No.
    // Let's use a large cylinder with a very large radius, but we need to limit the cut to the corner.
    // Actually, the simplest way to cut a plane in OpenSCAD is to use a large cylinder 
    // with a radius that covers the object, but we need to ensure it doesn't cut the rest.
    // This is tricky.
    
    // Alternative: Use a polygon extrusion to create a "knife" that is a flat plate.
    // Define a polygon in the plane of the cut, extrude it far enough to cut through the block.
    // The polygon should be a large square or circle in the plane.
    // Then rotate and translate it to the correct position.
    
    // Step 1: Define a large square in the XY plane (local coords).
    // Step 2: Rotate it to align with the plane [1, 1, 1].
    // Step 3: Translate it to the corner.
    // Step 4: Extrude it along the normal [1, 1, 1] to make it thick enough to cut.
    // Step 5: Use it in difference().
    
    // Let's define the plane normal: n = [1, 1, 1].
    // We need a rotation matrix to align Z (0,0,1) to n.
    // One simple rotation: Rotate -45 deg around X, then rotate -45 deg around Y?
    // Let's try: Rotate around Y by 45 deg, then around X by 45 deg?
    // Vector [0,0,1] -> Rotate Y(45) -> [0, sin45, cos45] -> [0, 0.707, 0.707]
    // -> Rotate X