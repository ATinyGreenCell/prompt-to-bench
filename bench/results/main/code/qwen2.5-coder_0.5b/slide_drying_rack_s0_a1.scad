// Define variables for dimensions
let x = 90; // Length of the base block
let y = 45; // Width of the base block
let z = 20; // Height of the base block

// Define variables for slot dimensions
let slot_length = 77; // Length of each slot
let slot_width = 1.6; // Width of each slot
let slot_depth = 10; // Depth of each slot
let slot_spacing = 3.5; // Spacing between slots

// Define variables for the center of the block
let x_center = (x / 2);
let y_center = (y / 2);

// Define variables for the top face of the rack
let top_face = cube(x, y, z);

// Define variables for the slots on the top face
let slot_top = cylinder(top_face, slot_length, slot_width, slot_depth, slot_spacing, $fn);
slot_top.translate((x_center - slot_width / 2, y_center - slot_height / 2, z + slot_depth / 2));

// Define variables for the center of each slot on the top face
let slot_top_x = x_center - slot_width / 2;
let slot_top_y = y_center - slot_height / 2;

// Define variables for the bottom face of the rack
let bottom_face = cube(x, y, z);

// Define variables for the slots on the bottom face
let slot_bottom = cylinder(bottom_face, slot_length, slot_width, slot_depth, slot_spacing, $fn);
slot_bottom.translate((x_center + slot_width / 2, y_center - slot_height / 2, z + slot_depth / 2));

// Define variables for the center of each slot on the bottom face
let slot_bottom_x = x_center + slot_width / 2;
let slot_bottom_y = y_center + slot_height / 2;

// Define variables for the left face of the rack
let left_face = cube(x, y, z);

// Define variables for the slots on the left face
let slot_left = cylinder(left_face, slot_length, slot_width, slot_depth, slot_spacing, $fn);
slot_left.translate((x_center - slot_width / 2, y_center + slot_height / 2, z + slot_depth / 2));

// Define variables for the right face of the rack
let right_face = cube(x, y, z);

// Define variables for the slots on the right face
let slot_right = cylinder(right_face, slot_length, slot_width, slot_depth, slot_spacing, $fn);
slot_right.translate((x_center + slot_width / 2, y_center - slot_height / 2, z + slot_depth / 2));

// Define variables for the front face of the rack
let front_face = cube(x, y, z);

// Define variables for the slots on the front face
let slot_front = cylinder(front_face, slot_length, slot_width, slot_depth, slot_spacing, $fn);
slot_front.translate((x_center - slot_width / 2, y_center + slot_height / 2, z + slot_depth / 2));

// Define variables for the back face of the rack
let back_face = cube(x, y, z);

// Define variables for the slots on the back face
let slot_back = cylinder(back_face, slot_length, slot_width, slot_depth, slot_spacing, $fn);
slot_back.translate((x_center + slot_width / 2, y_center - slot_height / 2, z + slot_depth / 2));

// Define variables for the top edge of the rack
let top_edge = cylinder(top_face, slot_length, slot_width, slot_depth, slot_spacing, $fn);
top_edge.translate((x_center - slot_width / 2, y_center - slot_height / 2, z + slot_depth / 2));

// Define variables for the bottom edge of the rack
let bottom_edge = cylinder(bottom_face, slot_length, slot_width, slot_depth, slot_spacing, $fn);
bottom_edge.translate((x_center + slot_width / 2, y_center - slot_height / 2, z + slot_depth / 2));

// Define variables for the left edge of the rack
let left_edge = cylinder(left_face, slot_length, slot_width, slot_depth, slot_spacing, $fn);
left_edge.translate((x_center - slot_width / 2, y_center + slot_height / 2, z + slot_depth / 2));

// Define variables for the right edge of the rack
let right_edge = cylinder(right_face, slot_length, slot_width, slot_depth, slot_spacing, $fn);
right_edge.translate((x_center + slot_width / 2, y_center - slot_height / 2, z + slot_depth / 2));

// Define variables for the front face of the rack
let front_face = cube(x, y, z);

// Define variables for the slots on the front face
let slot_front = cylinder(front_face, slot_length, slot_width, slot_depth, slot_spacing, $fn);
slot_front.translate((x_center - slot_width / 2, y_center + slot_height / 2, z + slot_depth / 2));

// Define variables for the back face of the rack
let back_face = cube(x, y, z);

// Define variables for the slots on the back face
let slot_back = cylinder(back_face, slot_length, slot_width, slot_depth, slot_spacing, $fn);
slot_back.translate((x_center + slot_width / 2, y_center - slot_height / 2, z + slot_depth / 2));

// Define variables for the top edge of the rack
let top_edge = cylinder(top_face, slot_length, slot_width, slot_depth, slot_spacing, $fn);
top_edge.translate((x_center - slot_width / 2, y_center - slot_height / 2, z + slot_depth / 2));

// Define variables for the bottom edge of the rack
let bottom_edge = cylinder(bottom_face, slot_length, slot_width, slot_depth, slot_spacing, $fn);
bottom_edge.translate((x_center + slot_width / 2, y_center - slot_height / 2, z + slot_depth / 2));

// Define variables for the left edge of the rack
let left_edge = cylinder(left_face, slot_length, slot_width, slot_depth, slot_spacing, $fn);
left_edge.translate((x_center - slot_width / 2, y_center + slot_height / 2, z + slot_depth / 2));

// Define variables for the right edge of the rack
let right_edge = cylinder(right_face, slot_length, slot_width, slot_depth, slot_spacing, $fn);
right_edge.translate((x_center + slot_width / 2, y_center - slot_height / 2, z + slot_depth / 2));

// Define variables for the front face of the rack
let front_face = cube(x, y, z);

// Define