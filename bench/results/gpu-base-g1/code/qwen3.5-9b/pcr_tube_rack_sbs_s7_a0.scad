// 96-Well PCR Tube Rack
// Designed for FDM 3D printing.
// Orientation: Rests on XY plane at Z=0, builds upward.
// Centred on origin in X and Y.

// --- Dimensions (mm) ---
// Block dimensions
$block_length = 127.76;
$block_width  = 85.48;
$block_height = 20;

// Hole specifications
$hole_diameter = 6.2;
$hole_spacing_x = 9.0;
$hole_spacing_y = 9.0;
$hole_count_x = 12;
$hole_count_y = 8;

// Grid positioning (from left edge and back edge)
$offset_x = 14.38;
$offset_y = 11.24;

// Chamfer specifications
$chamfer_angle = 45;
$chamfer_leg = 5;

// --- Derived Variables ---
// Calculate total grid size based on spacing and count
$total_grid_x = ($hole_spacing_x * ($hole_count_x - 1)) + $offset_x + ($block_length - $offset_x - ($hole_spacing_x * ($hole_count_x - 1)));
// Actually, simpler to calculate the span of the holes themselves
$hole_span_x = ($hole_spacing_x * ($hole_count_x - 1));
$hole_span_y = ($hole_spacing_y * ($hole_count_y - 1));

// Verify centering logic:
// Center of block in X = $block_length / 2
// Center of grid in X = $offset_x + ($hole_span_x / 2)
// The prompt says "grid is centred on the block", so we assume the provided offsets 
// relative to the edges result in a centered grid. We will use the provided offsets 
// directly to position the holes relative to the block edges.

// --- Main Block ---
difference() {
    // Create the main block
    cube([
        $block_length, 
        $block_width, 
        $block_height
    ]);

    // --- Cut Holes ---
    // We use a loop to create 96 holes.
    // X axis: 0 to 11 (12 columns)
    // Y axis: 0 to 7 (8 rows)
    // Note: In standard plate notation, Row 1 is usually the back (Y max) or front.
    // The prompt defines A1 (first hole) at offset_y from the "back edge".
    // We assume Y=0 is the back edge and Y=$block_width is the front edge for this calculation,
    // or we can just iterate and translate by the offset + index*spacing.
    
    for (col = [0 : $hole_count_x - 1]) {
        for (row = [0 : $hole_count_y - 1]) {
            // Calculate position
            // X position: offset from left edge + col * spacing
            pos_x = $offset_x + (col * $hole_spacing_x);
            
            // Y position: offset from back edge + row * spacing
            // Assuming "back edge" corresponds to Y=0 for the offset calculation
            pos_y = $offset_y + (row * $hole_spacing_y);
            
            // Hole cylinder
            // Extend slightly past the face to ensure clean cut (Rule 5)
            cut_height = $block_height + 0.5; 
            
            translate([pos_x, pos_y, -$cut_height/2]) {
                cylinder(
                    h = cut_height,
                    d = $hole_diameter,
                    $fn = 64
                );
            }
        }
    }

    // --- Cut Chamfer ---
    // Cut a 45-degree chamfer with 5mm legs off the vertical edge at the A1 corner.
    // A1 is at (pos_x, pos_y) calculated above for col=0, row=0.
    // A1_X = $offset_x
    // A1_Y = $offset_y
    // The corner is the intersection of the Left face (X=0) and Back face (Y=0).
    // We need to cut a wedge from this corner.
    
    // Define the corner point
    corner_x = 0;
    corner_y = 0;
    
    // The chamfer leg is 5mm. Since angle is 45, the cut depth in Z is also 5mm.
    // We create a pyramid-like cut or a wedge.
    // To cut a 45 deg chamfer on a vertical edge, we can use a rotated cube or a polygon extrusion.
    // Let's use a rotated cube (wedge) that intersects the corner.
    
    // The wedge needs to remove material where X < leg and Y < leg (relative to the corner plane).
    // Actually, a 45 deg chamfer on a 90 deg corner means the cut surface is at 45 deg to both faces.
    // We can model this as a large cube rotated 45 degrees around the Z axis, positioned at the corner.
    
    // Center of the chamfer cut on the top face would be at (leg, leg).
    // The cut extends down to Z = leg (since tan(45)=1).
    
    chamfer_center_x = corner_x + $chamfer_leg;
    chamfer_center_y = corner_y + $chamfer_leg;
    chamfer_depth = $chamfer_leg; // At 45 deg, depth = leg length
    
    // Create the cutting wedge
    // A cube of size (leg*sqrt(2)) rotated 45 deg? 
    // Simpler approach: Use a polygon extrusion or a rotated cube.
    // Let's use a rotated cube that acts as the cutter.
    // The cutter should be a square pyramid or a wedge.
    // A simple way to cut a 45 deg chamfer on a corner is to subtract a cube rotated 45 degrees.
    // The size of the rotated cube must cover the leg length.
    // If we rotate a square of side S by 45 deg, the bounding box is S*sqrt(2).
    // We want the cut to go 5mm along X and 5mm along Y.
    // The distance from the corner to the cut plane is 5*sqrt(2) approx 7.07mm.
    // So a cube of side 7.07mm rotated 45 deg centered at (5,5) will do the job.
    
    $chamfer_size = $chamfer_leg * sqrt(2);
    
    translate([chamfer_center_x, chamfer_center_y, -$chamfer_depth/2]) {
        rotate([0, 0, 45]) {
            cube([
                $chamfer_size, 
                $chamfer_size, 
                $chamfer_depth
            ], center = true);
        }
    }
}