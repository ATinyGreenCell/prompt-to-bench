// 96-Well PCR Tube Rack (0.2 mL)
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

// Grid positioning (from left edge and back edge)
$offset_x = 14.38;
$offset_y = 11.24;

// Grid layout
$cols = 12;
$rows = 8;

// Chamfer specification
$chamfer_angle = 45;
$chamfer_leg = 5;

// Quality settings
$fn = 64;

// --- Helper Functions ---

// Generate the main block with holes
module create_rack() {
    // Calculate total grid size to verify centering
    $grid_width_total  = ($cols - 1) * $hole_spacing_x;
    $grid_height_total = ($rows - 1) * $hole_spacing_y;
    
    // Verify centering logic based on user offsets
    // Left edge to first hole center = offset_x
    // Right edge to last hole center = block_length - offset_x - grid_width_total
    // Check: offset_x + grid_width_total should equal block_length - (block_length - offset_x - grid_width_total)
    // Actually, let's just calculate the position of the last hole to ensure symmetry if needed,
    // but the prompt gives specific offsets from edges, so we trust those.
    
    // Define the main block
    block = cube([
        $block_length,
        $block_width,
        $block_height
    ]);
    
    // Define the hole cutter
    hole_cutter = cylinder(
        h = $block_height + 1, // Extend slightly past top/bottom for clean cut
        r = $hole_diameter / 2
    );
    
    // Create the grid of holes
    // We iterate through columns (X) and rows (Y)
    // X axis: 0 to cols-1
    // Y axis: 0 to rows-1
    
    // Calculate the starting position for the loop relative to the block center
    // The prompt says "centre of the first hole (A1) is 14.38 mm from the left edge"
    // In our coordinate system, the block is centered at 0,0.
    // Left edge is at -($block_length / 2).
    // So hole_x_start = -($block_length / 2) + $offset_x
    
    hole_x_start = -($block_length / 2) + $offset_x;
    hole_y_start = -($block_width / 2) + $offset_y;
    
    difference() {
        union() {
            // Main block
            translate([0, 0, 0]) block;
            
            // Chamfer at A1 corner (Top-Left-Front in standard plate notation, 
            // but here we define it based on the block geometry: 
            // Left edge (-X), Back edge (-Y), Top edge (+Z))
            // The prompt asks for a chamfer on the "vertical edge at the A1 corner".
            // A1 is typically Top-Left-Front. In our centered block:
            // Left = -X, Back = -Y.
            // We will chamfer the edge where X is negative and Y is negative.
            
            // To cut a chamfer, we can use a rotated cylinder or a polygon extrusion.
            // A simple way is to rotate a cylinder 45 degrees and translate it to the corner.
            // However, a chamfer is a flat cut. 
            // We can create a "chamfer cutter" shape.
            
            // Let's create a chamfer cutter that removes the corner.
            // The leg is 5mm. The angle is 45 degrees.
            // We need to cut a wedge from the corner.
            
            // Define the corner point (Left, Back, Top)
            // Left = -($block_length/2)
            // Back = -($block_width/2)
            // Top = $block_height
            
            corner_x = -($block_length / 2);
            corner_y = -($block_width / 2);
            corner_z = $block_height;
            
            // The chamfer plane passes through:
            // 1. (corner_x + leg, corner_y, corner_z) -> along X
            // 2. (corner_x, corner_y + leg, corner_z) -> along Y
            // 3. (corner_x, corner_y, corner_z - leg) -> along Z
            
            // We can model this by rotating a cylinder 45 degrees around the Z axis? No.
            // We can model this by rotating a cylinder 45 degrees around the line X=Y?
            // Easiest way in OpenSCAD for a 45 deg chamfer on a corner:
            // Create a cylinder of radius = leg / sin(45) = leg * sqrt(2) ? No.
            // Let's use a polygon extrusion for precision.
            
            // Points of the chamfer cut (in local space relative to the corner):
            // We want to remove material defined by the plane x + y + z = constant? No.
            // The cut is on the vertical edge.
            // The cut surface is a rectangle rotated 45 degrees? No, it's a triangle if we look from top.
            // Actually, a 45 deg chamfer on a vertical edge creates a flat surface connecting the top face and the side face.
            
            // Let's define the chamfer cutter as a shape that, when subtracted, leaves the chamfer.
            // The cutter should be a "wedge" or a rotated cylinder.
            // A cylinder rotated 45 degrees around the Z-axis centered at the corner?
            // If we rotate a cylinder of radius R around Z, it cuts a circle.
            // We want a plane.
            
            // Alternative: Use a cylinder rotated 45 degrees around the axis (1,1,0)?
            // Let's try a simpler approach: 
            // Create a cylinder with radius = leg * sqrt(2) (approx 7.07) centered at the corner?
            // No, that cuts a circle.
            
            // Correct approach for a 45 deg chamfer on a corner:
            // The cut is defined by the plane passing through (corner_x+leg, corner_y, corner_z) and (corner_x, corner_y+leg, corner_z).
            // And it goes down to (corner_x, corner_y, corner_z - leg).
            // This is a triangular prism cut? No, it's a planar cut.
            
            // We can create a "chamfer cutter" by rotating a cylinder 45 degrees around the Z axis? No.
            // Let's use a cylinder rotated 45 degrees around the line X=Y (in the XY plane)?
            // If we take a cylinder of radius R, and rotate it 45 degrees around the Z axis, we get a cylinder.
            // If we rotate it around the line X=Y?
            
            // Let's use a polygon extrude.
            // Profile of the cut (looking from top, at the corner):
            // We want to remove the corner.
            // The cut line in the XY plane (at Z=block_height) goes from (corner_x+leg, corner_y) to (corner_x, corner_y+leg).
            // The cut line in the XY plane (at Z=0) goes from (corner_x+leg, corner_y) to (corner_x, corner_y+leg).
            // Wait, a chamfer on a vertical edge usually connects the top face to the side face.
            // So at Z=block_height, the cut is a line segment.
            // At Z=0, the cut is the same line segment? No, that would be a groove.
            // A chamfer on a vertical edge means the edge itself is beveled.
            // So at Z=block_height, the corner is cut.
            // At Z=0, the corner is cut.
            // The cut surface is a plane.
            
            // Let's define the plane equation: x + y = C (in local coords where corner is origin).
            // The plane passes through (leg, 0) and (0, leg). So x + y = leg.
            // The cut extends from Z=0 to Z=block_height.
            // So we need to subtract a shape defined by:
            // x >= corner_x + leg - (something)?
            // Let's define the cutter in a local coordinate system.
            // Local origin at (corner_x, corner_y, 0).
            // We want to remove points where (x_local + y_local) > leg? No, that