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
$rows          = 8;     // Along Y
$cols          = 12;    // Along X
$spacing       = 9.0;   // Centre-to-centre spacing

// Grid positioning (A1 corner offsets from block edges)
$offset_x = 14.38;      // Distance from left edge to A1
$offset_y = 11.24;      // Distance from back edge to A1

// Chamfer specifications
$chamfer_leg = 5; // Distance along the side faces

// --- Configuration ---
$fn = 64; // Smooth curves

// --- Main Block ---
difference() {
    // 1. Create the main block
    // Centered at origin: X range [-63.88, 63.88], Y range [-42.74, 42.74]
    block = cube([
        $block_length,
        $block_width,
        $block_height
    ]);

    // 2. Cut the 96 holes
    // Calculate grid origin relative to block center
    // Left edge X = -$block_length/2 = -63.88
    // Back edge Y = -$block_width/2 = -42.74
    // A1 X = -63.88 + 14.38 = -49.5
    // A1 Y = -42.74 + 11.24 = -31.5
    $grid_origin_x = -$block_length/2 + $offset_x;
    $grid_origin_y = -$block_width/2 + $offset_y;
    
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
    // A1 is the top-left-back corner.
    // Corner coordinates:
    $corner_x = $grid_origin_x;
    $corner_y = $grid_origin_y;
    
    // We need to cut a 45-degree chamfer with 5mm legs off the vertical edge.
    // This means removing material where (X > $corner_x) AND (Y > $corner_y)
    // within the region defined by the plane: X + Y = $corner_x + $corner_y + $chamfer_leg
    // We create a 2D polygon representing this cutting plane and extrude it downwards.
    
    // The cutting plane in 2D (X, Y) is defined by the line:
    // X + Y = $corner_x + $corner_y + $chamfer_leg
    // We need a polygon that covers the area to be removed (the corner).
    // The vertices of the polygon should form a shape that, when extruded, slices the corner.
    // Let's define a large polygon that represents the half-plane X + Y >= $corner_x + $corner_y + $chamfer_leg
    // clipped to a large box to ensure it cuts the whole corner.
    
    // Vertices for the cutting plane polygon (2D):
    // We define a polygon that starts from the cut line and extends outwards.
    // Point 1: Intersection with X-face (Y = $corner_y) -> X = $corner_x + $chamfer_leg
    // Point 2: Intersection with Y-face (X = $corner_x) -> Y = $corner_y + $chamfer_leg
    // Point 3: Far out in X direction
    // Point 4: Far out in Y direction
    // Point 5: Far out in X (to close loop)
    // Point 6: Far out in Y (to close loop)
    // Actually, simpler: Define the line segment between the two intercepts, then extend to infinity.
    // Since we are using difference(), we just need the polygon to cover the corner region.
    
    $cut_line_val = $corner_x + $corner_y + $chamfer_leg;
    
    // Polygon vertices (2D):
    // Start at the cut line on the X-axis side: ($corner_x + $chamfer_leg, $corner_y)
    // Go to the cut line on the Y-axis side: ($corner_x, $corner_y + $chamfer_leg)
    // Then extend far out to cover the corner area.
    // Let's pick a large box that definitely contains the corner.
    $large_x = $corner_x + $chamfer_leg + 100;
    $large_y = $corner_y + $chamfer_leg + 100;
    
    // The polygon should be:
    // ($corner_x + $chamfer_leg, $corner_y) -> ($corner_x, $corner_y + $chamfer_leg) -> ($large_x, $large_y) -> ($large_x, $corner_y) -> ($corner_x + $chamfer_leg, $corner_y)
    // Wait, this doesn't form a closed loop correctly for the "cut" shape.
    // We want to keep the part where X + Y < $cut_line_val.
    // So we cut the part where X + Y > $cut_line_val.
    // The polygon representing the "cut" region must include the corner ($corner_x, $corner_y).
    // Vertices:
    // 1. ($corner_x + $chamfer_leg, $corner_y)
    // 2. ($corner_x, $corner_y + $chamfer_leg)
    // 3. ($large_x, $large_y)
    //