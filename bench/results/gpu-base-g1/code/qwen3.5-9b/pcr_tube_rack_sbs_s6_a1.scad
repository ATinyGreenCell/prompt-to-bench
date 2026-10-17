// 96-Well PCR Tube Rack (0.2 mL)
// Dimensions based on ANSI/SLAS microplate footprint
// Orientation: Rests on XY plane at Z=0, builds upward (+Z)
// Centred on origin in X and Y

// --- Dimensions ---
// Overall block dimensions
$block_length = 127.76; // X
$block_width  = 85.48;  // Y
$block_height = 20;     // Z

// Hole specifications
$hole_diameter = 6.2;
$hole_count    = 96;
$rows          = 8;     // Along Y
$cols          = 12;    // Along X
$spacing       = 9.0;   // Centre-to-centre spacing

// Grid positioning (A1 corner offsets from block edges)
$offset_x = 14.38;      // Distance from left edge to A1
$offset_y = 11.24;      // Distance from back edge to A1

// Chamfer specifications
$chamfer_leg   = 5;

// --- Configuration ---
$fn = 64; // Smooth curves

// --- Main Block ---
difference() {
    // 1. Main Block
    translate([0, 0, 0])
    cube([
        $block_length,
        $block_width,
        $block_height
    ]);

    // 2. Holes
    // We iterate through rows and columns to create the 96 holes.
    // Rows are along Y, Columns are along X.
    // A1 is at row 0, col 0.
    for (r = [0 : $rows - 1]) {
        for (c = [0 : $cols - 1]) {
            // Calculate hole position relative to the block's local origin (which is at the block centre)
            // First, find position relative to the A1 corner (offset_x, offset_y)
            $pos_x_local = $offset_x + (c * $spacing);
            $pos_y_local = $offset_y + (r * $spacing);
            
            // Translate to global coordinates (block is centred at 0,0)
            $pos_x_global = $pos_x_local - ($block_length / 2);
            $pos_y_global = $pos_y_local - ($block_width / 2);
            
            translate([$pos_x_global, $pos_y_global, 0])
            cylinder(
                h = $block_height + 1, // Extend slightly past top/bottom for clean cut
                r = $hole_diameter / 2,
                $fn = $fn
            );
        }
    }

    // 3. Chamfer at A1 corner
    // A1 is the bottom-left-front corner in standard plate orientation.
    // In our model:
    // X increases to the right.
    // Y increases towards the "back" (since offset_y is from back edge).
    // Z increases upwards.
    // The corner to chamfer is at:
    // X = -($block_length/2) + $offset_x
    // Y = -($block_width/2) + $offset_y
    // Z = 0
    
    $corner_x = -($block_length / 2) + $offset_x;
    $corner_y = -($block_width / 2) + $offset_y;
    
    // We create a large polygon representing the cutting plane.
    // The plane equation is x + y + z = $plane_offset
    // where $plane_offset = $corner_x + $corner_y + $chamfer_leg
    // We want to cut the material where x + y + z > $plane_offset.
    
    $plane_offset = $corner_x + $corner_y + $chamfer_leg;
    
    // Define a large polygon that covers the corner area.
    // We define vertices far enough out to ensure the cut goes through the entire block face.
    // The normal of the plane (1, 1, 1) points towards positive X, Y, Z.
    // We need a polygon that "faces" the corner from the outside.
    
    // Let's define the polygon vertices.
    // We need to cover the region where the cut happens.
    // The cut happens near the corner ($corner_x, $corner_y, 0).
    // The plane passes through:
    // P1: ($corner_x + $chamfer_leg, $corner_y, 0)
    // P2: ($corner_x, $corner_y + $chamfer_leg, 0)
    // P3: ($corner_x, $corner_y, $chamfer_leg)
    
    // To make a valid polygon for difference(), we create a large shape that encompasses the corner
    // and extends far enough in the direction of the normal (1,1,1) to cut through the block.
    // Actually, simpler approach: Create a large polygon that represents the plane, 
    // shifted so it cuts the corner, and ensure it covers the whole block face.
    
    // Let's define a large bounding box for the polygon vertices to ensure coverage.
    $poly_extent = 200;
    
    // Vertices for the cutting plane polygon (counter-clockwise looking from the outside, i.e., from +X, +Y, +Z direction)
    // We need to cover the area "behind" the plane relative to the corner.
    // The plane normal is (1,1,1).
    // We want to keep the part where dot(P, N) < C.
    // So we cut with a shape where dot(P, N) > C.
    
    // Let's construct the polygon vertices explicitly to form a large plane.
    // We'll create a large triangle or quad that covers the corner.
    // Let's use a large triangle with vertices far away.
    
    // Vertex 1: Far in X, Y, Z direction
    $v1 = [$corner_x + $poly_extent, $corner_y + $poly_extent, $chamfer_leg + $poly_extent];
    
    // Vertex 2: Far in X, Y, Z direction (different point)
    $v2 = [$corner_x + $poly_extent, $corner_y + $poly_extent, $chamfer_leg + $poly_extent * 2];
    
    // Vertex 3: Far in X, Y, Z direction
    $v3 = [$corner_x + $poly_extent * 2, $corner_y + $poly_extent, $chamfer_leg + $poly_extent];
    
    // Vertex 4: Far in X, Y, Z direction
    $v4 = [$corner_x + $poly_extent * 2, $corner_y + $poly_extent * 2, $chamfer_leg + $poly_extent];
    
    // Vertex 5: Far in X, Y, Z direction
    $v5 = [$corner_x + $poly_extent * 2, $corner_y + $poly_extent * 2, $chamfer_leg + $poly_extent * 2];
    
    // Vertex 6: Far in X, Y, Z direction
    $v6 = [$corner_x + $poly_extent * 2, $corner_y + $poly_extent, $chamfer_leg + $poly_extent * 2];
    
    // This is getting complicated to get the exact plane.
    // Alternative: Use a large polygon defined by points on the plane x+y+z = $plane_offset.
    // Let's pick 4 points on the plane that form a large square covering the corner.
    
    // Point A: ($corner_x + $chamfer_leg, $corner_y, 0)
    // Point B: ($corner_x, $corner_y + $chamfer_leg, 0)
    // Point C: ($corner_x, $corner_y, $chamfer_leg)
    // These three define the plane.
    
    // Let's create a large polygon that includes these three points and extends far out.
    // We need to ensure the polygon is planar.
    // Let's define 4 points on the plane x + y + z = $plane_offset.
    // P1: ($corner_x + $chamfer_leg, $corner_y, 0)
    // P2: ($corner_x, $corner_y + $chamfer_leg, 0)
    // P3: ($corner_x, $corner_y, $chamfer_leg)
    // P4: ($corner_x + $chamfer_leg, $corner_y + $chamfer_leg, 0) -> Wait, this point is NOT on the plane.
    // Check: ($corner_x + $chamfer_leg) + ($corner_y + $chamfer_leg) + 0 = $corner_x + $corner_y + 2*$chamfer_leg.
    // This is greater than $plane_offset. So P4 is "outside" the kept volume.
    // We want to cut the corner, so we want to remove the region where x+y+z > $plane_offset.
    // So the cutting shape should be the region x+y+z > $plane_offset.
    // The