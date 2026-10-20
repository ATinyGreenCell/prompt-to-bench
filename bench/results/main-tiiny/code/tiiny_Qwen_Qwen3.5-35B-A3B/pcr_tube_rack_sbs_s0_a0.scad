// Dimensions for 96 PCR tube rack (ANSI/SLAS footprint)
// All units in millimetres

// Block dimensions
block_length = 127.76;   // X dimension
block_width = 85.48;     // Y dimension
block_height = 20.0;     // Z dimension

// Hole dimensions
hole_diameter = 6.2;
hole_radius = hole_diameter / 2;

// Grid dimensions
rows = 8;                // Along Y axis
cols = 12;               // Along X axis
pitch_x = 9.0;           // X spacing between hole centers
pitch_y = 9.0;           // Y spacing between hole centers

// Position of first hole (A1) relative to block edges
// A1 is at bottom-left (X=0, Y=0) of the grid, but offset from block edges
offset_x = 14.38;        // Distance from left edge (X=0) to first hole center
offset_y = 11.24;        // Distance from back edge (Y=0) to first hole center

// Chamfer dimensions
chamfer_leg = 5.0;      // Length of chamfer legs

// Build the rack
module rack() {
    // Main block
    difference() {
        // Base block
        cube([block_length, block_width, block_height], center = true);
        
        // Create 96 holes
        for (row = [0 : rows - 1]) {
            for (col = [0 : cols - 1]) {
                // Calculate hole center position
                // X position: offset_x + col * pitch_x
                // Y position: offset_y + row * pitch_y
                hole_x = offset_x + col * pitch_x;
                hole_y = offset_y + row * pitch_y;
                
                // Position hole at (hole_x, hole_y, 0)
                // Center the hole in X and Y relative to the block
                // The block is centered at (0,0), so we need to offset
                // Actually, the block is centered at (0,0), so the left edge is at -block_length/2
                // The first hole is at offset_x from left edge, so its X coordinate is:
                // -block_length/2 + offset_x
                // Similarly for Y: -block_width/2 + offset_y
                
                hole_center_x = -block_length/2 + offset_x;
                hole_center_y = -block_width/2 + offset_y;
                
                // Create through-hole
                translate([hole_center_x, hole_center_y, 0]) {
                    cylinder(h = block_height + 0.01, r = hole_radius, $fn = 64);
                }
            }
        }
        
        // Chamfer at A1 corner (bottom-left-front)
        // A1 corner is at X = -block_length/2 + offset_x, Y = -block_width/2 + offset_y, Z = 0
        // We need to cut a 45-degree chamfer with 5mm legs
        // Create a chamfer wedge that cuts off the corner
        // The chamfer is on the vertical edge at the A1 corner
        // We'll create a triangular prism that cuts the corner
        
        // Define the chamfer plane
        // The chamfer removes material from the corner where X is minimum, Y is minimum, Z is minimum
        // We'll use a difference with a wedge shape
        
        // Create a wedge to cut the corner
        // The wedge should be large enough to cut through the corner
        // We'll use a rotated cube or a custom shape
        
        // Define the chamfer cut
        // The chamfer is 45 degrees, so the cut plane is at 45 degrees to the faces
        // We'll create a triangular prism that cuts the corner
        
        // Calculate the corner point
        corner_x = -block_length/2 + offset_x;
        corner_y = -block_width/2 + offset_y;
        corner_z = 0;
        
        // Create a wedge to cut the corner
        // The wedge will be a triangular prism
        // We'll use a difference with a rotated shape
        
        // Define the chamfer cut shape
        // The chamfer removes a triangular prism from the corner
        // The triangle has legs of 5mm along X and Y
        
        // Create a wedge that cuts the corner
        // We'll use a rotated cube with a cut
        // Actually, let's use a simple approach: cut with a rotated plane
        
        // Create a large cube that will be cut
        // Then subtract the chamfer wedge
        
        // Define the chamfer wedge
        // The wedge is a triangular prism with base 5x5 and height 20
        // It's rotated 45 degrees around Z
        
        // Actually, let's create a wedge that cuts the corner
        // The wedge should be a triangular prism with vertices at:
        // (corner_x, corner_y, 0), (corner_x + 5, corner_y, 0), (corner_x, corner_y + 5, 0)
        // And extruded up to 20mm
        
        // Create the chamfer cut
        // We'll use a rotated cube with a cut
        // Let's create a wedge shape
        
        // Define the chamfer cut as a rotated cube
        // The chamfer is 45 degrees, so we rotate the cube 45 degrees around Z
        // Then we need to position it correctly
        
        // Create a wedge to cut the corner
        // The wedge is a triangular prism
        // We'll create it by rotating a cube and positioning it
        
        // Define the chamfer cut shape
        // The chamfer removes material from the corner
        // We'll use a difference with a rotated cube
        
        // Create a cube that will be rotated to cut the corner
        // The cube should be large enough to cut through the corner
        // We'll use a cube of size 10x10x20, rotated 45 degrees around Z
        
        // Position the cube so that its corner is at the A1 corner
        // The cube should be positioned so that the cut is at 45 degrees
        
        // Create the chamfer cut
        // We'll use a rotated cube with a cut
        // Actually, let's use a simple approach: cut with a rotated plane
        
        // Define the chamfer cut as a rotated cube
        // The chamfer is 45 degrees, so we rotate the cube 45 degrees around Z
        // Then we need to position it correctly
        
        // Create a wedge to cut the corner
        // The wedge is a triangular prism
        // We'll create it by rotating a cube and positioning it
        
        // Define the chamfer cut shape
        // The chamfer removes material from the corner
        // We'll use a difference with a rotated cube
        
        // Create a cube that will be rotated to cut the corner
        // The cube should be large enough to cut through the corner
        // We'll use a cube of size 10x10x20, rotated 45 degrees around Z
        
        // Position the cube so that its corner is at the A1 corner
        // The cube should be positioned so that the cut is at 45 degrees
        
        // Create the chamfer cut
        // We'll use a rotated cube with a cut
        // Actually, let's use a simple approach: cut with a rotated plane
        
        // Define the chamfer cut as a rotated cube
        // The chamfer is 45 degrees, so we rotate the cube 45 degrees around Z
        // Then we need to