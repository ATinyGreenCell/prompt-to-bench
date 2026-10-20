// Define dimensions
plate_length_X = 130;  // Length along X-axis
plate_length_Y = 90;  // Length along Y-axis
plate_thickness = 4; // Thickness of the plate (Z-direction)
hole_diameter = 30.5; // Diameter of through-holes
hole_spacing_X = 40;  // Spacing between holes along X-axis
hole_spacing_Y = 40;   // Spacing between holes along Y-axis
wall_thickness = 4;    // Thickness of the walls (Y-direction)
wall_height = 70;      // Height of the walls (Z-direction)

// Create the base plate
plate = cube([plate_length_X, plate_length_Y, plate_thickness]);

// Create the through-holes
holes = [
  for (i = [0:2]) 
    for (j = [0:1]) 
      translate([i * hole_spacing_X + (plate_length_X - 2 * hole_spacing_X) / 2, 
                 j * hole_spacing_Y + (plate_length_Y - 2 * hole_spacing_Y) / 2, 
                 0]) 
        cylinder(h = plate_thickness, r = hole_diameter / 2, $fn = 64)
];

// Create the walls
wall1 = translate([0, 0, 0]) 
       rotate([0, 0, 0]) 
       cube([plate_length_X, wall_thickness, wall_height]);

wall2 = translate([0, plate_length_Y, 0]) 
       rotate([0, 0, 0]) 
       cube([plate_length_X, wall_thickness, wall_height]);

// Combine the plate with the walls
rack = union() {
  plate;
  wall1;
  wall2;
};

// Subtract the holes from the rack
final_rack = difference() {
  rack;
  holes;
};

// Output the final rack
final_rack;