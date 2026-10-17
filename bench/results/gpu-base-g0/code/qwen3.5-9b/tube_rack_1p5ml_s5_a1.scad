// Bench Rack for 1.5 mL Microcentrifuge Tubes
// Designed for FDM printing. Rests on XY plane at Z=0.

// --- Dimensions ---
// Block dimensions (mm)
$block_length = 106;
$block_width  = 72;
$block_height = 30;

// Hole grid configuration
$num_rows = 4;   // Along Y
$num_cols = 6;   // Along X
$hole_cc_x = 16; // Centre-to-centre spacing X
$hole_cc_y = 16; // Centre-to-centre spacing Y

// Hole dimensions (mm)
$hole_diameter = 11.2;
$hole_depth    = 25; // Open at top, closed at bottom
$floor_height  = 5;  // Solid floor thickness ($block_height - $hole_depth)

// --- Derived Variables ---
// Calculate grid start positions to center the grid on the block
// Total grid width = (num_cols - 1) * spacing
// Offset from edge = ($block_length - Total grid width) / 2
$grid_width_total = ($num_cols - 1) * $hole_cc_x;
$grid_height_total = ($num_rows - 1) * $hole_cc_y;

$offset_x = ($block_length - $grid_width_total) / 2;
$offset_y = ($block_width - $grid_height_total) / 2;

// Calculate first hole center coordinates
$first_x = $offset_x + $hole_cc_x / 2;
$first_y = $offset_y + $hole_cc_y / 2;

// --- Geometry ---
$fn = 64; // Smooth curves for holes

// 1. Create the solid block
block = cube([
    $block_length,
    $block_width,
    $block_height
], center = true);

// 2. Create the holes
// We use a loop to generate the cutting shapes.
// The holes are cylinders with a flat bottom.
// To ensure clean cutting, we extend the cylinder slightly past the bottom face.
hole_depth_cut = $hole_depth + 0.5; // Extend 0.5mm past the bottom

// Store hole definitions in a list to iterate later
hole_list = [];

for (r = [0:$num_rows-1], c = [0:$num_cols-1]) {
    // Calculate center of current hole
    $cx = $first_x + c * $hole_cc_x;
    $cy = $first_y + r * $hole_cc_y;
    
    // Create cylinder centered at ($cx, $cy, $block_height/2)
    // We translate it so its bottom is at Z = $floor_height - 0.5 (to cut through)
    // Cylinder height needs to cover from top ($block_height) down to slightly below floor.
    // Actually, simpler: Center cylinder at ($cx, $cy, $block_height/2)
    // Height = $hole_depth + 0.5.
    // Top will be at $block_height + 0.25, Bottom at $block_height - $hole_depth - 0.25.
    // This ensures it cuts through the top and the floor.
    
    translate([
        $cx,
        $cy,
        ($block_height / 2) - ($hole_depth / 2) - 0.25
    ])
    cylinder(
        h = $hole_depth + 0.5,
        d = $hole_diameter,
        $fn = $fn
    );
    
    // Add to list (implicitly handled by the loop in difference below)
}

// 3. Combine
// Union the block with the holes (which act as negative space in the difference)
// Since we are using difference(), we put the block first, then subtract the holes.
// We reconstruct the loop inside difference to pass the translated cylinders.

difference() {
    union() {
        block;
    }
    
    // Subtract each hole
    for (r = [0:$num_rows-1], c = [0:$num_cols-1]) {
        // Calculate center of current hole
        $cx = $first_x + c * $hole_cc_x;
        $cy = $first_y + r * $hole_cc_y;
        
        // Create cylinder centered at ($cx, $cy, $block_height/2)
        translate([
            $cx,
            $cy,
            ($block_height / 2) - ($hole_depth / 2) - 0.25
        ])
        cylinder(
            h = $hole_depth + 0.5,
            d = $hole_diameter,
            $fn = $fn
        );
    }
}