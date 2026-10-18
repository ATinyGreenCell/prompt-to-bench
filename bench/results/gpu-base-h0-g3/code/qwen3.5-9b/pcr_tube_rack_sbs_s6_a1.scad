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
$chamfer_leg = 5; // Distance along the side faces

// --- Configuration ---
$fn = 64; // Smooth curves

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
        $x = $offset_x + c * $spacing;
        $y = $offset_y + r * $spacing;
        
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
    // In our coordinate system (origin at center of block):
    // Left edge X = -$block_length/2
    // Back edge Y = -$block_width/2
    // The corner is at X = -$block_length/2 + $offset_x, Y = -$block_width/2 + $offset_y.
    
    $corner_x = -$block_length/2 + $offset_x;
    $corner_y = -$block_width/2 + $offset_y;
    
    // We define a cutting plane that slices off the corner.
    // The plane passes through:
    // P1: ($corner_x + $chamfer_leg, $corner_y, $block_height - $chamfer_leg)
    // P2: ($corner_x, $corner_y + $chamfer_leg, $block_height - $chamfer_leg)
    // P3: ($corner_x + $chamfer_leg, $corner_y + $chamfer_leg, $block_height - $chamfer_leg)
    // This creates a 45 degree chamfer where the leg along the vertical edge is $chamfer_leg * sqrt(2).
    // However, the prompt asks for "5 mm legs off the vertical edge".
    // If the leg along the vertical edge (Z) is 5mm, then the legs along X and Y are 5mm * cos(45) = 3.535mm.
    // Let's assume the standard interpretation where the cut removes a triangular prism with legs of 5mm along the X and Y faces of the block.
    // This results in a 45 degree angle.
    
    $cut_leg = $chamfer_leg;
    
    // Define the plane using polygon extrusion
    // The plane is defined by 3 points:
    // Top-Left (on X face): ($corner_x + $cut_leg, $corner_y, $block_height - $cut_leg)
    // Top-Back (on Y face): ($corner_x, $corner_y + $cut_leg, $block_height - $cut_leg)
    // Bottom-Corner (intersection): ($corner_x + $cut_leg, $corner_y + $cut_leg, $block_height - $cut_leg)
    
    // We create a large polygon that represents the cutting plane and extrude it downwards.
    // The polygon vertices:
    // 1. ($corner_x + $cut_leg, $corner_y, $block_height - $cut_leg)
    // 2. ($corner_x, $corner_y + $cut_leg, $block_height - $cut_leg)
    // 3. ($corner_x + $cut_leg, $corner_y + $cut_leg, $block_height - $cut_leg)
    // 4. ($corner_x + $cut_leg, $corner_y + $cut_leg, -100) // Extend far down
    // 5. ($corner_x, $corner_y + $cut_leg, -100)
    // 6. ($corner_x + $cut_leg, $corner_y, -100)
    // 7. ($corner_x, $corner_y, -100)
    // 8. ($corner_x + $cut_leg, $corner_y, $block_height - $cut_leg) // Close loop
    
    // Actually, simpler to define the plane equation and use a large box, but polygon extrude is robust.
    // Let's define the plane points carefully.
    // Point A: ($corner_x + $cut_leg, $corner_y, $block_height - $cut_leg)
    // Point B: ($corner_x, $corner_y + $cut_leg, $block_height - $cut_leg)
    // Point C: ($corner_x + $cut_leg, $corner_y + $cut_leg, $block_height - $cut_leg)
    // Point D: ($corner_x + $cut_leg, $corner_y + $cut_leg, -1000)
    // Point E: ($corner_x, $corner_y + $cut_leg, -1000)
    // Point F: ($corner_x + $cut_leg, $corner_y, -1000)
    // Point G: ($corner_x, $corner_y, -1000)
    // Point H: ($corner_x + $cut_leg, $corner_y, $block_height - $cut_leg)
    
    // Wait, the plane is flat. The points A, B, C are coplanar.
    // The polygon should be:
    // A -> B -> C -> D -> E -> F -> G -> H -> A
    // But H is A. So A -> B -> C -> D -> E -> F -> G -> A.
    
    $plane_points = [
        [$corner_x + $cut_leg, $corner_y, $block_height - $cut_leg],
        [$corner_x, $corner_y + $cut_leg, $block_height - $cut_leg],
        [$corner_x + $cut_leg, $corner_y + $cut_leg, $block_height - $cut_leg],
        [$corner_x + $cut_leg, $corner_y + $cut_leg, -1000],
        [$corner_x, $corner_y + $cut_leg, -1000],
        [$corner_x + $cut_leg, $corner_y, -1000],
        [$corner_x, $corner_y, -1000]
    ];
    
    // Extrude the polygon downwards to cut the block
    linear_extrude(height = 1000, center = false) {
        polygon(points = $plane_points);
    }
}