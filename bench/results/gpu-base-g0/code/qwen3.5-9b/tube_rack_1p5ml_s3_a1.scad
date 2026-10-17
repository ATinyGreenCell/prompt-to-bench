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
// Calculate grid offsets to center the grid on the block
// Total grid width = (cols - 1) * spacing
// Offset = (BlockWidth - TotalGridWidth) / 2
$grid_offset_x = ($block_length - ($grid_cols - 1) * $grid_spacing_x) / 2;
$grid_offset_y = ($block_width - ($grid_rows - 1) * $grid_spacing_y) / 2;

// --- Main Geometry ---
difference() {
    // 1. Create the solid rectangular block
    // Dimensions: 106 x 72 x 30
    // Position: Centered at X=0, Y=0, Z=15 (so it sits on Z=0)
    translate([0, 0, 0])
        cube([
            $block_length,
            $block_width,
            $block_height
        ]);

    // 2. Create holes using a loop
    // We subtract cylinders from the block.
    // To ensure clean cuts, we extend the cylinder slightly past the hole diameter.
    // The height of the cutter must match the block height exactly to cut through.
    $cutter_radius = ($hole_diameter / 2) + 0.1;
    $cutter_height = $block_height;

    for (r = [0 : $grid_rows - 1]) {
        for (c = [0 : $grid_cols - 1]) {
            // Calculate position of current hole center
            $x_pos = $grid_offset_x + c * $grid_spacing_x;
            $y_pos = $grid_offset_y + r * $grid_spacing_y;
            
            // Cylinder parameters
            // The cylinder is centered at Z=15 (middle of the 30mm block)
            // It extends from Z=0 to Z=30.
            translate([
                $x_pos,
                $y_pos,
                0
            ]) {
                cylinder(
                    h = $cutter_height,
                    r = $cutter_radius,
                    center = [true, true, true]
                );
            }
        }
    }
}