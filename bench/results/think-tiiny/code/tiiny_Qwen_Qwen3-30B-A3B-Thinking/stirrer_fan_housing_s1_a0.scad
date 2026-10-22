$fn = 64;

// Dimensions in mm
top_plate_thickness = 2;
wall_thickness = 2.5;
wall_height = 38; // from z=2 to z=40
housing_outer = 90;
hole_diameter = 4.5;
hole_radius = hole_diameter / 2;
hole_extension = 0.1;
hole_pattern_side = 71.5;
hole_pattern_radius = hole_pattern_side / 2;
notch_width = 12;
notch_height = 8;
notch_depth = wall_thickness;

// Top plate (2mm thick, centered on origin)
top_plate = translate([-housing_outer/2, -housing_outer/2, 0])
              cube([housing_outer, housing_outer, top_plate_thickness]);

// Front wall (Y = 45 - 2.5 to 45, X = -45 to 45, Z = 2 to 40)
front_wall = translate([-housing_outer/2, housing_outer/2 - wall_thickness, top_plate_thickness])
             cube([housing_outer, wall_thickness, wall_height]);

// Back wall (Y = -45 to -45 + 2.5, X = -45 to 45, Z = 2 to 40)
back_wall = translate([-housing_outer/2, -housing_outer/2, top_plate_thickness])
            cube([housing_outer, wall_thickness, wall_height]);

// Left wall (X = -45 to -45 + 2.5, Y = -45 to 45, Z = 2 to 40)
left_wall = translate([-housing_outer/2, -housing_outer/2, top_plate_thickness])
             cube([wall_thickness, housing_outer, wall_height]);

// Right wall (X = 45 - 2.5 to 45, Y = -45 to 45, Z = 2 to 40)
right_wall = translate([housing_outer/2 - wall_thickness, -housing_outer/2, top_plate_thickness])
            cube([wall_thickness, housing_outer, wall_height]);

// Four mounting holes (drilled through top plate)
hole1 = translate([hole_pattern_radius, hole_pattern_radius, -hole_extension])
         cylinder(r=hole_radius, h=top_plate_thickness + 2*hole_extension, center=false);
hole2 = translate([hole_pattern_radius, -hole_pattern_radius, -hole_extension])
         cylinder(r=hole_radius, h=top_plate_thickness + 2*hole_extension, center=false);
hole3 = translate([-hole_pattern_radius, hole_pattern_radius, -hole_extension])
         cylinder(r=hole_radius, h=top_plate_thickness + 2*hole_extension, center=false);
hole4 = translate([-hole_pattern_radius, -hole_pattern_radius, -hole_extension])
         cylinder(r=hole_radius, h=top_plate_thickness + 2*hole_extension, center=false);

// Notch in front wall (12mm wide, centered, 8mm high from top edge)
notch = translate([-notch_width/2, housing_outer/2 - wall_thickness, housing_outer/2 - notch_height])
         cube([notch_width, wall_thickness, notch_height]);

// Assemble housing and subtract features
housing = difference(
  union(
    top_plate,
    front_wall,
    back_wall,
    left_wall,
    right_wall
  ),
  hole1, hole2, hole3, hole4,
  notch
);

housing;