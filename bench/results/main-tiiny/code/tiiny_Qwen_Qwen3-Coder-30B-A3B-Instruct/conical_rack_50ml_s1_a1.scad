// Dimensions
plate_length = 130;    // X direction
plate_width = 90;     // Y direction
plate_thickness = 4;    // Z direction
hole_diameter = 30.5;   // Through-hole diameter
hole_spacing = 40;    // Centre-to-centre spacing
wall_height = 70;     // Height of walls
wall_thickness = 4; // Y direction thickness of walls

// Plate base
plate = cube([plate_length, plate_width, plate_thickness], center = true);

// Holes
num_holes_x = 3;
num_holes_y = 2;
hole_radius = hole_diameter / 2;

hole_positions_x = [
  -hole_spacing, 
   0, 
  +hole_spacing
];

hole_positions_y = [
  -hole_spacing/2,
   hole_spacing/2
];

// Create holes
holes = [];
for (x = [0:num_holes_x-1]) {
  for (y = [0:num_holes_y-1]) {
    holes = concat(holes, [
      translate([hole_positions_x[x], hole_positions_y[y], 0]) 
      cylinder(r = hole_radius, h = plate_thickness + 1, $fn = 64)
    ]);
  }
}

// Walls
wall = cube([plate_length, wall_thickness, wall_height], center = true);

// Left wall
left_wall = translate([0, plate_width/2 - wall_thickness/2, wall_height/2]) wall;

// Right wall
right_wall = translate([0, -(plate_width/2 - wall_thickness/2), wall_height/2]) wall;

// Combine all parts
rack = union() {
  plate;
  left_wall;
  right_wall;
  for (x = [0:num_holes_x-1]) {
    for (y = [0:num_holes_y-1]) {
      translate([hole_positions_x[x], hole_positions_y[y], 0]) 
      cylinder(r = hole_radius, h = plate_thickness + 1, $fn = 64);
    }
  }
}

// Final assembly
rack;