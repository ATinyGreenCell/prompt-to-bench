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
$hole_spacing_x = 9.0; // Column spacing (along X)
$hole_spacing_y = 9.0; // Row spacing (along Y)
$hole_count_x = 12;    // Columns
$hole_count_y = 8;     // Rows

// Grid Positioning (Distance from edge to first hole centre)
$offset_x = 14.38;
$offset_y = 11.24;

// Chamfer Specifications (Orientation Mark)
$chamfer_leg = 5;
$chamfer_angle = 45;

// --- Configuration ---
$fn = 128; // High resolution for smooth holes and chamfers

// --- Calculations ---
// Calculate total grid size based on spacing and count
$total_grid_x = ($hole_spacing_x * ($hole_count_x - 1)) + (2 * $offset_x);
$total_grid_y = ($hole_spacing_y * ($hole_count_y - 1)) + (2 * $offset_y);

// Calculate block centre
$block_cx = $block_length / 2;
$block_cy = $block_width / 2;

// Calculate grid centre relative to block
$grid_cx = $block_cx - ($total_grid_x / 2);
$grid_cy = $block_cy - ($total_grid_y / 2);

// --- Main Module ---
module pcr_rack() {
    // Define the main block
    block = cube([
        $block_length,
        $block_width,
        $block_height
    ]);

    // Define the chamfer cut
    // We need to cut a wedge from the top-front-left corner (A1)
    // A1 is at: X = -offset_x, Y = -offset_y, Z = 0 (relative to block face)
    // In global coords relative to block centre:
    // X_pos = $grid_cx - $offset_x
    // Y_pos = $grid_cy - $offset_y
    
    chamfer_start_x = $grid_cx - $offset_x;
    chamfer_start_y = $grid_cy - $offset_y;
    
    // The chamfer leg is 5mm along the vertical edge (Y direction in this corner context)
    // and 5mm along the horizontal face (X direction).
    // We create a plane that cuts through these points.
    // Point 1: Top edge of the cut (Z = 20, Y = start_y + 5)
    // Point 2: Front edge of the cut (X = start_x + 5, Z = 20)
    // Point 3: The corner vertex (X = start_x, Y = start_y, Z = 20)
    
    // To make the difference work cleanly, we extrude a polygon or use a plane.
    // Let's use a polygon extruded along Z, then rotated, or simply define the cutting plane geometry.
    // Easier approach: Define the volume to remove.
    // The cut is a wedge.
    
    chamfer_cut = linear_extrude(height = $block_height, center = true) {
        polygon(points = [
            [chamfer_start_x, chamfer_start_y], // Bottom corner (virtual, just for shape)
            [chamfer_start_x + $chamfer_leg, chamfer_start_y], // Bottom front edge
            [chamfer_start_x + $chamfer_leg, chamfer_start_y + $chamfer_leg], // Top front edge
            [chamfer_start_x, chamfer_start_y + $chamfer_leg]  // Top corner
        ], 
        convexity = 3
        );
    };
    
    // Rotate the chamfer cut to align with the corner
    // The corner is at (chamfer_start_x, chamfer_start_y).
    // The cut extends +X and +Y from this corner.
    // We need to translate the polygon so the corner is at the correct location.
    // The polygon above is centred. We need to shift it.
    // Actually, let's redefine the polygon relative to the corner to avoid translation math errors.
    
    // Redefining chamfer_cut relative to the corner (0,0)
    chamfer_cut_local = linear_extrude(height = $block_height, center = false) {
        polygon(points = [
            [0, 0],
            [$chamfer_leg, 0],
            [$chamfer_leg, $chamfer_leg],
            [0, $chamfer_leg]
        ], 
        convexity = 3
        );
    };
    
    // Translate to the correct corner position
    chamfer_cut_global = translate([chamfer_start_x, chamfer_start_y, 0]) {
        chamfer_cut_local;
    };

    // --- Build ---
    difference() {
        // 1. Main Block
        translate([0, 0, 0]) {
            block;
        }
        
        // 2. Chamfer Cut
        chamfer_cut_global;
        
        // 3. Holes
        // Loop through columns (X) and rows (Y)
        for (col = [0 : $hole_count_x - 1]) {
            for (row = [0 : $hole_count_y - 1]) {
                // Calculate hole position
                hole_x = $grid_cx + ($hole_spacing_x * col);
                hole_y = $grid_cy + ($hole_spacing_y * row);
                
                // Cut the hole
                translate([hole_x, hole_y, 0]) {
                    cylinder(
                        h = $block_height,
                        r = $hole_diameter / 2,
                        $fn = $fn
                    );
                }
            }
        }
    }
}

// Render the part
pcr_rack();