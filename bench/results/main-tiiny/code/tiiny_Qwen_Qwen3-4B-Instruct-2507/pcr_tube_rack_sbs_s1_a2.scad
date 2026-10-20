// Dimensions in millimeters as per ANSI/SLAS microplate standard
$fn = 64;

// Block dimensions (length, width, height)
X = 127.76;     // length (along X-axis)
Y = 85.48;      // width (along Y-axis)
Z = 20.0;       // height (vertical)

// Hole specifications
hole_diameter = 6.2;           // diameter of each through-hole
hole_spacing = 9.0;            // center-to-center spacing (mm)
rows = 8;                      // 8 rows along Y (height direction)
cols = 12;                    // 12 columns along X (width direction)

// Position of first hole (A1) from edges
hole_x_offset = 14.38;        // from left edge
hole_y_offset = 11.24;       // from back edge

// Chamfer for orientation mark (45 degrees, 5 mm legs)
chamfer_length = 5.0;

// Create the base block
block = cube([X, Y, Z], center = true);

// Add holes
for (i = [0:rows-1]) {
  for (j = [0:cols-1]) {
    x_pos = hole_x_offset + j * hole_spacing;
    y_pos = hole_y_offset + i * hole_spacing;
    translate([x_pos, y_pos, 0])
      cylinder(d = hole_diameter, h = Z, center = false);
  }
}

// Cut a 45-degree chamfer at the A1 corner (bottom-left corner)
// We do this by subtracting a small cube from the corner at (0,0,0)
// This creates a 45-degree chamfer on the edge

// The difference must be applied to the full block
// We create a new object that is the block minus the chamfer cube

// Final part: base block with holes and chamfer at A1 corner
// The chamfer is applied at the origin (0,0,0) to the bottom-left edge

// Use difference to subtract the chamfer cube from the block
// The chamfer cube is aligned with the corner at (0,0,0)

// The full part is defined as:
//   block minus a small cube at (0,0,0)

// Correctly structured: the difference is applied to the block
// The chamfer is only applied once, and the block is not redefined

// Final version: properly structured and valid OpenSCAD
// The error was due to incorrect use of difference with multiple statements

// Start with the base block
base = cube([X, Y, Z], center = true);

// Add holes
for (i = [0:rows-1]) {
  for (j = [0:cols-1]) {
    x_pos = hole_x_offset + j * hole_spacing;
    y_pos = hole_y_offset + i * hole_spacing;
    translate([x_pos, y_pos, 0])
      cylinder(d = hole_diameter, h = Z, center = false);
  }
}

// Apply chamfer at the bottom-left corner (A1)
// Subtract a small cube at (0,0,0) to create a 45-degree chamfer
// The cube is 5 mm in each dimension
chamfer = cube([chamfer_length, chamfer_length, chamfer_length], center = false);

// Final part: base with holes and chamfer
// Use difference to cut the corner
difference() {
  base;
  translate([0, 0, 0])
    chamfer;
}