// 96-Well PCR Tube Rack (ANSI/SLAS Footprint)
// Designed for FDM 3D printing.
// Orientation: Rests on XY plane at Z=0, builds upward.
// Centred on origin in X and Y.

// --- Dimensions (mm) ---
// Block Dimensions
$block_length = 127.76;
$block_width  = 85.48;
$block_height = 20;

// Hole Specifications
$hole_diameter = 6.2;
$hole_spacing_x = 9.0;
$hole_spacing_y = 9.0;
$hole_count_x = 12;
$hole_count_y = 8;

// Grid Positioning (Distance from edge to first hole centre)
$offset_x = 14.38;
$offset_y = 11.24;

// Chamfer Specifications (Orientation Mark at A1 corner)
$chamfer_angle = 45;
$chamfer_leg = 5;

// --- Configuration ---
$fn = 100; // High resolution for smooth holes and chamfers

// --- Calculations ---
// Calculate total grid size based on spacing and count
$total_grid_x = ($hole_spacing_x * ($hole_count_x - 1));
$total_grid_y = ($hole_spacing_y * ($hole_count_y - 1));

// Calculate block dimensions required to centre the grid
// Block Length = Offset + Grid + Offset
$calc_length = $offset_x + $total_grid_x + $offset_x;
$calc_width  = $offset_y + $total_grid_y + $offset_y;

// Verify against user provided block dimensions (they should match closely)
// User provided: 127.76 x 85.48
// Calculated:    127.76 x 85.48
// We use the user's explicit block dimensions for the main block.

// --- Main Block ---
difference() {
    // 1. Create the main block
    block = cube([
        $block_length,
        $block_width,
        $block_height
    ], center = false);
    
    // 2. Cut the 96 holes
    // We iterate through X (columns) and Y (rows)
    for (col = [0 : $hole_count_x - 1]) {
        for (row = [0 : $hole_count_y - 1]) {
            // Calculate position of current hole centre
            // X position: offset + col * spacing
            pos_x = $offset_x + (col * $hole_spacing_x);
            // Y position: offset + row * spacing
            pos_y = $offset_y + (row * $hole_spacing_y);
            
            // Create hole cylinder
            hole = cylinder(
                h = $block_height + 1, // Extend slightly past top/bottom for clean cut
                r = $hole_diameter / 2,
                center = [pos_x, pos_y, $block_height / 2]
            );
            
            difference() {
                block;
                hole;
            }
        }
    }
    
    // 3. Cut the Chamfer at the A1 corner
    // A1 is the first hole (col=0, row=0).
    // Coordinates of A1 centre:
    $a1_x = $offset_x;
    $a1_y = $offset_y;
    
    // The corner of the block is at ($offset_x, $offset_y) relative to the block's local origin?
    // No, the block is centred on the origin.
    // We need to find the absolute coordinates of the A1 corner relative to the block's bounding box.
    // The block extends from -L/2 to +L/2 and -W/2 to +W/2.
    // The A1 hole is at ($offset_x, $offset_y) relative to the block's front-left corner (min X, min Y).
    
    // Let's define the corner of the block corresponding to A1.
    // Block min X = -$block_length / 2
    // Block min Y = -$block_width / 2
    // A1 Corner X = Block min X + $offset_x
    // A1 Corner Y = Block min Y + $offset_y
    
    $corner_x = -($block_length / 2) + $offset_x;
    $corner_y = -($block_width / 2) + $offset_y;
    
    // Define the chamfer plane.
    // We want to cut a 45 degree chamfer with leg length $chamfer_leg.
    // This creates a new face connecting:
    // Point 1: ($corner_x - $chamfer_leg, $corner_y)
    // Point 2: ($corner_x, $corner_y - $chamfer_leg)
    // Point 3: ($corner_x, $corner_y) (The original corner)
    // Point 4: ($corner_x + $chamfer_leg, $corner_y) -- Wait, standard chamfer cuts off the corner.
    
    // Let's define the polygon for the cut.
    // We are cutting the corner at ($corner_x, $corner_y).
    // The cut line goes from ($corner_x - $chamfer_leg, $corner_y) to ($corner_x, $corner_y - $chamfer_leg).
    // We need to extend this cut slightly past the block faces to ensure a clean cut.
    
    $cut_extend = 0.5;
    
    // Points for the cutting polygon (in XY plane, extruded through Z)
    // Top edge of cut (along Y): from ($corner_x - $chamfer_leg - $cut_extend, $corner_y) to ($corner_x, $corner_y)
    // Bottom edge of cut (along X): from ($corner_x, $corner_y - $chamfer_leg - $cut_extend) to ($corner_x, $corner_y)
    // Diagonal edge: from ($corner_x - $chamfer_leg - $cut_extend, $corner_y) to ($corner_x, $corner_y - $chamfer_leg - $cut_extend)
    
    // Actually, simpler approach: Create a polygon that represents the chamfer face, then use it to cut?
    // No, we need to remove material.
    // We can create a large polygon that covers the corner and subtract it.
    
    // Vertices of the polygon to subtract:
    // 1. ($corner_x - $chamfer_leg - $cut_extend, $corner_y)
    // 2. ($corner_x - $chamfer_leg - $cut_extend, $corner_y - $block_height) // Extend down
    // 3. ($corner_x, $corner_y - $block_height)
    // 4. ($corner_x, $corner_y - $chamfer_leg - $cut_extend)
    // 5. ($corner_x, $corner_y)
    // 6. ($corner_x - $chamfer_leg - $cut_extend, $corner_y)
    
    // Wait, the chamfer is on the vertical edge.
    // The cut removes the corner triangle.
    // The polygon vertices in XY plane:
    // A: ($corner_x - $chamfer_leg - $cut_extend, $corner_y)
    // B: ($corner_x, $corner_y - $chamfer_leg - $cut_extend)
    // C: ($corner_x, $corner_y)
    // D: ($corner_x - $chamfer_leg - $cut_extend, $corner_y) -- Closing loop? No.
    
    // Let's define the polygon that cuts the corner.
    // It should cover the area from the cut line outwards to the block edge.
    // Since we are subtracting, the polygon should be the "wedge" being removed.
    // The wedge is bounded by:
    // Line 1: X = $corner_x - $chamfer_leg (from Y=$corner_y down to Y=$corner_y - $block_height)
    // Line 2: Y = $corner_y - $chamfer_leg (from X=$corner_x - $chamfer_leg to X=$corner_x)
    // Line 3: Diagonal connecting ($corner_x - $chamfer_leg, $corner_y) and ($corner_x, $corner_y - $chamfer_leg)
    
    // To make it a solid cut, we extrude this polygon through the Z height.
    // Vertices of the polygon (XY):
    // P1: [$corner_x - $chamfer_leg - $cut_extend, $corner_y]
    // P2: [$corner_x - $chamfer_leg - $cut_extend, $corner_y - $block_height]
    // P3: [$corner_x, $corner_y - $block_height]
    // P4: [$corner_x, $corner_y - $chamfer_leg - $cut_extend]
    // P5: [$corner_x, $corner_y]
    // P6: [$corner_x - $chamfer_leg - $cut_extend, $corner_y]
    
    // Wait