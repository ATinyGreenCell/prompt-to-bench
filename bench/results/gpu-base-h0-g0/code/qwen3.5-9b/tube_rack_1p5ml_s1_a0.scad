// Bench Rack for 1.5 mL Microcentrifuge Tubes
// Designed for FDM 3D printing.
// Orientation: Rests on XY plane at Z=0, builds upward (+Z).
// Centred on origin in X and Y.

// --- Dimensions (mm) ---
// Block dimensions
$block_length = 106;
$block_width  = 72;
$block_height = 30;

// Hole grid configuration
$num_rows = 4;   // Rows along Y
$num_cols = 6;   // Columns along X
$hole_cc_x = 16; // Centre-to-centre spacing X
$hole_cc_y = 16; // Centre-to-centre spacing Y

// Hole dimensions
$hole_diameter = 11.2;
$hole_depth    = 25; // Depth of the hole (open top, closed bottom)
$floor_height  = 5;  // Solid floor thickness at bottom

// --- Derived Variables ---
// Calculate grid start positions to center the grid on the block
// Total span X = (num_cols - 1) * spacing
// Start X = (Block Length - Total Span X) / 2
$total_span_x = ($num_cols - 1) * $hole_cc_x;
$start_x = ($block_length - $total_span_x) / 2;

$total_span_y = ($num_rows - 1) * $hole_cc_y;
$start_y = ($block_width - $total_span_y) / 2;

// --- Settings ---
$fn = 64; // Smooth curves for holes

// --- Main Block ---
difference() {
    // 1. Create the solid rectangular block
    // Dimensions: Length (X), Width (Y), Height (Z)
    block = cube([
        $block_length,
        $block_width,
        $block_height
    ]);

    // 2. Create holes
    // Holes are cylinders. 
    // Top is open (at Z = block_height).
    // Bottom is closed (stops at Z = floor_height).
    // We subtract cylinders that extend slightly past the top face to ensure clean cuts.
    
    for (r = [0 : $num_rows - 1]) {
        for (c = [0 : $num_cols - 1]) {
            // Calculate center of current hole
            cx = start_x + c * $hole_cc_x;
            cy = start_y + r * $hole_cc_y;
            
            // Hole geometry
            // Radius
            r_hole = $hole_diameter / 2;
            
            // Position: Centered at (cx, cy)
            // Extends from Z = floor_height to Z = block_height + clearance
            // Clearance ensures the cut goes slightly past the top face
            clearance = 0.5; 
            
            hole = cylinder(
                h = $hole_depth + clearance,
                r1 = r_hole,
                r2 = r_hole,
                center = [cx, cy, $block_height + clearance/2]
            );
            
            difference() {
                block;
                translate([cx, cy, $floor_height]) {
                    // The cylinder is defined relative to its own center.
                    // We translate it so its bottom is at $floor_height.
                    // Since the cylinder height is $hole_depth + clearance,
                    // the top will be at $floor_height + $hole_depth + clearance
                    // = $block_height + clearance.
                    cylinder(
                        h = $hole_depth + clearance,
                        r1 = r_hole,
                        r2 = r_hole,
                        $fn = $fn
                    );
                }
            }
        }
    }
}