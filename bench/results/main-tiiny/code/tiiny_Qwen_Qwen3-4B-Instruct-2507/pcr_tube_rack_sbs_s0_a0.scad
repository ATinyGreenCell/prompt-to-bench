// Dimensions in millimeters as per ANSI/SLAS microplate standard
$fn = 64;

// Block dimensions (length, width, height)
X = 127.76;     // length along X-axis (front to back)
Y = 85.48;      // width along Y-axis (left to right)
Z = 20.0;       // height (thickness)

// Hole specifications
hole_diameter = 6.2;           // diameter of each hole
hole_center_to_center = 9.0;   // center-to-center spacing in mm

// Position of first hole (A1) from edges
A1_x_offset = 14.38;   // from left edge
A1_y_offset = 11.24;   // from back edge

// Chamfer for orientation mark
chamfer_length = 5.0;   // length of chamfer leg
chamfer_angle = 45;     // 45 degrees

// Number of rows and columns
rows = 8;       // along Y-axis (height)
cols = 12;      // along X-axis (width)

// Create the base block
block = cube([X, Y, Z], center = true);

// Define hole positions in the grid
// We center the grid on the origin, so we calculate the offset from center
// Center of block is at (X/2, Y/2, 0)
// First hole at (A1_x_offset, A1_y_offset) from edges, so relative to center:
// x_offset = X/2 - A1_x_offset
// y_offset = Y/2 - A1_y_offset

// Calculate the grid of hole positions
// Each hole is at (x, y) in the XY plane, with center at (x, y)
// The first hole (A1) is at (A1_x_offset, A1_y_offset)
// We place holes in a grid with spacing hole_center_to_center

// Create a list of hole positions
// We will use a for loop to generate holes in 8 rows and 12 columns

// Start with the base block
difference() {
    // Base block
    union() {
        block;
        
        // Add holes: 8 rows x 12 columns
        for (i = [0:11]) {
            for (j = [0:7]) {
                // Calculate position of hole
                x = A1_x_offset + i * hole_center_to_center;
                y = A1_y_offset + j * hole_center_to_center;
                
                // Create a cylinder for each hole
                translate([x, y, -hole_diameter/2]) {
                    cylinder(h = Z, r = hole_diameter/2, f = 0);
                }
            }
        }
        
        // Add 45-degree chamfer at A1 corner (bottom-left of first hole)
        // The corner is at (A1_x_offset, A1_y_offset)
        // Chamfer extends 5 mm along both X and Y directions at 45 degrees
        translate([A1_x_offset - chamfer_length, A1_y_offset - chamfer_length, 0]) {
            rotate([0, 0, chamfer_angle]) {
                cube([chamfer_length * 2, chamfer_length * 2, Z], center = false);
            }
        }
    }
}