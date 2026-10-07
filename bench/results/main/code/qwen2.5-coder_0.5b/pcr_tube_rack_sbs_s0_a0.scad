// Define the dimensions of the rack
length = 127.76;
width = 85.48;
height = 20;

// Define the number of holes and their positions
num_holes = 96;
x_pos = 14.38;
y_pos = 11.24;

// Define the diameter of each hole
diameter = 6.2;

// Define the spacing between holes
spacing = 9.0;

// Define the number of rows and columns in the grid
num_rows = 12;
num_cols = 8;

// Define the center position for the first hole
center_x = x_pos + (width / 2);
center_y = y_pos + (height / 2);

// Define the chamfer radius
chamfer_radius = 5;

// Define the chamfer orientation
chamfer_orientation = "45";

// Create the block for the rack
block("Rack", length, width, height, chamfer_radius, chamfer_orientation);

// Define the holes in the grid
for (int i = 1; i <= num_holes; i++) {
    // Calculate the position of the hole
    x_pos = center_x + (i - 1) * spacing;
    y_pos = center_y + (i - 1) * spacing;

    // Define the dimensions of the hole
    hole_length = diameter / 2;
    hole_width = diameter / 2;

    // Create the cube for the hole
    cube("Hole", hole_length, hole_width, hole_length);

    // Define the chamfer on the vertical edge at the A1 corner
    chamfer("Chamfer", center_x + (i - 1) * spacing, center_y + (i - 1) * spacing, 0.5, chamfer_radius);
}