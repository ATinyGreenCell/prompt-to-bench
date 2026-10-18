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
$chamfer_angle = 45;
$chamfer_leg   = 5;

// --- Configuration ---
$fn = 64; // Smooth curves

// --- Calculations ---
// Calculate grid start positions relative to the block's local coordinate system
// We define the block's local origin at its geometric centre for symmetry,
// then translate the whole block later.
// However, to match the "offset from edge" description directly:
// Let's define the block geometry first, then place holes.

// Block half-dimensions
$half_len = $block_length / 2;
$half_wid = $block_width / 2;

// Grid origin relative to block center
// A1 is at (offset_x, offset_y) from the left/back edge.
// Left edge X = -$half_len, Back edge Y = -$half_wid
// A1 X = -$half_len + $offset_x
// A1 Y = -$half_wid + $offset_y
$grid_origin_x = -$half_len + $offset_x;
$grid_origin_y = -$half_wid + $offset_y;

// --- Main Block ---
difference() {
    // 1. Create the main block
    block = cube([
        $block_length,
        $block_width,
        $block_height
    ]);

    // 2. Cut the 96 holes
    for (r = [0:$rows-1], c = [0:$cols-1]) {
        // Calculate hole position
        $x = $grid_origin_x + c * $spacing;
        $y = $grid_origin_y + r * $spacing;
        
        // Cut hole (extend slightly past diameter to ensure clean cut)
        translate([
            $x - $hole_diameter/2,
            $y - $hole_diameter/2,
            0
        ]) {
            cylinder(
                h = $block_height + 0.1, // Extend slightly past top
                d = $hole_diameter,
                $fn = $fn
            );
        }
    }

    // 3. Cut Chamfer at A1 corner
    // A1 is the top-left-back corner in standard plate notation.
    // In our coordinate system:
    // X increases to the right.
    // Y increases towards the front (since offset_y is from back).
    // Z increases upwards.
    // The corner is at X = $grid_origin_x, Y = $grid_origin_y, Z = $block_height.
    // We need to cut a 45 deg chamfer with leg 5mm on the vertical edge.
    // This edge runs along Z.
    // The cut should remove material where X < $grid_origin_x + $chamfer_leg AND Y < $grid_origin_y + $chamfer_leg.
    
    // Define the chamfer plane.
    // Normal vector points into the corner: (-1, -1, 0) normalized.
    // Distance from origin to plane: We want the plane to pass through the point 
    // ($grid_origin_x + $chamfer_leg, $grid_origin_y + $chamfer_leg, 0) 
    // effectively creating a 45 degree slope from the top corner down to the side.
    
    // Actually, simpler approach for a 45 deg chamfer on a vertical edge:
    // The cut surface is a plane.
    // The plane equation: (X - X0) + (Y - Y0) = 0 ? No.
    // The plane passes through the top corner ($grid_origin_x, $grid_origin_y, $block_height)
    // and intersects the side faces at ($grid_origin_x + $chamfer_leg, $grid_origin_y, 0) and ($grid_origin_x, $grid_origin_y + $chamfer_leg, 0)?
    // Wait, a 45 deg chamfer with leg 5mm usually means the cut goes 5mm along the X face and 5mm along the Y face from the corner?
    // Or 5mm along the vertical edge?
    // "45-degree chamfer with 5 mm legs off the vertical edge"
    // This implies the cut removes a triangular prism shape.
    // The hypotenuse is the cut face. The legs are on the X and Y faces of the block.
    // The length of the leg along the vertical edge (Z) would be 5mm * sqrt(2) if the legs on X/Y are 5mm.
    // OR, if the leg along the vertical edge is 5mm, then the legs on X/Y are 5mm * cos(45).
    // Standard interpretation: The cut creates a 45 degree angle. The "leg" usually refers to the distance along the adjacent faces.
    // Let's assume the cut removes material such that the distance from the corner along the X-face is 5mm and along the Y-face is 5mm.
    // This creates a 45 degree slope.
    
    // Plane definition:
    // Passes through: P1 = ($grid_origin_x + $chamfer_leg, $grid_origin_y, $block_height)
    //                P2 = ($grid_origin_x, $grid_origin_y + $chamfer_leg, $block_height)
    //                P3 = ($grid_origin_x + $chamfer_leg, $grid_origin_y + $chamfer_leg, 0) -- Wait, this makes a triangle on the top face?
    // No, a chamfer on a vertical edge connects the top corner to the side faces.
    // Points:
    // Top Corner: ($grid_origin_x, $grid_origin_y, $block_height)
    // Intersection on X-face: ($grid_origin_x + $chamfer_leg, $grid_origin_y, $block_height - $chamfer_leg) ? No, that's a slope.
    // If it's a 45 degree chamfer, the slope is 1:1.
    // If the leg on the X face is 5mm, the drop in Z is 5mm.
    // So the cut goes from ($grid_origin_x, $grid_origin_y, $block_height) to ($grid_origin_x + 5, $grid_origin_y, $block_height - 5).
    // And to ($grid_origin_x, $grid_origin_y + 5, $block_height - 5).
    // And the bottom of the cut is at ($grid_origin_x + 5, $grid_origin_y + 5, $block_height - 5).
    // This forms a triangular cut on the top face? No, the top face is intact except for the corner?
    // Usually a chamfer on a corner removes the corner.
    // Let's define the cutting plane that slices off the corner.
    // The plane passes through:
    // A = ($grid_origin_x + $chamfer_leg, $grid_origin_y, $block_height - $chamfer_leg)
    // B = ($grid_origin_x, $grid_origin_y + $chamfer_leg, $block_height - $chamfer_leg)
    // C = ($grid_origin_x + $chamfer_leg, $grid_origin_y + $chamfer_leg, $block_height - $chamfer_leg)
    // And the top corner D = ($grid_origin_x, $grid_origin_y, $block_height) is removed.
    // Wait, if the leg is 5mm, does it mean 5mm along the edge?
    // "5 mm legs off the vertical edge". This phrasing is slightly ambiguous.
    // Interpretation A: The cut extends 5mm along the X face and 5mm along the Y face. (Most common for "chamfer").
    // Interpretation B: The cut extends 5mm along the vertical edge (Z).
    // Given "45-degree", Interpretation A is geometrically consistent (slope 1).
    // So the cut plane passes through ($grid_origin_x + 5, $grid_origin_y, $block_height - 5) and ($grid_origin_x, $grid_origin_y + 5, $block_height - 5).
    //