// PCR Tube Rack for 96-well plates (0.2 mL)
// ANSI/SLAS footprint compliant
// Orientation: Rests on XY plane at Z=0, builds upward (+Z)
// Centred on origin in X and Y

// --- Dimensions (mm) ---
// Overall block dimensions
$block_length = 127.76;
$block_width  = 85.48;
$block_height = 20;

// Hole specifications
$hole_diameter = 6.2;
$hole_spacing_x = 9.0;
$hole_spacing_y = 9.0;

// Grid positioning (distance from nearest edge to first hole centre)
$offset_x = 14.38;
$offset_y = 11.24;

// Chamfer specifications (orientation mark at A1 corner)
$chamfer_leg = 5;
$chamfer_angle = 45;

// --- Configuration ---
$fn = 100; // High resolution for smooth holes and chamfers

// --- Main Block ---
// Create the main rectangular prism
block = cube([
    $block_length,
    $block_width,
    $block_height
], center = false);

// --- Hole Generation ---
// We will create a list of hole positions and subtract them from the block.
// Rows are along Y (8 rows), Columns are along X (12 columns).
// A1 is typically Row 1, Col 1.
// Based on description: A1 is offset by $offset_x from left, $offset_y from back.
// "Back" usually corresponds to -Y direction in standard plate orientation if X is left-right and Y is front-back.
// However, the prompt says "11.24 mm from the back edge". 
// If the block is centered at 0,0, the back edge is at -($block_width/2).
// Let's define the loop to generate holes.

holes = [];
for (col = [0 : 11]) {
    for (row = [0 : 7]) {
        // Calculate X position
        // First hole (col=0) is at $offset_x from left edge.
        // Left edge is at -$block_length/2.
        // So X = -$block_length/2 + $offset_x + (col * $hole_spacing_x)
        x_pos = -($block_length / 2) + $offset_x + (col * $hole_spacing_x);
        
        // Calculate Y position
        // First hole (row=0) is at $offset_y from back edge.
        // Back edge is at -$block_width/2.
        // So Y = -$block_width/2 + $offset_y + (row * $hole_spacing_y)
        y_pos = -($block_width / 2) + $offset_y + (row * $hole_spacing_y);
        
        holes.push([x_pos, y_pos]);
    }
}

// --- Chamfer Generation ---
// Chamfer at A1 corner (Row 0, Col 0).
// A1 corner is the "back-left" corner of the block.
// Coordinates of the corner: (-$block_length/2, -$block_width/2, 0) to (-$block_length/2, -$block_width/2, $block_height).
// We need to cut a 45-degree chamfer with 5mm legs.
// This means we cut a plane that intersects the vertical edge at Z=5mm and the top face at X/Y = 5mm inward.
// Since it's a vertical edge, the chamfer plane passes through:
// 1. Point on vertical edge: (-$block_length/2, -$block_width/2, $chamfer_leg)
// 2. Point on top face X: (-$block_length/2 + $chamfer_leg, -$block_width/2, $block_height)
// 3. Point on top face Y: (-$block_length/2, -$block_width/2 + $chamfer_leg, $block_height)
// Actually, a standard 45 deg chamfer on a corner cuts off the corner.
// The cutting plane equation for a 45 deg chamfer at the corner (-L/2, -W/2) is:
// (X - (-L/2)) + (Y - (-W/2)) + (Z - 0) = constant? No.
// A 45 degree chamfer on a vertical edge usually means the plane is perpendicular to the diagonal of the top face corner?
// Or is it a bevel on the vertical face?
// "Cut a 45-degree chamfer with 5 mm legs off the vertical edge".
// This implies a plane cutting the vertical edge at Z=5mm, and cutting the top face such that the distance from the corner along the top face edges is 5mm.
// The plane passes through:
// P1: (-$block_length/2, -$block_width/2, $chamfer_leg)  (On the vertical edge)
// P2: (-$block_length/2 + $chamfer_leg, -$block_width/2, $block_height) (On the top face, along X)
// P3: (-$block_length/2, -$block_width/2 + $chamfer_leg, $block_height) (On the top face, along Y)
// Wait, if the leg is 5mm, the plane cuts the vertical edge at Z=5.
// The intersection with the top face (Z=20) would be a line connecting (X+5, Y) and (X, Y+5) relative to the corner?
// Yes. The plane normal is (1, 1, -1) normalized?
// Let's define the plane using 3 points.
// Point A (on vertical edge): [-L/2, -W/2, 5]
// Point B (on top face, X direction): [-L/2 + 5, -W/2, 20]
// Point C (on top face, Y direction): [-L/2, -W/2 + 5, 20]
// We will create a large polygon representing this plane and subtract it.

chamfer_points = [
    [-($block_length/2), -($block_width/2), $chamfer_leg],
    [-($block_length/2) + $chamfer_leg, -($block_width/2), $block_height],
    [-($block_length/2), -($block_width/2) + $chamfer_leg, $block_height]
];

// --- Assembly ---
difference() {
    union() {
        // 1. Main Block
        translate([0, 0, 0])
            cube([
                $block_length,
                $block_width,
                $block_height
            ]);
        
        // 2. Chamfer Cut
        // Create a large plane that covers the corner area to ensure full cut
        // We need a polygon that extends beyond the block boundaries to ensure the cut goes all the way through.
        // The plane is defined by the 3 points above.
        // We need to extend this plane significantly in the direction of the normal to cover the whole block corner.
        // Distance to extend: 100mm should be enough.
        $extend = 100;
        
        // Define the plane polygon vertices.
        // We need to create a large rectangle on the plane defined by the 3 points.
        // Let's find the normal vector first.
        v1 = chamfer_points[1] - chamfer_points[0];
        v2 = chamfer_points[2] - chamfer_points[0];
        normal = cross(v1, v2);
        normal = normalize(normal);
        
        // Create a large polygon for the cut.
        // We will define 4 points that form a large rectangle on this plane.
        // Center of the chamfer cut on the plane:
        chamfer_center = chamfer_points[0];
        
        // We need to find two orthogonal vectors on the plane to define the rectangle.
        // Vector 1: Along the X-axis of the block (projected onto plane)
        // Vector 2: Along the Y-axis of the block (projected onto plane)
        // Actually, simpler approach: Define the plane by 3 points, then create a large polygon using those 3 points plus a 4th point far away.
        // But OpenSCAD polygons must be planar.
        // Let's use the 3 points and extend them.
        
        // Point 1: On vertical edge
        p1 = chamfer_points[0];
        // Point 2: On top face X
        p2 = chamfer_points[1];
        // Point 3: On top face Y
        p3 = chamfer_points[2];
        
        // We need a 4th point to close the rectangle on the plane.
        // Vector p2-p1 is along X. Vector p3-p1 is along Y.
        // The 4th point p4 should be p2 + (p3-p1).
        p4 = p2 +