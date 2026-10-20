// Define dimensions
fan_diameter = 80; // Outer diameter of the fan
top_plate_thickness = 2; // Thickness of the top plate
wall_thickness = 2.5; // Thickness of the walls
outer_size_x = 90; // Outer size in X direction
outer_size_y = 90; // Outer size in Y direction
hole_diameter = 4.5; // Diameter of M4 screw holes
hole_pattern_side = 71.5; // Square pattern side length for holes
notch_width = 12; // Width of the cable notch
notch_depth = 8; // Depth of the cable notch from from open edge

// Create the top plate (lying on z=0 to z=2)
top_plate = cube([outer_size_x, outer_size_y, top_plate_thickness], center=true);

// Create the walls (rising from the top plate to z=40)
wall_height = 40 - top_plate_thickness; // Height of walls from top plate to open edge
walls = union() {
  // Left wall
  translate([-outer_size_x/2, -outer_size_y/2, 0]) 
    cube([wall_thickness, outer_size_y, wall_height], center=true);
  // Right wall
  translate([outer_size_x/2, -outer_size_y/2, 0]) 
    cube([wall_thickness, outer_size_y, wall_height], center=true);
  // Front wall
  translate([-outer_size_x/2, outer_size_y/2, 0]) 
    cube([outer_size_x, wall_thickness, wall_height], center=true);
  // Back wall
  translate([-outer_size_x/2, -outer_size_y/2, 0]) 
    cube([outer_size_x, wall_thickness, wall_height], center=true);
}

// Create screw holes in the top plate
holes = difference() {
  // Create a square grid of holes
  for (i = [0:3]) {
    for (j = [0:3]) {
      // Calculate hole position
      x = -outer_size_x/2 + hole_pattern_side/2 - i*hole_pattern_side/4;
      y = -outer_size_y/2 + hole_pattern_side/2 - j*hole_pattern_side/4;
      // Create a cylinder for each hole
      translate([x, y, 0]) 
        cylinder(r=hole_diameter/2, h=top_plate_thickness, $fn=64);
    }
  }
  // Cut out the top plate to form the housing
  top_plate;
}

// Create the cable notch in one wall (e.g., front wall)
notch = difference() {
  // Create a rectangular block for the notch
  translate([-outer_size_x/2, outer_size_y/2 - notch_depth, 0]) 
    cube([outer_size_x, notch_width, wall_height], center=true);
  // Subtract a rectangular block to form the notch
  translate([-outer_size_x/2, outer_size_y/2 - notch_depth - notch_width/2, 0]) 
    cube([outer_size_x, notch_width, notch_depth + 0.5], center=true);
}

// Combine all parts
housing = union() {
  walls;
  holes;
  notch;
}

// Final output
housing;