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
// then translate the whole assembly to sit on Z=0.

// Grid step size
$step_x = $spacing;
$step_y = $spacing;

// Grid dimensions
$grid_width  = ($cols - 1) * $step_x;
$grid_height = ($rows - 1) * $step_y;

// Grid centre relative to A1
$grid_centre_x = $offset_x + ($grid_width / 2);
$grid_centre_y = $offset_y + ($grid_height / 2);

// --- Main Block ---
// Create the main block centred at (0,0) in X,Y for easy rotation/extrusion if needed,
// but we will translate it to the final position.
// To ensure it rests on Z=0, we define the block from Z=0 to Z=$block_height.

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
            $pos_x_local = $offset_x + (c * $step_x);
            $pos_y_local = $offset_y + (r * $step_y);
            
            // Translate to global coordinates (block is centred at 0,0)
            $pos_x_global = $pos_x_local - ($block_length / 2);
            $pos_y_global = $pos_y_local - ($block_width / 2);
            
            translate([$pos_x_global, $pos_y_global, 0])
            cylinder(
                h = $block_height + 0.5, // Extend slightly past top/bottom for clean cut
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
    
    // Define the chamfer plane.
    // We want to cut off the corner defined by the plane passing through:
    // 1. ($corner_x + $chamfer_leg, $corner_y, 0)
    // 2. ($corner_x, $corner_y + $chamfer_leg, 0)
    // 3. ($corner_x, $corner_y, $chamfer_leg)
    // This creates a 45 degree chamfer on the vertical edge.
    
    // We construct a large plane that cuts through these three points.
    // Normal vector calculation:
    // Vector 1: ($chamfer_leg, 0, 0)
    // Vector 2: (0, $chamfer_leg, 0)
    // Vector 3: (0, 0, $chamfer_leg)
    // The plane normal is roughly (1, 1, 1).
    
    // To make the cut, we create a polygon that covers the corner and extends far enough.
    // Points for the cutting polygon (counter-clockwise looking from outside):
    // Start far away in X, go to corner+leg, go to corner+leg, go to corner+leg, go far away in Y, close loop.
    
    // Let's define the cutting shape explicitly.
    // We need a shape that intersects the corner.
    // Vertices:
    // 1. Far X, Far Y (outside the block)
    // 2. ($corner_x + $chamfer_leg, $corner_y + $chamfer_leg, 0) -> This is the corner of the chamfer on the top surface? No.
    //    The chamfer leg is 5mm.
    //    Point A (on X axis): ($corner_x + $chamfer_leg, $corner_y, 0)
    //    Point B (on Y axis): ($corner_x, $corner_y + $chamfer_leg, 0)
    //    Point C (on Z axis): ($corner_x, $corner_y, $chamfer_leg)
    //    Point D (top surface intersection): ($corner_x + $chamfer_leg, $corner_y + $chamfer_leg, 0) -- Wait, this is not right for a 45 deg chamfer on a vertical edge.
    
    // Correct Geometry for 45 deg chamfer on vertical edge:
    // The cut removes the material where x < $corner_x + leg AND y < $corner_y + leg AND z < leg + (x - corner_x) + (y - corner_y)?
    // Actually, a simple plane cut works best.
    // Plane equation: (x - $corner_x) + (y - $corner_y) + (z - 0) = $chamfer_leg?
    // Let's check points:
    // If x = $corner_x + $chamfer_leg, y = $corner_y, z = 0 -> ($chamfer_leg) + 0 + 0 = $chamfer_leg. Correct.
    // If x = $corner_x, y = $corner_y + $chamfer_leg, z = 0 -> 0 + ($chamfer_leg) + 0 = $chamfer_leg. Correct.
    // If x = $corner_x, y = $corner_y, z = $chamfer_leg -> 0 + 0 + $chamfer_leg = $chamfer_leg. Correct.
    // So the plane is x + y + z = $corner_x + $corner_y + $chamfer_leg.
    
    // We create a large polygon representing this plane, shifted so it cuts the corner.
    // We need to cover the entire face of the block to ensure the cut goes all the way through.
    
    $plane_offset = $corner_x + $corner_y + $chamfer_leg;
    
    // Define a large polygon that represents the cutting plane.
    // We need to cover the area from the block boundaries to infinity in the direction of the normal (1,1,1).
    // The normal points towards positive X, positive Y, positive Z.
    // We want to keep the material where x + y + z < $plane_offset.
    // So we cut with a shape where x + y + z > $plane_offset.
    
    // Let's define the vertices of the cutting polygon.
    // We need to cover the top face, front face, and left face near the corner.
    // Let's pick a large bounding box for the polygon to ensure it covers the whole block.
    $poly_size = 200; // Large enough to cover the block
    
    // Vertices of the cutting plane polygon (counter-clockwise from outside