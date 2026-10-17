// 96-Well PCR Tube Rack (0.2 mL)
// Designed for FDM 3D printing.
// Orientation: Rests on XY plane at Z=0, builds upward.
// Centred on origin in X and Y.

// --- Dimensions (mm) ---
// Block dimensions
$block_length = 127.76; // X
$block_width  = 85.48;  // Y
$block_height = 20;     // Z

// Hole specifications
$hole_diameter = 6.2;
$hole_count    = 96;
$rows = 8;
$cols = 12;
$spacing = 9.0; // Centre-to-centre spacing

// Grid positioning (A1 corner offset from block edge)
$offset_x = 14.38;
$offset_y = 11.24;

// Chamfer specifications (Orientation mark at A1 corner)
$chamfer_angle = 45;
$chamfer_leg   = 5;

// Quality settings
$fn = 64;

// --- Calculations ---
// Calculate total grid size to ensure centering
$total_grid_x = ($cols - 1) * $spacing;
$total_grid_y = ($rows - 1) * $spacing;

// Calculate block center
$block_center_x = $block_length / 2;
$block_center_y = $block_width / 2;

// Calculate grid center based on A1 offset
// Grid center X = Offset X + (Total Grid X / 2)
$grid_center_x = $offset_x + ($total_grid_x / 2);
// Grid center Y = Offset Y + (Total Grid Y / 2)
$grid_center_y = $offset_y + ($total_grid_y / 2);

// Calculate translation to move grid center to block center
$grid_offset_x = $block_center_x - $grid_center_x;
$grid_offset_y = $block_center_y - $grid_center_y;

// --- Main Block ---
difference() {
    // 1. Main Block
    cube([
        $block_length,
        $block_width,
        $block_height
    ], center = true);

    // 2. Holes
    // We subtract cylinders. To ensure clean cuts, we extend slightly past the faces.
    // Since holes go all the way through, we extend slightly in Z (top and bottom).
    $hole_extension = 0.5; 
    
    for (r = [0 : $rows - 1], c = [0 : $cols - 1]) {
        // Calculate hole position relative to grid center
        $hole_x = $grid_center_x + (c * $spacing) + $grid_offset_x;
        $hole_y = $grid_center_y + (r * $spacing) + $grid_offset_y;
        
        translate([
            $hole_x,
            $hole_y,
            -$block_height/2 - $hole_extension
        ]) {
            cylinder(
                h = $block_height + ($hole_extension * 2),
                d = $hole_diameter,
                $fn = $fn
            );
        }
    }

    // 3. Chamfer at A1 corner
    // A1 is the top-left-front corner in standard plate notation (Row 1, Col 1).
    // In our coordinate system (centered):
    // X increases to the right. Y increases towards the back (positive Y).
    // A1 is at min X, min Y relative to the grid.
    // We need to chamfer the vertical edge at (min X, min Y).
    
    // Define the corner point in local block coordinates (uncentered)
    // Min X = -Length/2 + Offset_X
    // Min Y = -Width/2 + Offset_Y
    $corner_x = -$block_length/2 + $offset_x;
    $corner_y = -$block_width/2 + $offset_y;
    
    // The chamfer is on the vertical edge. We cut a pyramid or wedge.
    // To cut a 45 deg chamfer with leg 5mm on the vertical edge:
    // We define a plane that cuts the corner.
    // Normal vector of the cut face: (-1, -1, 0) normalized? 
    // Actually, we want to remove material where X < corner_x + leg AND Y < corner_y + leg.
    // The cut face connects (corner_x+leg, corner_y, z) to (corner_x, corner_y+leg, z).
    
    // We will use a large prism with a slanted face to cut the corner.
    // The cut face equation roughly: (X - corner_x) + (Y - corner_y) = leg (for 45 deg).
    // We need to subtract this shape.
    
    // Define the cutting shape
    // It should cover the entire height of the block.
    // Base on XY plane: A triangle or square corner cut.
    // Let's create a shape that is a square [0, leg] x [0, leg] but with a diagonal cut.
    // Actually, simpler: Create a shape that is the "missing" corner.
    // The missing corner is defined by the plane passing through:
    // P1: (corner_x + leg, corner_y, 0)
    // P2: (corner_x, corner_y + leg, 0)
    // P3: (corner_x + leg, corner_y, $block_height)
    // P4: (corner_x, corner_y + leg, $block_height)
    
    // We can construct this using polygon extrusion or a large cube with a difference.
    // Let's use a large cube that represents the "void" we want to create, but with a slanted face.
    // Easier approach: Use a large cylinder or cube rotated? No.
    // Use `polygon` with `linear_extrude`.
    
    // Points for the top face of the cut (at Z = block_height)
    // We want to cut off the corner. The remaining material should be outside the cut.
    // The cut removes the region where X < corner_x + leg AND Y < corner_y + leg AND (X-corner_x) + (Y-corner_y) < leg.
    
    // Let's define the vertices of the wedge to be subtracted.
    // Bottom face (Z=0): Triangle with vertices:
    // (corner_x + leg, corner_y, 0), (corner_x, corner_y + leg, 0), (corner_x + leg, corner_y + leg, 0)
    // Wait, the cut is 45 degrees. The hypotenuse connects (corner_x+leg, corner_y) and (corner_x, corner_y+leg).
    // So the triangle vertices are:
    // A: (corner_x + leg, corner_y, 0)
    // B: (corner_x, corner_y + leg, 0)
    // C: (corner_x + leg, corner_y + leg, 0) -> This point is inside the cut?
    // Let's visualize:
    // Corner is at (0,0). Leg is 5.
    // Cut line: x + y = 5.
    // Region to remove: x < 5, y < 5, x + y < 5.
    // Vertices of the triangle on Z=0: (5,0), (0,5), (0,0).
    // Yes.
    
    // Top face (Z=block_height): Same triangle.
    // Side face: Connects (5,0,0) to (5,0,20) to (0,5,20) to (0,5,0). This is a vertical wall?
    // No, the chamfer is slanted.
    // The cut face connects (5,0,0) to (0,5,0) to (0,5,20) to (5,0,20).
    // This creates a slanted plane.
    
    // So the shape to subtract is a prism with a triangular base.
    // Base vertices (counter-clockwise for right hand rule, looking from outside):
    // (corner_x + leg, corner_y, 0)
    // (corner_x, corner_y + leg, 0)
    // (corner_x, corner_y + leg, $block_height)
    // (corner_x + leg, corner_y, $block_height)
    // (corner_x + leg, corner_y, 0)
    
    // Wait, the side face connecting (5,0,0) and (0,5,0) is the slanted face.
    // The other faces are vertical walls at x=5 and y=5?
    // No, if we just extrude the triangle (5,0)-(0,5)-(0,0) upwards, we get a vertical wall on the hypotenuse.
    // That is exactly what we want for a chamfer.
    // The triangle vertices are:
    // V1: (corner_x + leg, corner_y, 0)
    // V2: