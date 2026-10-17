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
$fn = 64; // Smooth curves

// --- Calculations ---
// Calculate grid offsets to center the grid on the block
// Total grid width = (cols - 1) * spacing
// Offset = (BlockWidth - TotalGridWidth) / 2
$grid_offset_x = ($block_length - ($grid_cols - 1) * $grid_spacing_x) / 2;
$grid_offset_y = ($block_width - ($grid_rows - 1) * $grid_spacing_y) / 2;

// --- Main Block ---
difference() {
    // 1. Create the solid rectangular block
    block = cube([
        $block_length,
        $block_width,
        $block_height
    ]);

    // 2. Create holes using a loop
    // We subtract cylinders from the block.
    // To ensure clean cuts, we extend the cylinder slightly past the block faces.
    for (r = [0 : $grid_rows - 1]) {
        for (c = [0 : $grid_cols - 1]) {
            // Calculate position of current hole center
            $x_pos = $grid_offset_x + c * $grid_spacing_x;
            $y_pos = $grid_offset_y + r * $grid_spacing_y;
            
            // Cylinder parameters
            // Radius
            $r_hole = $hole_diameter / 2;
            // Height: We need to cut through the top surface and down to the floor.
            // The block is 30mm high. The hole is 25mm deep.
            // We extend the cylinder 0.1mm past the top (Z=30) and bottom (Z=0) to ensure clean cuts.
            $cyl_height = $block_height + 0.1; 
            
            hole = cylinder(
                h = $cyl_height,
                r = $r_hole,
                center = [true, true, true]
            );
            
            // Translate hole to correct position
            // Center the cylinder on the calculated X/Y, and span the full Z
            translate([
                $x_pos,
                $y_pos,
                0
            ]) {
                difference() {
                    // The block is the reference here, but since we are inside a difference()
                    // with the main block, we just need to subtract the cylinder shape.
                    // However, to be safe with boolean operations in OpenSCAD, 
                    // we define the cutter as a solid that intersects the block.
                    
                    // We use a temporary union to ensure the cutter is a single solid
                    // that spans the full height, then subtract it.
                    union() {
                        // Top cap (slightly above block)
                        translate([0, 0, $block_height + 0.05]) 
                            cylinder(h = 0.1, r = $r_hole + 0.1);
                        
                        // Main shaft
                        cylinder(h = $block_height, r = $r_hole + 0.1);
                        
                        // Bottom cap (slightly below block)
                        translate([0, 0, -0.05]) 
                            cylinder(h = 0.1, r = $r_hole + 0.1);
                    }
                }
            }
        }
    }
    
    // Subtract the defined hole geometry from the block
    // Note: The logic above inside the loop was slightly redundant with the outer difference().
    // Let's refactor for clarity and robustness:
    // We will create the block, then subtract the holes defined in the loop.
}

// Refactored approach for clarity:
// 1. Define the block.
// 2. Define the holes.
// 3. Subtract holes from block.

difference() {
    // The Main Block
    translate([0, 0, 0])
        cube([
            $block_length,
            $block_width,
            $block_height
        ]);

    // The Holes
    for (r = [0 : $grid_rows - 1]) {
        for (c = [0 : $grid_cols - 1]) {
            $x_pos = $grid_offset_x + c * $grid_spacing_x;
            $y_pos = $grid_offset_y + r * $grid_spacing_y;
            
            // Cutter: Cylinder extending slightly beyond the block faces
            translate([
                $x_pos,
                $y_pos,
                0
            ]) {
                difference() {
                    // We subtract a cylinder that is slightly larger than the hole
                    // and extends slightly past the top and bottom faces.
                    cylinder(
                        h = $block_height + 0.1,
                        r = ($hole_diameter / 2) + 0.1,
                        center = [true, true, true]
                    );
                }
            }
        }
    }
}