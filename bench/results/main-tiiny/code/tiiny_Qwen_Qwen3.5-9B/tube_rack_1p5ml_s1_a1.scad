// Bench Rack for 1.5 mL Microcentrifuge Tubes
// Design Parameters based on user specifications

// Block Dimensions (mm)
$block_length = 106; // X dimension
$block_width  = 72;  // Y dimension
$block_height = 30;  // Z dimension

// Hole Grid Parameters
$hole_count_x = 6;   // Holes along X (6 per row)
$hole_count_y = 4;   // Rows along Y (4 rows)
$hole_spacing = 16;  // Centre-to-centre spacing (mm)
$hole_diameter = 11.2; // Hole diameter (mm)
$hole_depth = 25;    // Hole depth (mm)

// Geometry Setup
$fn = 64; // Ensure smooth circular holes

// Calculate Grid Offset to Center the Grid on the Block
// Total span X = (count - 1) * spacing
// Offset X = - (Total Span / 2) to center the first hole relative to the block center
$offset_x = - (($hole_count_x - 1) * $hole_spacing / 2);
$offset_y = - (($hole_count_y - 1) * $hole_spacing / 2);

module tube_rack() {
    // 1. Create the solid rectangular block
    block = cube([
        $block_length, 
        $block_width, 
        $block_height
    ]);

    // 2. Create the holes
    // We use a for loop to generate the grid of holes
    
    // Calculate extension amount to ensure no coplanar faces (Rule 5)
    $extend_amount = 0.5; 
    
    // Calculate the Z position for the center of the holes
    // The hole goes from Z=30 down to Z=5 (depth 25).
    // Center Z = 30 - 25/2 = 17.5
    $hole_center_z = $block_height - ($hole_depth / 2);
    
    // List to hold the cutting cylinders
    $cut_holes = [];
    
    for (row = [0 : $hole_count_y - 1]) {
        for (col = [0 : $hole_count_x - 1]) {
            // Calculate position of current hole center
            x_pos = $offset_x + (col * $hole_spacing);
            y_pos = $offset_y + (row * $hole_spacing);
            
            // Create the hole cylinder with extension
            // Height = depth + 2 * extension (extends past top and bottom)
            h = cylinder(
                h = $hole_depth + (2 * $extend_amount),
                r = $hole_diameter / 2,
                center = [x_pos, y_pos, $hole_center_z]
            );
            
            $cut_holes = concat($cut_holes, [h]);
        }
    }
    
    // 3. Combine Block and Holes
    // Difference: Block minus Cut Holes
    difference() {
        block;
        $cut_holes;
    }
}

// Render the part
tube_rack();