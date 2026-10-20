plate_length = 130;   // X dimension of the plate (mm)
plate_width = 90;     // Y dimension of the plate (mm)
plate_thickness = 4;    // Z thickness of the plate (mm)
hole_diameter = 30.5; // Diameter of each hole (mm)
hole_radius = hole_diameter / 2;
hole_spacing = 40;  // Center-to-center spacing between holes (mm)
wall_thickness = 4; // Thickness of the side walls (mm)
wall_height = 70;     // Height of the side walls (mm)

plate = 
  translate([-plate_length/2, -plate_width/2, 0])
  cube([plate_length, plate_width, plate_thickness]);

wall1 = 
  translate([-plate_length/2, -plate_width/2 - wall_thickness, 0])
  cube([plate_length, wall_thickness, wall_height]);

wall2 = 
  translate([-plate_length/2, plate_width/2, 0])
  cube([plate_length, wall_thickness, wall_height]);

holes = 
  difference() {
    plate;
    for (i = [0:2]) {
      for (j = [0:1]) {
        x = -hole_spacing + i * hole_spacing;
        y = -hole_spacing/2 + j * hole_spacing;
        translate([x, y, -0.01])
        cylinder(r = hole_radius, h = plate_thickness + 0.02, $fn = 64);
      }
    }
  };

rack = union() {
  holes;
  wall1;
  wall2;
}

rack;