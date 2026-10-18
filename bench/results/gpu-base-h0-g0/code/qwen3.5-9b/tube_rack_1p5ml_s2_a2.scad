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

// Hole configuration
$hole_diameter = 11.2;
$hole_depth = 25;    // Depth of the hole (open top, closed bottom)
$floor_thickness = 5; // Solid floor at bottom (30 - 25 = 5)

// --- Settings ---
$fn = 64; // Smooth curves for holes

// --- Calculations ---
// Calculate offsets to center the grid on the block
// Total grid width = (cols - 1) * spacing
// Offset from edge = (Block Width - Total Grid Width) / 2
$offset_x = ($block_length - ($grid_cols - 1) * $grid_spacing_x) / 2;
$offset_y = ($block_width - ($grid_rows - 1) * $grid_spacing_y) / 2;

// --- Main Block ---
difference() {
    // 1. Create the solid rectangular block at Z=0
    translate([0, 0, 0]) {
        cube([
            $block_length,
            $block_width,
            $block_height
        ]);
    }

    // 2. Cut the holes
    // We iterate through rows (r) and columns (c)
    for (r = [0 : $grid_rows - 1], c = [0 : $grid_cols - 1]) {
        // Calculate position of current hole center relative to block origin (0,0,0)
        $x_pos = $offset_x + c * $grid_spacing_x;
        $y_pos = $offset_y + r * $grid_spacing_y;
        
        // Create the hole cylinder
        $r_hole = $hole_diameter / 2;
        
        // Translate to hole position
        // We place the cylinder such that it cuts through the block.
        // Top of block is Z=30. Bottom of hole is Z=5.
        // We extend the cylinder slightly past the top (30.1) and bottom (4.9) 
        // to ensure clean cuts and non-coplanar faces.
        translate([
            $x_pos,
            $y_pos,
            30.1 // Start slightly above the top surface
        ]) {
            cylinder(
                h = $hole_depth + 0.1, // Height covers 30.1 down to 4.9
                r1 = $r_hole,
                r2 = $r_hole,
                $fn = $fn
            );
        }
    }
}