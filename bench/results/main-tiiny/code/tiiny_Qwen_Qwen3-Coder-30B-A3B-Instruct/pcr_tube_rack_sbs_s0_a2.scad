// PCR Tube Rack for 96 PCR Tubes (0.2 mL)
// Dimensions in mm

// Block dimensions
length = 127.76;    // X dimension
width = 85.48;      // Y dimension
height = 20;        // Z dimension

// Hole grid parameters
hole_diameter = 6.2; // Diameter of each hole
rows = 8;           // Number of rows (along Y)
cols = 12;          // Number of columns (along X)
spacing = 9.0;      // Centre-to-centre spacing

// Positioning of the first hole (A1)
x_offset = 14.38;   // Distance from left edge to A1 hole centre
y_offset = 11.24;   // Distance from back edge to A1 hole centre

// Create the main block
rack = cube([length, width, height], center = false);

// Create the hole grid
hole_grid = 
    for (row = [0 : rows - 1]) {
        for (col = [0 : cols - 1]) {
            translate([
                x_offset + col * spacing,
                y_offset + row * spacing,
                0
            ])
            cylinder(h = height + 0.01, d = hole_diameter, center = true, $fn = 64);
        }
    }

// Create the chamfer at the A1 corner
chamfer = 
    translate([0, 0, 0])
    rotate([0, 0, 0])
    polyhedron(
        points = [
            [0, 0, 0],
            [chamfer_length, 0, 0],
            [0, chamfer_length, 0],
            [0, 0, height]
        ],
        triangles = [
            [0, 1, 2],
            [0, 3, 1],
            [0, 2, 3],
            [1, 3, 2]
        ]
    );

// Combine all parts
union() {
    rack;
    hole_grid;
    chamfer;
}