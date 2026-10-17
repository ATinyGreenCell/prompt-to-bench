// Bench Rack for 1.5 mL Microcentrifuge Tubes
// Designed to rest on the XY plane at z = 0.

// Block Dimensions
$block_length = 106; // X
$block_width = 72;   // Y
$block_height = 30;  // Z

// Hole Grid Configuration
$hole_count_x = 6;   // Holes along X
$hole_count_y = 4;   // Holes along Y
$hole_spacing_x = 16; // Centre-to-centre distance X
$hole_spacing_y = 16; // Centre-to-centre distance Y

// Hole Dimensions
$hole_diameter = 11.2;
$hole_depth = 25;    // Depth of the hole (open top, closed bottom)
$floor_thickness = 5; // Solid floor thickness at bottom (30 - 25 = 5)

// Rendering settings for smooth curves
$fn = 64;

// Calculate grid positions
// Grid is centred on the block.
// Offset from edge to first hole centre:
$offset_x = ($block_length - ($hole_count_x - 1) * $hole_spacing_x) / 2;
$offset_y = ($block_width - ($hole_count_y - 1) * $hole_spacing_y) / 2;

// Generate hole positions
$hole_positions = [];
for (i = [0 : $hole_count_x - 1]) {
    for (j = [0 : $hole_count_y - 1]) {
        $x = $offset_x + i * $hole_spacing_x;
        $y = $offset_y + j * $hole_spacing_y;
        $hole_positions.push([[$x, $y]]);
    }
}

// Main Block
difference() {
    // 1. Create the solid rectangular block
    block = cube([
        $block_length,
        $block_width,
        $block_height
    ]);

    // 2. Create holes
    // Holes are cylinders with a flat bottom.
    // To ensure clean cutting, we extend the cylinder slightly past the bottom face.
    $cut_extension = 0.1; 
    
    for (pos = $hole_positions) {
        [x, y] = pos[0];
        
        // Cylinder parameters
        // Radius
        $r = $hole_diameter / 2;
        // Height of the cylinder (depth + extension)
        $h = $hole_depth + $cut_extension;
        
        // Position the cylinder:
        // Top of hole is at z = $block_height
        // Bottom of hole is at z = $block_height - $hole_depth
        // We extrude downwards from the top surface.
        translate([x, y, $block_height])
            cylinder(
                h = $h,
                r = $r,
                $fn = $fn
            );
    }
    
    block;
}