// Bench Rack for 1.5 mL Microcentrifuge Tubes
// Designed for FDM printing. Rests on XY plane at Z=0.

// --- Dimensions ---
// Block dimensions
$block_length = 106; // X
$block_width  = 72;  // Y
$block_height = 30;  // Z

// Hole grid configuration
$hole_count_x = 6;   // Holes along X
$hole_count_y = 4;   // Holes along Y
$hole_spacing = 16;  // Centre-to-centre spacing (X and Y)

// Hole dimensions
$hole_diameter = 11.2; // mm
$hole_depth    = 25;   // mm (open top, closed bottom)
$floor_height  = 5;    // mm (solid floor thickness)

// Print settings
$fn = 64; // Smoothness for holes

// --- Calculations ---
// Determine block center
$cx = $block_length / 2;
$cy = $block_width / 2;

// Calculate hole positions to center the grid
// Step size is spacing. We need to offset so the first hole is at -step/2 relative to grid center
$offset_x = ($hole_spacing * ($hole_count_x - 1)) / 2;
$offset_y = ($hole_spacing * ($hole_count_y - 1)) / 2;

// --- Main Block ---
difference() {
    // 1. The solid rectangular block
    cube([
        $block_length,
        $block_width,
        $block_height
    ]);

    // 2. The holes
    // We subtract cylinders. To ensure clean cuts, we extend them slightly past the bottom face (Z=0)
    // The hole depth is 25mm, block height is 30mm. We cut 1mm extra to ensure no coplanar faces.
    $cut_depth = $hole_depth + 1; 
    
    for (i = [0 : $hole_count_x - 1]) {
        for (j = [0 : $hole_count_y - 1]) {
            // Calculate position for current hole
            $x_pos = -($block_length / 2) + $offset_x + (i * $hole_spacing);
            $y_pos = -($block_width / 2) + $offset_y + (j * $hole_spacing);
            
            // Cylinder parameters
            $r = $hole_diameter / 2;
            
            // Translate to position, extend downwards by cut_depth
            translate([
                $x_pos,
                $y_pos,
                -$cut_depth
            ]) {
                cylinder(
                    h = $cut_depth,
                    r1 = $r,
                    r2 = $r,
                    $fn = $fn
                );
            }
        }
    }
}