// Dimensions and parameters
base_plate_x_width = 50;  // x from -25 to 25, total width 50 mm
base_plate_y_height = 45; // y from 0 to 45, total height 45 mm
base_plate_z_height = 5;  // z from 0 to 5, total height 5 mm

motor_plate_x_width = 50; // x from -25 to 25, total width 50 mm
motor_plate_y_height = 50; // z from 0 to 50, total height 50 mm
motor_plate_z_height = 50; // y from 0 to 5, total height 5 mm (wait, this may be a typo, assuming Y and Z are swapped)

boss_hole_diameter = 23; // diameter of the motor's centring boss hole
boss_hole_x = 0;          // x-coordinate of the boss hole center
boss_hole_y = 28;         // y-coordinate of the boss hole center (assuming Y is vertical)
boss_hole_z = 0;          // z-coordinate of the boss hole center (assuming Z is vertical)

screw_hole_diameter = 3.4; // diameter of M3 screw holes
screw_pattern_side = 31;    // side length of square pattern for screw holes
screw_pattern_offset = 15.5; // offset from center to align with boss hole

gusset_thickness = 5;      // thickness of the triangular gussets
gusset_leg_y = 20;         // length along +Y direction
gusset_leg_z = 20;         // length along +Z direction
gusset_right_angle_y = 5;  // y-coordinate of the right-angle corner
gusset_right_angle_z = 5;  // z-coordinate of the right-angle corner

// Define the base plate
base_plate = cube([base_plate_x_width, base_plate_y_height, base_plate_z_height]);

// Define the motor plate
motor_plate = cube([motor_plate_x_width, motor_plate_y_height, motor_plate_z_height]);

// Position the motor plate on top of the base plate
motor_plate_position = translate([0, 0, base_plate_z_height]);

// Create the boss hole in the motor plate
boss_hole = cylinder(r = boss_hole_diameter / 2, h = motor_plate_y_height, $fn = 64);

// Position the boss hole in the motor plate
boss_hole_position = translate([boss_hole_x, boss_hole_y, boss_hole_z]);

// Create the screw holes in the motor plate
screw_holes = [
  [screw_pattern_offset, 0, 0],  // top-left
  [screw_pattern_offset, motor_plate_y_height, 0],  // top-right
  [-screw_pattern_offset, 0, 0],  // bottom-left
  [-screw_pattern_offset, motor_plate_y_height, 0]   // bottom-right
];

screw_holes = [
  translate([x, y, 0]) * cylinder(r = screw_hole_diameter / 2, h = motor_plate_y_height, $fn = 64)
  for [x, y] in screw_holes
];

// Combine motor plate with boss and screw holes
motor_plate_with_holes = difference() {
  motor_plate_position;
  boss_hole_position;
  screw_holes;
};

// Create the left gusset
left_gusset = translate([0, gusset_right_angle_y, gusset_right_angle_z]) *
  rotate([90, 0, 0]) *
  linear_extrude(height = gusset_thickness) *
  polygon(points=[[0,0], [0, gusset_leg_y], [gusset_leg_z, gusset_leg_y]], 
          paths=[[0,1,2]]);

// Create the right gusset
right_gusset = translate([motor_plate_x_width, gusset_right_angle_y, gusset_right_angle_z]) *
  rotate([90, 0, 0]) *
  linear_extrude(height = gusset_thickness) *
  polygon(points=[[0,0], [0, gusset_leg_y], [gusset_leg_z, gusset_leg_y]], 
          paths=[[0,1,2]]);

// Create the vertical through-holes in the base plate
vertical_holes = [
  translate([-17, 30, 0]) * cylinder(r = 4.5 / 2, h = base_plate_z_height, $fn = 64),
  translate([17, 30, 0]) * cylinder(r = 4.5 / 2, h = base_plate_z_height, $fn = 64)
];

// Combine base plate with vertical holes
base_plate_with_holes = difference() {
  base_plate;
  vertical_holes;
};

// Combine all parts
final_bracket = union() {
  base_plate_with_holes,
  motor_plate_with_holes,
  left_gusset,
  right_gusset
};

// Final render
final_bracket;