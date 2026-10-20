$fn = 64;

// Dimensions in millimeters
top_plate_thickness = 2;
wall_thickness = 2.5;
outer_width = 90;
wall_height = 38; // From z=2 to z=40 (38mm height)
screw_hole_diameter = 4.5;
screw_hole_pattern_side = 71.5;
notch_width = 12;
notch_height = 8.01; // 8mm + 0.01mm extension for non-coplanar faces

// Top plate (2mm thick, centered at origin)
top_plate = cube([outer_width, outer_width, top_plate_thickness], center = true);

// Four walls (2.5mm thick, 38mm high, built on top plate)
walls = [
  // Left wall (x from -45 to -42.5, y from -45 to 45, z from 2 to 40)
  cube([wall_thickness, outer_width, wall_height], center = false) translate([-45, -45, 2]),
  // Right wall (x from 42.5 to 45, y from -45 to 45, z from 2 to 40)
  cube([wall_thickness, outer_width, wall_height], center = false) translate([45 - wall_thickness, -45, 2]),
  // Back wall (y from -45 to -42.5, x from -45 to 45, z from 2 to 40)
  cube([outer_width, wall_thickness, wall_height], center = false) translate([-45, -45, 2]),
  // Front wall (y from 42.5 to 45, x from -45 to 45, z from 2 to 40)
  cube([outer_width, wall_thickness, wall_height], center = false) translate([-45, 45 - wall_thickness, 2])
];

// Screw holes (4.5mm diameter, 2.02mm height to extend 0.01mm beyond top plate)
hole_points = [[1, 1], [1, -1], [-1, 1], [-1, -1]];
screw_holes = 
  for (p = hole_points)
    cylinder(d = screw_hole_diameter, h = top_plate_thickness + 0.02, center = true)
      translate([p[0] * (screw_hole_pattern_side / 2), p[1] * (screw_hole_pattern_side / 2), 1]);

// Notch in back wall (12mm wide, 2.52mm thick, 8.01mm high to extend 0.01mm beyond top)
notch = cube([notch_width, wall_thickness + 0.02, notch_height], center = false)
  translate([-notch_width / 2, -45 - 0.01, 32]);

// Assemble housing: top plate with holes, walls, then notch
housing = 
  (top_plate difference screw_holes)
  union 
  (for (i = [0:3]) walls[i])
  difference 
  notch;

housing;