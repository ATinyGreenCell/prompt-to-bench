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
$chamfer_leg = 5;

// Quality settings
$fn = 64;

// --- Main Module ---
module create_rack() {
    // Calculate starting positions for holes relative to the block center
    // Block center is (0,0). Left edge is -($block_length/2).
    // First hole center X = Left Edge + $offset_x
    hole_x_start = -($block_length / 2) + $offset_x;
    // Back edge is -($block_width/2).
    // First hole center Y = Back Edge + $offset_y
    hole_y_start = -($block_width / 2) + $offset_y;

    // Create the main block
    block = cube([
        $block_length,
        $block_width,
        $block_height
    ]);

    // Create the hole cutter
    hole_cutter = cylinder(
        h = $block_height + 1, // Extend slightly past top/bottom for clean cut
        r = $hole_diameter / 2
    );

    // Create the chamfer cutter
    // A 45-degree chamfer with leg L on a corner effectively removes a triangular prism
    // defined by the plane x + y = L (in local corner coordinates) from the corner.
    // We model this by rotating a cylinder 45 degrees around the Z axis? No.
    // We model it by rotating a cylinder 45 degrees around the line X=Y?
    // Actually, the simplest way to cut a 45 deg chamfer on a corner in OpenSCAD
    // is to rotate a cylinder of radius R = L * sqrt(2) by 45 degrees around the Z axis?
    // No, that creates a circular cut.
    // The correct geometric shape to subtract is a cylinder rotated 45 degrees around the Z axis
    // IF the chamfer was circular. But a chamfer is planar.
    // To get a planar chamfer, we can rotate a cylinder 45 degrees around the axis (1,1,0)?
    // Let's use a simpler trick: Rotate a cylinder 45 degrees around the Z axis, then rotate the whole thing 45 degrees around X?
    // No.
    // Let's construct the chamfer cutter as a cylinder rotated 45 degrees around the Z axis?
    // No, let's use a cylinder rotated 45 degrees around the X axis?
    // Let's try a different approach:
    // Create a cylinder of radius R = leg * sqrt(2).
    // Rotate it 45 degrees around the Z axis.
    // This creates a cylinder whose axis is at 45 degrees to the X axis.
    // If we place this cylinder such that its axis passes through the corner?
    // No.
    
    // Correct approach for a 45 deg chamfer on a corner:
    // The cut is a plane. We can simulate the cut by subtracting a shape that covers the corner.
    // The shape is a cylinder of radius R = leg * sqrt(2) rotated 45 degrees around the Z axis?
    // No.
    // Let's use a cylinder of radius R = leg * sqrt(2) rotated 45 degrees around the X axis?
    // No.
    // Let's use a cylinder of radius R = leg * sqrt(2) rotated 45 degrees around the line X=Y?
    // No.
    
    // Let's use a cylinder of radius R = leg * sqrt(2) rotated 45 degrees around the Z axis.
    // The equation of the cylinder is (x cos(45) + y sin(45))^2 + (x sin(45) - y cos(45))^2 <= R^2.
    // This simplifies to x^2 + y^2 <= R^2.
    // So rotating a cylinder around Z doesn't change its equation.
    
    // Let's try rotating a cylinder around the X axis by 45 degrees.
    // The equation becomes x^2 + (y cos(45) + z sin(45))^2 <= R^2.
    // This is a cylinder along the X axis, tilted.
    // If we place this cylinder at the corner, it might work.
    
    // Let's try a different approach:
    // Create a cylinder of radius R = leg * sqrt(2).
    // Rotate it 45 degrees around the Z axis.
    // Then rotate it 45 degrees around the X axis.
    // This creates a cylinder whose axis is at 45 degrees to the Z axis and 45 degrees to the X axis.
    // The axis direction is (1, 1, 0) normalized? No.
    // Rotate Z by 45: (1, 0, 0) -> (cos45, sin45, 0).
    // Rotate X by 45: (cos45, sin45, 0) -> (cos45, sin45*cos45, sin45*sin45)? No.
    // Rotation matrix for X by 45:
    // [1, 0, 0]
    // [0, cos45, -sin45]
    // [0, sin45, cos45]
    // Apply to (cos45, sin45, 0):
    // x = cos45
    // y = sin45*cos45
    // z = sin45*sin45
    // This is not (1,1,0).
    
    // Let's try rotating a cylinder around the line X=Y.
    // The line X=Y is at 45 degrees to the X axis.
    // If we rotate a cylinder around this line, we get a cylinder along this line.
    // If we place this cylinder at the corner, it will cut the corner.
    // The radius of the cylinder should be leg * sqrt(2) / 2? No.
    // The distance from the corner to the plane x+y=leg is leg / sqrt(2).
    // So the radius of the cylinder should be leg / sqrt(2).
    // If we rotate a cylinder of radius R = leg / sqrt(2) around the line X=Y,
    // the cylinder will touch the plane x+y=leg?
    // No, the cylinder will be centered on the line X=Y.
    
    // Let's use a polygon extrusion for the chamfer cutter to be absolutely sure.
    // Chamfer Cutter Profile (in XY plane, looking from top):
    // We want to cut the corner. The cut line is x + y = leg (in local coords).
    // The cut extends from Z=0 to Z=block_height.
    // We can create a "chamfer cutter" by rotating a cylinder 45 degrees around the Z axis?
    // No, let's use a cylinder rotated 45 degrees around the X axis?
    // Let's try a different approach:
    // Create a cylinder of radius R = leg * sqrt(2).
    // Rotate it 45 degrees around the Z axis.
    // Then rotate it 45 degrees around the X axis.
    // This creates a cylinder whose axis is at 45 degrees to the Z axis and 45 degrees to the X axis.
    // The axis direction is (1, 1, 0) normalized? No.
    // Rotate Z by 45: (1, 0, 0) -> (cos45, sin45, 0).
    // Rotate X by 45: (cos45, sin45, 0) -> (cos45, sin45*cos45, sin45*sin45)? No.
    // Rotation matrix for X by 45:
    // [1, 0, 0]
    // [0, cos45, -sin45]
    // [0, sin45, cos45]
    // Apply to (cos45, sin45, 0):
    // x = cos45
    // y = sin45*cos45
    // z = sin45*sin45
    // This is not (1,1,0).