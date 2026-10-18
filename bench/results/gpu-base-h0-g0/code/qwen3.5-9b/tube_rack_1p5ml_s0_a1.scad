// Bench Rack for 1.5 mL Microcentrifuge Tubes
// Designed for FDM printing. Rests on XY plane at Z=0.

// --- Dimensions ---
// Block dimensions
$block_length = 106; // X
$block_width = 72;   // Y
$block_height = 30;  // Z

// Grid configuration
$grid_rows = 4;      // Rows along Y
$grid_cols = 6;      // Columns along X
$grid_spacing_x = 16; // Centre-to-centre X
$grid_spacing_y = 16; // Centre-to-centre Y

// Hole specifications
$hole_diameter = 11.2;
$hole_depth = 25;    // Depth of the hole (open top, closed bottom)
$floor_thickness = 5; // Solid floor at bottom (30mm total - 25mm hole = 5mm)

// --- Geometry Generation ---

// Calculate grid positions relative to the block center
// The grid is centred on the block.
// Offset to center the grid within the block dimensions
$offset_x = ($block_length - ($grid_cols - 1) * $grid_spacing_x) / 2;
$offset_y = ($block_width - ($grid_rows - 1) * $grid_spacing_y) / 2;

// --- Main Block ---
// Create the solid rectangular block
block = cube([
    $block_length,
    $block_width,
    $block_height
], center = true);

// --- Holes ---
// Create holes using difference.
// To ensure clean cuts, we extend the cutting cylinder slightly past the faces.
// Top face is at Z = $block_height/2. We extend 0.1mm past it.
// Bottom face is at Z = -$block_height/2. We stop at -$block_height/2 + $floor_thickness - 0.1mm.
$fn = 64; // Ensure round holes

difference() {
    union() {
        block;
        
        // We will subtract the holes here. 
        // Since we are inside a difference(), we just need to define the cutting shapes.
        // However, to strictly follow the rule "extend past faces", we define the cutter 
        // relative to the block's local coordinates.
        
        for (r = [0 : $grid_rows - 1]) {
            for (c = [0 : $grid_cols - 1]) {
                $cx = $offset_x + c * $grid_spacing_x;
                $cy = $offset_y + r * $grid_spacing_y;
                
                // Define the cutter cylinder
                // Top extends 0.1mm past the top surface
                // Bottom stops 0.1mm before the bottom surface of the floor
                $cutter_height = $hole_depth + 0.1; 
                
                // Translate to hole center
                // The block is centered at 0,0.
                translate([
                    $cx,
                    $cy,
                    $block_height/2 - $cutter_height/2
                ]) {
                    cylinder(
                        h = $cutter_height,
                        r = $hole_diameter / 2,
                        $fn = 64
                    );
                }
            }
        }
    }
}