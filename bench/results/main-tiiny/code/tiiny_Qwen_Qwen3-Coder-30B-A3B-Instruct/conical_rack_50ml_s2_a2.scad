// Dimensions
plate_length = 130;   // X direction
plate_width = 90;     // Y direction
plate_thickness = 4;   // Z direction

hole_diameter = 30.5; // Diameter of each hole
hole_spacing_x = 40;  // Centre-to-centre spacing in X
hole_spacing_y = 40;    // Centre-to-centre spacing in Y
hole_rows = 2;        // Number of rows
hole_cols = 3;        // Number of columns

wall_height = 70;     // Height of the walls
wall_thickness = 4;   // Thickness of the walls (Y direction)

// Main plate
plate = cube([plate_length, plate_width, plate_thickness], center = true);

// Holes
hole_group = [];
for (i = [0 : hole_cols - 1]) {
  for (j = [0 : hole_rows - 1]) {
    translate([i * hole_spacing_x - (hole_cols - 1) * hole_spacing_x / 2, 
                j * hole_spacing_y - (hole_rows - 1) * hole_spacing_y / 2, 
                0])
    cylinder(h = plate_thickness + 1, d = hole_diameter, center = true, $fn = 64);
  }
}

// Walls
wall1 = translate([0, plate_width/2, plate_thickness/2]) 
        cube([plate_length, wall_thickness, wall_height], center = true);

wall2 = translate([0, -plate_width/2, plate_thickness/2]) 
        cube([plate_length, wall_thickness, wall_height], center = true);

// Final assembly
union() {
  plate;
  hole_group;
  wall1;
  wall2;
}