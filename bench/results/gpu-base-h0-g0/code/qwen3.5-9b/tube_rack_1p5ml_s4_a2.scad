// Bench Rack for 1.5 mL Microcentrifuge Tubes
// Designed to rest on the XY plane at z = 0.

// Block Dimensions
$block_length = 106; // X
$block_width = 72;   // Y
$block_height = 30;  // Z

// Hole Grid Configuration
$hole_count_x = 6;   // Holes along X
$hole_count_y = 4;   // Holes along Y
$hole_spacing_x = 16; // Centre-to-centre spacing X
$hole_spacing_y = 16; // Centre-to-centre spacing Y

// Hole Dimensions
$hole_diameter = 11.2;
$hole_depth = 25;    // Depth of the hole (open top, closed bottom)
$floor_thickness = 5; // Solid floor thickness at bottom (30 - 25 = 5)

// Quality Settings
$fn = 64;

// --- Main Block ---
block = cube([
    $block_length,
    $block_width,
    $block_height
], center = true);

// --- Hole Generation ---
// Calculate grid start positions to center the grid on the block
$grid_span_x = ($hole_count_x - 1) * $hole_spacing_x;
$grid_span_y = ($hole_count_y - 1) * $hole_spacing_y;
$offset_x = ($block_length - $grid_span_x) / 2;
$offset_y = ($block_width - $grid_span_y) / 2;

// Create holes using difference
// Holes are cylinders with a flat bottom at z = $floor_thickness
// We extend the cutting cylinder slightly past the bottom face to ensure clean cutting
$cutting_depth = $hole_depth + 0.5; 

difference() {
    union() {
        block;
    }
    
    for (i = [0 : $hole_count_x - 1]) {
        for (j = [0 : $hole_count_y - 1]) {
            // Calculate position of current hole
            $pos_x = $offset_x + i * $hole_spacing_x;
            $pos_y = $offset_y + j * $hole_spacing_y;
            
            // Define the cutting cylinder
            // Centered at ($pos_x, $pos_y, $block_height/2)
            // Extends from top to below the floor
            hole_cutter = cylinder(
                h = $cutting_depth,
                r = $hole_diameter / 2,
                center = true
            );
            
            translate([
                $pos_x,
                $pos_y,
                $block_height / 2
            ]) {
                hole_cutter;
            }
        }
    }
}