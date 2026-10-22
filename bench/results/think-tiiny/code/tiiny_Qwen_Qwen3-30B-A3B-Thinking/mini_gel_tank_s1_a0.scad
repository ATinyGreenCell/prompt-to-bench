$fn = 64;

// Dimensions in millimeters
outer_x = 120;   // Outer X dimension (length)
outer_y = 70;     // Outer Y dimension (width)
outer_z = 40;     // Outer Z dimension (height)
wall_thickness = 3; // Wall and floor thickness
floor_thickness = 3; // Floor thickness (z=0 to z=floor_thickness)
platform_length = 60; // Platform length in X (centred)
platform_width = outer_y - 2 * wall_thickness; // Full inner Y (64 mm)
platform_height = 10; // Platform top at z = 13 (10 mm above inner floor at z=3)
hole_diameter = 2;  // Hole diameter (2 mm)
hole_radius = hole_diameter / 2;
hole_length = wall_thickness + 0.01; // Extend 0.01 mm beyond wall for non-coplanar faces

// Calculate hole centers (X) for both ends (y=0, z=30)
hole_center_x_right = ( (outer_x/2 - wall_thickness) - 0.01 + outer_x/2 ) / 2;
hole_center_x_left = ( -outer_x/2 + ( - (outer_x/2 - wall_thickness) + 0.01 ) ) / 2;

// Tank structure: floor + side walls (centered at origin)
tank_floor = cube([outer_x, outer_y, floor_thickness], center=true);
tank_right_wall = cube([wall_thickness, outer_y, outer_z - floor_thickness], center=true);
translate([outer_x/2 - wall_thickness/2, 0, (outer_z - floor_thickness)/2 + floor_thickness])
  rotate([0, 0, 90])
  tank_right_wall;
tank_left_wall = cube([wall_thickness, outer_y, outer_z - floor_thickness], center=true);
translate([-outer_x/2 + wall_thickness/2, 0, (outer_z - floor_thickness)/2 + floor_thickness])
  rotate([0, 0, 90])
  tank_left_wall;
tank_front_wall = cube([outer_x, wall_thickness, outer_z - floor_thickness], center=true);
translate([0, outer_y/2 - wall_thickness/2, (outer_z - floor_thickness)/2 + floor_thickness])
  rotate([0, 90, 0])
  tank_front_wall;
tank_back_wall = cube([outer_x, wall_thickness, outer_z - floor_thickness], center=true);
translate([0, -outer_y/2 + wall_thickness/2, (outer_z - floor_thickness)/2 + floor_thickness])
  rotate([0, 90, 0])
  tank_back_wall;

// Platform (solid, raised, centred)
platform = cube([platform_length, platform_width, platform_height], center=true);
translate([0, 0, floor_thickness + platform_height/2])
  platform;

// Holes (drilled through end walls)
hole_right = 
  translate([hole_center_x_right, 0, 30])
  rotate([90, 0, 0])
  cylinder(r=hole_radius, h=hole_length, center=true);
hole_left = 
  translate([hole_center_x_left, 0, 30])
  rotate([90, 0, 0])
  cylinder(r=hole_radius, h=hole_length, center=true);

// Assemble the tank with platform and holes
union() {
  // Tank structure (floor + walls)
  union() {
    tank_floor;
    tank_right_wall;
    tank_left_wall;
    tank_front_wall;
    tank_back_wall;
  }
  // Platform
  platform;
}

// Subtract the holes from the tank
difference() {
  union() {
    // Tank structure (floor + walls)
    union() {
      tank_floor;
      tank_right_wall;
      tank_left_wall;
      tank_front_wall;
      tank_back_wall;
    }
    // Platform
    platform;
  }
  // Holes
  hole_right;
  hole_left;
}