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
// Calculate total grid dimensions based on spacing and offsets
$grid_width_X = $offset_X + ($hole_spacing_X * 11) + ($hole_diameter / 2);
$grid_height_Y = $offset_Y + ($hole_spacing_Y * 7) + ($hole_diameter / 2);

// Calculate block center offsets to align grid with block center
$center_X = ($block_length_X - $grid_width_X) / 2;
$center_Y = ($block_width_Y - $grid_height_Y) / 2;

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
    holes = difference() {
        // Start with a copy of the block to ensure we are cutting into the solid
        union() {
            translate([0, 0, 0]) block;
        }
        
        for (row = [0:7], col = [0:11]) {
            // Calculate position of the hole center relative to the block corner (A1)
            // X position: offset_X + col * spacing
            // Y position: offset_Y + row * spacing
            pos_x = $offset_X + (col * $hole_spacing_X);
            pos_y = $offset_Y + (row * $hole_spacing_Y);
            
            // Translate to the actual position on the block
            translate([pos_x, pos_y, 0]) 
                cylinder(
                    h = $block_height_Z + 1, // Extend slightly past top/bottom for clean cut
                    r = $hole_diameter / 2,
                    $fn = 64
                );
        }
    };

    // 3. Apply the 45-degree chamfer at the A1 corner
    // A1 is the bottom-left-front corner in standard plate orientation.
    // In our model (centred on origin, Z up):
    // X increases to the right. Y increases "forward" (away from back edge).
    // The "back edge" is the negative Y side relative to the grid offset logic if we viewed from top,
    // but physically, the block is 85.48 wide. The grid starts 11.24mm from the "back".
    // Let's assume the "back" is the -Y direction relative to the grid start, 
    // but since we centered the block, we need to find the absolute coordinates of the A1 corner.
    
    // A1 Corner Absolute Coordinates:
    // X_start = $center_X - $offset_X + ($hole_diameter/2)
    // Y_start = $center_Y - $offset_Y + ($hole_diameter/2)
    // Z_start = 0
    
    $corner_x_abs = $center_X - $offset_X + ($hole_diameter / 2);
    $corner_y_abs = $center_Y - $offset_Y + ($hole_diameter / 2);
    
    // Define the chamfer plane. 
    // We want to cut a 45 deg chamfer on the vertical edge at ($corner_x_abs, $corner_y_abs).
    // The cut should remove material where X < $corner_x_abs + $chamfer_leg AND Y < $corner_y_abs + $chamfer_leg.
    
    chamfer_cut = translate([
        $corner_x_abs - $chamfer_leg, 
        $corner_y_abs - $chamfer_leg, 
        0
    ]) 
    // Create a wedge shape that acts as the cutter
    // The wedge extends infinitely in Z to cut through the whole block
    // The wedge is defined by a polygon in XY and extruded up
    linear_extrude(height = $block_height_Z + 10, center = true)
    polygon([
        [0, 0], // Bottom left (relative to cut origin)
        [$chamfer_leg, 0], // Bottom right
        [$chamfer_leg, $chamfer_leg], // Top right (corner of the cut)
        [0, $chamfer_leg] // Top left
    ], $center = true);
    
    // Note: The polygon above creates a square corner cut. 
    // To get a 45 degree chamfer specifically, we need to ensure the geometry matches.
    // A square cut with legs equal creates a 45 degree angle naturally.
    
    // However, we must ensure the cut shape is positioned correctly relative to the block.
    // The polygon above is centered at the corner of the cut.
    // Let's refine the chamfer cutter to be a simple wedge for clarity and robustness.
    
    // Re-defining chamfer cutter as a wedge for precision
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

    // Apply the chamfer cut
    difference() {
        union() {
            holes;
            // Add the chamfer wedge to the union so it doesn't get cut out if we were doing intersection
            // Actually, we want to DIFFERENCE the block against the holes AND the chamfer.
            // So we construct the final object as: Block - (Holes U Chamfer)
        }
        
        // Combine holes and chamfer into one cutting volume
        union() {
            // The holes are already calculated in 'holes' variable as a difference result? 
            // No, 'holes' variable above was a difference operation. 
            // Let's restart the logic flow to be cleaner.
            
            // Correct Logic:
            // 1. Start with Block.
            // 2. Subtract Holes.
            // 3. Subtract Chamfer.
            
            // Re-calculating holes as a simple cylinder array for the subtraction step
            hole_array = [];
            for (row = [0:7], col = [0:11]) {
                pos_x = $offset_X + (col * $hole_spacing_X);
                pos_y = $offset_Y + (row * $hole_spacing_Y);
                hole_array.push([pos_x, pos_y, 0, $hole_diameter / 2, $block_height_Z + 1]);
            }
            
            // Create a module to subtract holes
            subtract_holes = function(holes_list) {
                for (h = holes_list) {
                    translate(h[0:3]) cylinder(h[3], h[4]);
                }
            };
            
            // Since OpenSCAD doesn't support functions in this context easily without modules,
            // let's just do the subtraction directly in the main difference block.
        }
    }
    
    // --- Revised and Simplified Construction ---
    
    // 1. Base Block
    base = cube([
        $block_length_X,
        $block_width_Y,
        $block_height_Z
    ]);
    
    // 2. Holes
    // We create a list of hole positions and subtract them
    hole_positions = [];
    for (row = [0:7], col = [0:11]) {
        px = $offset_X + (col * $hole_spacing_X);
        py = $offset_Y + (row * $hole_spacing_Y);
        hole_positions.push([px, py, 0]);
    }
    
    // 3. Chamfer
    // Position of the A1 corner (bottom-left of the grid)
    // X coordinate: Center_X - (Offset_X - HoleRadius)
    // Y coordinate: Center_Y - (Offset_Y - HoleRadius)
    $corner_x = $center_X - ($offset_X -