// 96-Well PCR Tube Rack (ANSI/SLAS Footprint)
// Designed for FDM 3D printing.
// Orientation: Rests on XY plane at Z=0, builds upward.
// Centred on origin in X and Y.

// --- Dimensions (mm) ---
// Block Dimensions
$block_length = 127.76; // X
$block_width  = 85.48;  // Y
$block_height = 20.0;   // Z

// Hole Dimensions
$hole_diameter = 6.2;
$hole_radius   = $hole_diameter / 2;

// Grid Configuration
$grid_rows    = 8; // Along Y
$grid_cols    = 12; // Along X
$spacing_x    = 9.0; // Centre-to-centre X
$spacing_y    = 9.0; // Centre-to-centre Y

// Grid Positioning (from left/back edge)
$offset_x_start = 14.38;
$offset_y_start = 11.24;

// Chamfer Dimensions
$chamfer_leg   = 5.0;
$chamfer_angle = 45;

// Quality Settings
$fn = 64; // Ensure smooth holes and chamfers

// --- Main Module ---
module pcr_rack() {
    // Calculate block half-dimensions for coordinate calculations
    $half_length = $block_length / 2;
    $half_width  = $block_width / 2;

    // 1. Create the main block with chamfered corner
    // We define the top face polygon with the chamfer, then extrude it.
    // The chamfer is at the corner defined by min X and min Y (relative to the block's local corner).
    // Since the block is centered at (0,0), the "back-left" corner is at (-$half_length, -$half_width).
    
    // Define vertices for the top face (Z = $block_height/2)
    // We use a polygon to create the shape, then linear_extrude it.
    // Vertices order: Counter-clockwise for a solid.
    
    // Start at the chamfered corner area
    // Point 1: (-$half_length, -$half_width + $chamfer_leg)
    // Point 2: (-$half_length + $chamfer_leg, -$half_width + $chamfer_leg)
    // Point 3: (-$half_length + $chamfer_leg, -$half_width)
    // Point 4: ($half_length, -$half_width)
    // Point 5: ($half_length, $half_width)
    // Point 6: (-$half_length, $half_width)
    // Point 7: (-$half_length, -$half_width + $chamfer_leg) -> Close loop
    
    // Note: The prompt asks for the chamfer on the "A1 corner". 
    // A1 is defined by offset 14.38 from left and 11.24 from back.
    // This implies A1 is the "first" hole. The corner of the block corresponding to this is the 
    // corner with the minimum X and minimum Y coordinates (assuming standard orientation where 
    // +X is right, +Y is front, and "back" is -Y).
    // So we chamfer the corner at (-$half_length, -$half_width).
    
    $vertices = [
        [-$half_length, -$half_width + $chamfer_leg],
        [-$half_length + $chamfer_leg, -$half_width + $chamfer_leg],
        [-$half_length + $chamfer_leg, -$half_width],
        [$half_length, -$half_width],
        [$half_length, $half_width],
        [-$half_length, $half_width],
        [-$half_length, -$half_width + $chamfer_leg]
    ];

    // Create the block with chamfer using linear_extrude
    // We extrude from Z = -$block_height/2 to Z = $block_height/2 to center it,
    // then we will translate it to Z=0 later if needed, but the prompt says "rests on XY plane at z=0".
    // So we extrude from 0 to $block_height.
    
    block_with_chamfer = linear_extrude(
        h = $block_height,
        center = false, // Vertices are defined relative to (0,0) in the 2D plane
        convexity = 10
    ) polygon($vertices);

    // 2. Create holes
    // We need to subtract cylinders from the block.
    // To ensure clean cuts, we extend the cylinders slightly past the top and bottom faces.
    
    // Calculate hole positions
    // The grid is defined by offsets from the "left edge" and "back edge".
    // Left edge of block is at X = -$half_length.
    // Back edge of block is at Y = -$half_width.
    
    // Hole X positions:
    // Start at $offset_x_start from left edge -> X = -$half_length + $offset_x_start
    // Step by $spacing_x
    // Hole Y positions:
    // Start at $offset_y_start from back edge -> Y = -$half_width + $offset_y_start
    // Step by $spacing_y
    
    $start_x = -$half_length + $offset_x_start;
    $start_y = -$half_width + $offset_y_start;
    
    // Loop and subtract holes
    // We use a difference operation.
    // First, we have the block_with_chamfer.
    // Then we subtract the holes.
    
    final_part = difference() {
        // The main block with chamfer
        translate([0, 0, 0]) block_with_chamfer;
        
        // Subtract holes
        for (row = [0 : $grid_rows - 1], col = [0 : $grid_cols - 1]) {
            $pos_x = $start_x + col * $spacing_x;
            $pos_y = $start_y + row * $spacing_y;
            
            // Cylinder height: block height + extension on both sides
            $ext = 0.5; // 0.5mm extension
            $h = $block_height + ($ext * 2);
            
            // Center of cylinder is at ($pos_x, $pos_y, $block_height/2)
            // Because the block is from Z=0 to Z=$block_height
            cylinder(
                h = $h,
                r = $hole_radius,
                center = [$pos_x, $pos_y, $block_height / 2],
                $fn = $fn
            );
        }
    };

    // Output the final part
    final_part;
}

// Instantiate the module
pcr_rack();