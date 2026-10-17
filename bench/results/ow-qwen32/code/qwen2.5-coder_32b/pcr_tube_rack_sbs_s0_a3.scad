// Dimensions in millimetres
block_length = 127.76;  // Length of the block (X)
block_width = 85.48;    // Width of the block (Y)
block_height = 20;      // Height of the block (Z)
hole_diameter = 6.2;    // Diameter of each hole
hole_spacing = 9.0;     // Centre-to-centre spacing of holes
first_hole_x = 14.38;   // X-coordinate of the centre of the first hole (A1)
first_hole_y = 11.24;   // Y-coordinate of the centre of the first hole (A1)
chamfer_leg_length = 5; // Length of the chamfer legs

$fn = 64; // Number of fragments for curved shapes

// Base block
base_block = cube(size = [block_length, block_width, block_height], center = false);

// Chamfer at the A1 corner
chamfer = translate([first_hole_x, block_width - first_hole_y, 0])
          rotate([0, -45, 0])
          cube(size = [chamfer_leg_length * sqrt(2), chamfer_leg_length * sqrt(2), block_height + 1], center = true);

// Holes for PCR tubes
holes = union() {
    for (i = [0:11], j = [0:7]) {
        translate([first_hole_x + i * hole_spacing, block_width - (first_hole_y + j * hole_spacing), 0])
        cylinder(r = hole_diameter / 2, h = block_height + 1, center = true);
    }
};

// Final part with chamfer and holes
difference() {
    base_block;
    chamfer;
    holes;
}