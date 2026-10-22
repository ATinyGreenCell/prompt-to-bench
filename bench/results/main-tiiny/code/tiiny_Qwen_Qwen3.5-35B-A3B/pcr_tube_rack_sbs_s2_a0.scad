// Dimensions for 96 PCR tube rack (ANSI/SLAS footprint)
// All units in millimetres (mm)

// Block dimensions
block_length = 127.76;   // X dimension (length)
block_width = 85.48;      // Y dimension (width)
block_height = 20.0;      // Z dimension (height)

// Hole specifications
hole_diameter = 6.2;     // Diameter of PCR tube holes
hole_radius = hole_diameter / 2;

// Grid layout
rows = 8;                // Number of rows (along Y)
cols = 12;               // Number of columns (along X)
pitch_x = 9.0;           // Center-to-center spacing in X (mm)
pitch_y = 9.0;           // Center-to-center spacing in Y (mm)

// Position of first hole (A1) relative to block edges
// A1 is at bottom-left when viewing from top (Y positive is forward)
// Distance from left edge (X=0) to first hole center
offset_x = 14.38;
// Distance from back edge (Y=0) to first hole center
offset_y = 11.24;

// Chamfer dimensions
chamfer_leg = 5.0;      // Length of chamfer legs (mm)
chamfer_angle = 45;   // Chamfer angle (degrees)

// Ensure high resolution for round holes
$fn = 64;

// Main block
module main_block() {
    // Center the block on origin in X and Y
    translate([-block_length/2, -block_width/2, 0]) {
        cube([block_length, block_width, block_height]);
    }
}

// Create the grid of holes
module holes_grid() {
    // Calculate total grid span to ensure proper centering
    // Total width of grid = (cols - 1) * pitch_x
    // Total height of grid = (rows - 1) * pitch_y
    
    // We need to position the first hole at offset_x from left and offset_y from back
    // The block is centered at origin.
    // Left edge of block is at -block_length/2.
    // First hole X center = -block_length/2 + offset_x
    // First hole Y center = -block_width/2 + offset_y
    
    // However, the problem states the grid is centered on the block.
    // Let's verify: 
    // Total grid width = (12-1)*9 = 99mm.
    // Block width = 127.76mm.
    // Margin on each side = (127.76 - 99) / 2 = 14.38mm. This matches offset_x.
    // Total grid height = (8-1)*9 = 63mm.
    // Block height = 85.48mm.
    // Margin on each side = (85.48 - 63) / 2 = 11.24mm. This matches offset_y.
    // So the grid is indeed centered.
    
    for (i = [0 : cols-1]) {
        for (j = [0 : rows-1]) {
            // Calculate hole center coordinates relative to block origin
            // X: offset_x + i * pitch_x
            // Y: offset_y + j * pitch_y
            // But we need to translate relative to the block's local origin (0,0,0)
            // The block is centered at 0,0.
            // So hole center = [-block_length/2 + offset_x + i*pitch_x, -block_width/2 + offset_y + j*pitch_y, 0]
            
            hole_x = -block_length/2 + offset_x + i * pitch_x;
            hole_y = -block_width/2 + offset_y + j * pitch_y;
            
            translate([hole_x, hole_y, 0]) {
                cylinder(h = block_height + 0.1, r = hole_radius, center = true);
            }
        }
    }
}

// Create the 45-degree chamfer at the A1 corner
// A1 corner is the bottom-left corner of the block (when viewing from top, Y positive forward).
// In our coordinate system:
// Block extends from X: -block_length/2 to +block_length/2
// Block extends from Y: -block_width/2 to +block_width/2
// A1 is at X = -block_length/2 + offset_x (approx -47.5) and Y = -block_width/2 + offset_y (approx -31.5)
// Wait, the chamfer is "off the vertical edge at the A1 corner".
// A1 corner of the rack is the corner of the block itself? Or the corner of the hole grid?
// "Cut a 45-degree chamfer with 5 mm legs off the vertical edge at the A1 corner".
// Usually, this means the corner of the block where A1 is located.
// A1 is the first hole. The corner of the block is at (-block_length/2, -block_width/2).
// The chamfer is 5mm legs.
// We need to cut a wedge from the corner.
// The corner is at X = -block_length/2, Y = -block_width/2, Z = 0 to 20.
// We will use a difference operation to cut a wedge.
// The wedge can be modeled as a triangular prism or by cutting with a plane.
// Simplest way: Create a large triangular prism that intersects the corner and subtract it.
// Or, create a wedge shape that fits the corner.
// Let's create a wedge that cuts the corner.
// The wedge will be a triangular prism with the right angle at the corner.
// The legs are 5mm.
// We need to cut the corner of the block.
// The corner is at (-block_length/2, -block_width/2).
// We will create a triangular prism that extends from the corner.
// The prism will have a base triangle in the XY plane and height in Z.
// The triangle vertices:
// 1. (-block_length/2, -block_width/2) - the corner
// 2. (-block_length/2 + 5, -block_width/2) - 5mm along X
// 3. (-block_length/2, -block_width/2 + 5) - 5mm along Y
// We need to cut this out.
// Actually, a 45 degree chamfer on a vertical edge usually means a bevel on the corner.
// If we cut a 5mm leg chamfer, we are removing material from the corner.
// We can do this by subtracting a triangular prism.
// The prism will be defined by the triangle in XY and extruded in Z.
// But we need to be careful with the orientation.
// The chamfer is on the "vertical edge at the A1 corner".
// The vertical edge at A1 corner is the edge where X=-block_length/2 and Y=-block_width/2.
// We want to cut a 45 degree angle.
// Let's create a wedge that removes the corner.
// We can use a difference with a triangular prism.
// The triangular prism will have vertices:
// (-block_length/2, -block_width/2, 0)
// (-block_length/2 + 5, -block_width/2, 0)
// (-block_length/2, -block_width/2 + 5, 0)
// And extruded to Z = block_height.
// But wait, a 45 degree chamfer on a corner usually creates a flat surface.
// If we cut a triangular prism, we get a flat surface.
// The angle of the cut surface relative to the faces will be 45 degrees if the legs are equal.
// Yes, legs are 5mm.
// So we subtract a triangular prism.
module chamfer_corner() {
    // Define the triangular prism to subtract
    // Base triangle in XY plane
    // Vertices:
    // P1: (-block_length/2, -block_width/2)
    // P2: (-block_length/2 + chamfer_leg, -block_width/2)
    // P3: (-block_length/2, -block_width/2 + chamfer_leg)
    // Extrude to Z = block_height
    // We need to make sure the cut goes through the entire height.
    // The prism will be defined by the triangle and extruded.
    // But we need to make sure the cut is clean.
    // We can use a polygon for the base and linear_extrude.
    polygon([[0,0], [chamfer_leg, 0], [0, chamfer_leg]]);
    // Translate to the corner
    translate([-block_length/2, -block_width/2, 0]) {
        linear_extrude(height = block_height) {
            polygon([[0,0], [chamfer_leg, 0], [0,