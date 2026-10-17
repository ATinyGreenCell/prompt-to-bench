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

// --- Settings ---
$fn = 128; // High resolution for smooth holes

// --- Calculation ---
// Calculate grid offsets to center the grid on the block
// Total grid width = (cols - 1) * spacing
// Offset from edge = (Block Width - Total Grid Width) / 2
$grid_offset_x = ($block_length - ($grid_cols - 1) * $grid_spacing_x) / 2;
$grid_offset_y = ($block_width - ($grid_rows - 1) * $grid_spacing_y) / 2;

// --- Main Block ---
difference() {
    // 1. The solid rectangular block
    cube([
        $block_length,
        $block_width,
        $block_height
    ]);

    // 2. The holes
    // We subtract cylinders. To ensure clean cuts, we extend the cylinder slightly past the bottom face.
    // The hole is 25mm deep, block is 30mm. We cut 0.1mm past the bottom.
    $cut_depth = $hole_depth + 0.1; 
    
    for (row = [0 : $grid_rows - 1]) {
        for (col = [0 : $grid_cols - 1]) {
            // Calculate position of this specific hole
            $x_pos = $grid_offset_x + col * $grid_spacing_x;
            $y_pos = $grid_offset_y + row * $grid_spacing_y;
            
            // Cylinder parameters
            // Translate to hole center
            // Rotate -90 around X to make the cylinder axis point in Z (vertical)
            // Radius is half diameter
            translate([
                $x_pos,
                $y_pos,
                0
            ])
            cylinder(
                h = $cut_depth,
                r = $hole_diameter / 2,
                $fn = $fn
            );
        }
    }
}