// 96-Well PCR Tube Rack
// Designed for 0.2 mL tubes, ANSI/SLAS footprint
// Orientation: Rests on XY plane at Z=0, builds upward.
// Centred on origin in X and Y.

// --- Dimensions (mm) ---
// Overall Block
$block_length = 127.76;
$block_width  = 85.48;
$block_height = 20;

// Hole Specifications
$hole_diameter = 6.2;
$hole_spacing_x = 9.0;
$hole_spacing_y = 9.0;
$hole_count_x = 12;
$hole_count_y = 8;

// Grid Positioning (Distance from nearest edge to first hole centre)
$offset_x = 14.38;
$offset_y = 11.24;

// Chamfer (Orientation Mark)
$chamfer_angle = 45;
$chamfer_leg = 5;

// --- Derived Dimensions ---
// Calculate total grid size to verify centering
$total_grid_x = ($hole_count_x - 1) * $hole_spacing_x;
$total_grid_y = ($hole_count_y - 1) * $hole_spacing_y;

// Verify centering logic:
// Expected distance from edge to first hole = (Total Block Dim - Total Grid Dim) / 2
// X Check: (127.76 - 108) / 2 = 9.88. User specified 14.38. 
// The user's dimension (14.38) implies the grid is NOT perfectly centered on the block 
// OR the user's "left edge" reference is different. 
// Rule 1 says: "Use the user's dimensions exactly".
// Therefore, we place the grid starting at X = $offset_x from the left face of the block.
// To center the block on the origin, we calculate the block offset.

// Calculate Block Offset to center the block on the origin
// Block Center X = $block_length / 2
// Grid Center X = $offset_x + $total_grid_x / 2
// Block Offset X = Block Center X - Grid Center X
$block_offset_x = ($block_length / 2) - ($offset_x + $total_grid_x / 2);

// Block Center Y = $block_width / 2
// Grid Center Y = $offset_y + $total_grid_y / 2
// Block Offset Y = Block Center Y - Grid Center Y
$block_offset_y = ($block_width / 2) - ($offset_y + $total_grid_y / 2);

// --- Main Part ---
difference() {
    // 1. The Main Block
    translate([
        $block_offset_x, 
        $block_offset_y, 
        0
    ])
    cube([
        $block_length, 
        $block_width, 
        $block_height
    ]);

    // 2. The 96 Holes
    // We use a loop to generate holes at the specified grid
    for (row = [0:$hole_count_y-1], col = [0:$hole_count_x-1]) {
        // Calculate position of current hole
        // X position: offset_x + col * spacing
        // Y position: offset_y + row * spacing
        // Note: Row 0 is the back edge (Y min), Row 7 is the front edge (Y max)
        
        $x_pos = $offset_x + col * $hole_spacing_x;
        $y_pos = $offset_y + row * $hole_spacing_y;
        
        translate([
            $x_pos, 
            $y_pos, 
            0
        ])
        cylinder(
            h = $block_height + 0.1, // Extend slightly past top for clean cut
            d = $hole_diameter,
            $fn = 64
        );
    }

    // 3. The Chamfer (Orientation Mark)
    // Location: A1 corner. 
    // A1 is typically Row 1, Col 1 in biology, but here defined by the grid start.
    // The prompt says "A1 corner" and gives offsets from "left edge" and "back edge".
    // So the chamfer is at the bottom-left-back corner of the block relative to the grid start.
    // Coordinates of the corner to chamfer:
    // X = $offset_x
    // Y = $offset_y
    // Z = 0
    
    // We create a plane that cuts the corner.
    // The cut plane passes through:
    // Point 1: ($offset_x + $chamfer_leg, $offset_y, 0)
    // Point 2: ($offset_x, $offset_y + $chamfer_leg, 0)
    // Point 3: ($offset_x, $offset_y, $chamfer_leg)
    // This creates a 45 degree chamfer on the vertical edge at that corner.
    
    // To cut this, we define a polygon in the XY plane (or a plane parallel to it) 
    // but since it's a vertical edge chamfer, the cut surface is slanted.
    // Easiest way in OpenSCAD for a 45 deg chamfer on a corner:
    // Create a shape that represents the "missing" material.
    // The missing material is a wedge.
    
    // Let's define the vertices of the cut surface (the new face created by the chamfer)
    // Actually, simpler: Create a "knife" shape or a polygon extruded to cut the corner.
    // We want to remove the corner defined by the intersection of the three planes.
    // The cut plane equation roughly: (x - x0) + (y - y0) + (z - z0) = 0 ? No.
    // A 45 deg chamfer on the vertical edge means the cut face is at 45 deg to the vertical and horizontal.
    // The cut removes the region where x < x0 + leg AND y < y0 + leg AND z < leg? No.
    // It removes the corner such that the distance from the corner along the face is constant.
    
    // Let's construct the cutting polygon in the plane Z = 0 (bottom) and extrude it? No.
    // Let's construct the cutting polygon in the plane X = $offset_x + $chamfer_leg? No.
    
    // Standard approach for chamfer corner:
    // Define the 3 points of the cut triangle on the faces meeting at the corner.
    // P1 (on X-face): ($offset_x + $chamfer_leg, $offset_y, 0)
    // P2 (on Y-face): ($offset_x, $offset_y + $chamfer_leg, 0)
    // P3 (on Z-face): ($offset_x, $offset_y, $chamfer_leg)
    // The cutting plane passes through these three points.
    // We can create a polygon with these 3 points and extrude it? No, that makes a flat plate.
    // We need to subtract the volume "below" this plane.
    
    // Alternative: Create a large plane that intersects the block, but that's hard to control.
    // Better: Create a "wedge" shape that fits into the corner and subtract it.
    // The wedge vertices:
    // V1: ($offset_x + $chamfer_leg, $offset_y, 0)
    // V2: ($offset_x, $offset_y + $chamfer_leg, 0)
    // V3: ($offset_x, $offset_y, $chamfer_leg)
    // V4: ($offset_x + $chamfer_leg, $offset_y, $chamfer_leg) -> Wait, this is not a simple wedge.
    
    // Let's use the polygon method with a large enough extrusion to cover the block.
    // We define the cut surface as a polygon in 3D space? OpenSCAD polygons are 2D.
    // We can use `rotate` and `translate` to orient a 2D polygon to cut the corner.
    // The cut surface is a triangle with vertices P1, P2, P3 defined above.
    // We can create a polygon with these 3 points, then use `linear_extrude`? No, that makes a prism.
    // We need to subtract the volume bounded by the corner and the plane.
    
    // Correct approach for chamfer:
    // Create a polygon representing the cross-section of the cut?
    // Let's try a different strategy: Define the "missing" corner as a union of 3 rectangular prisms? No.
    // Let's define the cut plane explicitly.
    // The plane passes through ($offset_x + $chamfer_leg, $offset_y, 0), ($offset_x, $offset_y + $chamfer_leg, 0), ($offset_x, $offset_y, $chamfer_leg).
    // Normal vector calculation:
    // V1 = P2 - P1 = (-$chamfer_leg, $chamfer_leg, 0)
    // V2 =