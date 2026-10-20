// Dimensions for the PCR tube rack
$fn = 64; // For curved shapes like chamfers

// Overall block dimensions
block_length = 127.76; // X-axis length
block_width = 85.48;  // Y-axis width
block_height = 20;    // Z-axis height

// Hole grid parameters
num_rows = 8;          // Number of rows along Y
num_cols = 12;        // Number of columns along X
hole_diameter = 6.2; // Diameter of each through hole
spacing = 9.0;         // Centre-to-centre spacing between holes

// Position of the first hole (A1)
first_hole_x = 14.38; // Distance from left edge (X)
first_hole_y = 11.24; // Distance from back edge (Y)

// Chamfer parameters
chamfer_length = 5;   // Length of the chamfer leg
chamfer_angle = 45;  // Angle of the chamfer in degrees

// Create the main block
block = cube([block_length, block_width, block_height]);

// Create the hole grid using a for loop
holes = [];
for (row = [0:num_rows-1]) {
  for (col = [0:num_cols-1]) {
    // Calculate the position of each hole
    x = first_hole_x + col * spacing;
    y = first_hole_y + row * spacing;
    // Create a cylinder for each hole
    hole = cylinder(r = hole_diameter / 2, h = block_height, $fn = 64);
    // Translate the hole to its position
    hole = translate([x, y, 0]) * hole;
    holes += hole;
  }
}

// Create the chamfer at the A1 corner
chamfer = 
  rotate([0, 0, chamfer_angle]) *
  translate([-chamfer_length, -chamfer_length, 0]) *
  cube([chamfer_length * 2, chamfer_length * 2, block_height]);

// Combine the block with the holes and chamfer
rack = block - holes;
rack = rack - chamfer;

// Output the final rack
union() {
  rack;
  // Optional: Add a small protrusion to the bottom for better printing
  protrusion = cube([block_length, block_width, 0.5], center=false);
  protrusion = translate([0, 0, -0.5]) * protrusion;
  protrusion;
}