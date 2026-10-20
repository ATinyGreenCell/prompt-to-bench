// 96-Well PCR Tube Rack
// Designed for FDM 3D printing.
// Orientation: Rests on XY plane (Z=0), builds upward (+Z).
// Centred on origin in X and Y.

$fn = 128; // High resolution for chamfers and hole quality

// --- Dimensions (mm) ---
// Block Dimensions
$block_length_X = 127.76;
$block_width_Y = 85.48;
$block_height_Z = 20;

// Hole Specifications
$hole_diameter = 6.2;
$hole_spacing_X = 9.0;
$hole_spacing_Y = 9.0;

// Grid Positioning (Distance from edges to first hole center)
$offset_X = 14.38;
$offset_Y = 11.24;

// Chamfer Specifications
$chamfer_leg = 5;
$chamfer_angle = 45;

// --- Calculations ---
// Calculate block center offsets to align grid with block center
$center_X = ($block_length_X - ($offset_X + ($hole_spacing_X * 11) + ($hole_diameter / 2))) / 2;
$center_Y = ($block_width_Y - ($offset_Y + ($hole_spacing_Y * 7) + ($hole_diameter / 2))) / 2;

// --- Main Module ---
module PCR_Rack() {
    // 1. Create the main block
    block = cube([
        $block_length_X,
        $block_width_Y,
        $block_height_Z
    ]);

    // 2. Create the 96 holes
    // We use a for loop to generate the 12 columns (X) and 8 rows (Y)
    // We perform the subtraction directly in the difference block below
    
    // 3. Apply the 45-degree chamfer at the A1 corner
    // A1 is the bottom-left-front corner in standard plate orientation.
    // In our model (centred on origin, Z up):
    // X increases to the right. Y increases "forward" (away from back edge).
    // The "back edge" is the negative Y side relative to the grid offset logic if we viewed from top, 
    // but physically, the block is 85.48 wide. The grid starts 11.24mm from the "back".
    
    // A1 Corner Absolute Coordinates (Center of the first hole):
    // X_start = Center_X - Offset_X + HoleRadius
    // Y_start = Center_Y - Offset_Y + HoleRadius
    
    $corner_x_abs = $center_X - $offset_X + ($hole_diameter / 2);
    $corner_y_abs = $center_Y - $offset_Y + ($hole_diameter / 2);
    
    // Define the chamfer cutter. 
    // We want to cut a 45 deg chamfer on the vertical edge at ($corner_x_abs, $corner_y_abs).
    // The cut should remove material where X < $corner_x_abs + $chamfer_leg AND Y < $corner_y_abs + $chamfer_leg.
    
    // Create the chamfer wedge shape
    chamfer_wedge = translate([
        $corner_x_abs - $chamfer_leg, 
        $corner_y_abs - $chamfer_leg, 
        0
    ])
    linear_extrude(height = $block_height_Z + 10, center = true)
    polygon([
        [0, 0],
        [$chamfer_leg, 0],
        [$chamfer_leg, $chamfer_leg],
        [0, $chamfer_leg]
    ]);

    // Final Construction: Block - (Holes U Chamfer)
    difference() {
        // Start with the block
        union() {
            block;
        }
        
        // Subtract Holes
        for (row = [0:7], col = [0:11]) {
            // Calculate position of the hole center relative to the block corner (A1)
            pos_x = $offset_X + (col * $hole_spacing_X);
            pos_y = $offset_Y + (row * $hole_spacing_Y);
            
            translate([pos_x, pos_y, 0]) 
                cylinder(
                    h = $block_height_Z + 1, // Extend slightly past top/bottom for clean cut
                    r = $hole_diameter / 2,
                    $fn = 64
                );
        }
        
        // Subtract Chamfer
        chamfer_wedge;
    }
}

// Instantiate the part
PCR_Rack();