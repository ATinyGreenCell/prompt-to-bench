// Bench Rack for 1.5 mL Microcentrifuge Tubes
// Design specifications based on user input

// Block Dimensions (mm)
$block_length_x = 106;
$block_width_y = 72;
$block_height_z = 30;

// Grid Configuration
$grid_rows_y = 4;       // Rows along Y
$grid_cols_x = 6;       // Columns along X
$spacing_x = 16;        // Centre-to-centre spacing X
$spacing_y = 16;        // Centre-to-centre spacing Y

// Hole Dimensions (mm)
$hole_diameter = 11.2;
$hole_depth = 25;       // Depth of the hole (open top, closed bottom)

// Quality Settings
$fn = 64; // Ensure smooth holes

// Calculate Grid Origin to Center the Grid on the Block
// Total span X = (cols - 1) * spacing
// Total span Y = (rows - 1) * spacing
// Offset X = (Block Length - Total Span X) / 2
// Offset Y = (Block Width - Total Span Y) / 2

$grid_span_x = ($grid_cols_x - 1) * $spacing_x;
$grid_span_y = ($grid_rows_y - 1) * $spacing_y;

$offset_x = ($block_length_x - $grid_span_x) / 2;
$offset_y = ($block_width_y - $grid_span_y) / 2;

// Main Module: The Bench Rack
module bench_rack() {
    // 1. Create the solid rectangular block
    // Orientation: Rests on XY plane at Z=0, builds upward.
    // Centred on origin in X and Y.
    block = cube([
        $block_length_x, 
        $block_width_y, 
        $block_height_z
    ]);

    // 2. Create the holes
    // We use a loop to generate the cylinder for each hole position.
    // The cylinder is positioned at the correct X, Y and has Z-height = hole_depth.
    // Since we are using difference(), the cylinder will cut into the block.
    // The cylinder extends slightly past the bottom face (Z = -0.01) to ensure clean cutting 
    // without leaving a thin sliver of material at the very bottom floor, 
    // though the prompt asks for a 5mm solid floor, so the cut stops at Z=5.
    // The cylinder extends slightly past the top face (Z = 0.01) to ensure clean cutting.
    
    holes = difference() {
        union() {
            // We need to subtract the holes from the block.
            // To do this cleanly in OpenSCAD without boolean errors on thin walls,
            // we create the block and subtract the holes in a single difference operation.
            // However, the standard pattern is:
            // result = difference(block, hole1, hole2, ...)
            // But since we are generating holes dynamically, we structure it as:
            // result = difference(block, union(holes))
            
            // Let's create the union of all hole cylinders first.
            for (row = [0 : $grid_rows_y - 1]) {
                for (col = [0 : $grid_cols_x - 1]) {
                    // Calculate position of the hole center
                    // X position: offset_x + col * spacing_x
                    // Y position: offset_y + row * spacing_y
                    
                    $x_pos = $offset_x + col * $spacing_x;
                    $y_pos = $offset_y + row * $spacing_y;
                    
                    // Cylinder parameters
                    // Radius = diameter / 2
                    // Height = hole_depth
                    // Position: ($x_pos, $y_pos, $hole_depth / 2) to center it vertically in the cut zone?
                    // No, the hole is 25mm deep. The block is 30mm.
                    // The hole goes from Z=0 down to Z=25.
                    // So the cylinder center Z should be 12.5.
                    
                    $z_pos = $hole_depth / 2;
                    
                    $r = $hole_diameter / 2;
                    
                    // Create the cylinder
                    // We extend slightly past the top (Z=0.01) and bottom (Z=-0.01 relative to cut start)
                    // to ensure clean faces in the difference operation.
                    // The cut is from Z=0 to Z=25.
                    // Cylinder Z range: -0.01 to 25.01
                    
                    h = $hole_depth + 0.02; // Slight extension
                    
                    translate([
                        $x_pos, 
                        $y_pos, 
                        $z_pos - 0.01 // Shift down so top is at -0.01 relative to center, effectively Z=-0.01 absolute
                    ]) {
                        cylinder(
                            h = h,
                            r = $r,
                            $fn = $fn
                        );
                    }
                }
            }
        }
    };
    
    // Combine block and holes
    difference() {
        block;
        holes;
    }
}

// Render the part
bench_rack();