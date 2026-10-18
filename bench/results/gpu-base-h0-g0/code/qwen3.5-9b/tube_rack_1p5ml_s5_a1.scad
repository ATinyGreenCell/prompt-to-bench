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

// --- Main Block ---
difference() {
    // 1. The solid rectangular block
    // Defined from Z=0 to Z=30
    cube([
        $block_length,
        $block_width,
        $block_height
    ]);

    // 2. The holes
    // We subtract cylinders. 
    // To cut a hole 25mm deep starting from the top (Z=30) down to Z=5:
    // The cylinder must start at Z=30 and extend downwards.
    // We add 0.01mm to the height to ensure the cutter extends past the bottom of the hole 
    // to avoid coplanar faces (Rule 5).
    $cut_height = $hole_depth + 0.01; 
    
    for (i = [0 : $hole_count_x - 1]) {
        for (j = [0 : $hole_count_y - 1]) {
            // Calculate position for current hole
            // Grid is centered on the block
            $x_pos = -($block_length / 2) + ($hole_spacing * ($hole_count_x - 1)) / 2 + (i * $hole_spacing);
            $y_pos = -($block_width / 2) + ($hole_spacing * ($hole_count_y - 1)) / 2 + (j * $hole_spacing);
            
            // Cylinder parameters
            $r = $hole_diameter / 2;
            
            // Translate to position. 
            // Top of cylinder is at Z = $block_height (30).
            // Cylinder extends down by $cut_height.
            translate([
                $x_pos,
                $y_pos,
                $block_height
            ]) {
                cylinder(
                    h = $cut_height,
                    r1 = $r,
                    r2 = $r,
                    $fn = $fn
                );
            }
        }
    }
}