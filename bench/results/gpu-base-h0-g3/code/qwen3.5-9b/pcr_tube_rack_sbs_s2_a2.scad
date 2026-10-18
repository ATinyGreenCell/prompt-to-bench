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
$chamfer_leg = 5;

// --- Configuration ---
$fn = 100; // High resolution for smooth holes and chamfers

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
    // Coordinates of A1 centre relative to block's local origin (min X, min Y):
    $a1_x = $offset_x;
    $a1_y = $offset_y;
    
    // The block is centred on the origin.
    // Block min X = -$block_length / 2
    // Block min Y = -$block_width / 2
    // The corner of the block corresponding to A1 is at:
    $corner_x = -($block_length / 2) + $offset_x;
    $corner_y = -($block_width / 2) + $offset_y;
    
    // Define the polygon for the chamfer cut.
    // We want to remove the corner triangle defined by the chamfer leg.
    // The cut line connects ($corner_x - $chamfer_leg, $corner_y) and ($corner_x, $corner_y - $chamfer_leg).
    // We extend the cut slightly past the faces to ensure a clean removal.
    $cut_extend = 0.5;
    
    // Vertices of the polygon to subtract (in XY plane):
    // P1: Start of cut on left edge
    $p1_x = $corner_x - $chamfer_leg - $cut_extend;
    $p1_y = $corner_y;
    
    // P2: End of cut on bottom edge
    $p2_x = $corner_x;
    $p2_y = $corner_y - $chamfer_leg - $cut_extend;
    
    // P3: Corner point (original vertex)
    $p3_x = $corner_x;
    $p3_y = $corner_y;
    
    // The polygon representing the material to be removed is a trapezoid/triangle shape
    // that covers the corner and extends to the block faces.
    // Vertices:
    // 1. ($corner_x - $chamfer_leg - $cut_extend, $corner_y)
    // 2. ($corner_x - $chamfer_leg - $cut_extend, $corner_y - $block_height) // Down to bottom face
    // 3. ($corner_x, $corner_y - $block_height) // Corner of bottom face
    // 4. ($corner_x, $corner_y - $chamfer_leg - $cut_extend) // Up along bottom face
    // 5. ($corner_x, $corner_y) // Original corner
    // 6. ($corner_x - $chamfer_leg - $cut_extend, $corner_y) // Back to start
    
    // This polygon effectively removes the corner.
    
    chamfer_cut = polygon([
        [$p1_x, $p1_y],
        [$p1_x, $corner_y - $block_height],
        [$corner_x, $corner_y - $block_height],
        [$corner_x, $p2_y],
        [$corner_x, $p3_y], 
        [$p1_x, $p1_y]
    ]);
    
    // Extrude the polygon through the Z height of the block
    translate([0, 0, 0])
    linear_extrude(height = $block_height)
    chamfer_cut;
}