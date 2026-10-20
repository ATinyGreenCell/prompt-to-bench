// NEMA 17 stepper motor mounting bracket
// Print orientation: base plate on bed, builds upward

// Dimensions
base_width = 50;     // X dimension of base plate
base_depth = 45;     // Y dimension of base plate
base_height = 5;     // Z dimension of base plate
motor_plate_width = 50; // X dimension of motor plate
motor_plate_depth = 5; // Y dimension of motor plate
motor_plate_height = 50; // Z dimension of motor plate
mounting_hole_diameter = 4.5; // M4 holes
mounting_hole_x_offset = 17;
mounting_hole_y = 30;
boss_hole_diameter = 23; // For motor centring boss
boss_hole_x = 0;
boss_hole_z = 28;
screw_hole_diameter = 3.4; // M3 screws
screw_pattern_size = 31; // Square pattern for screws
gusset_thickness = 5;
gusset_leg_length = 20;

// Base plate
base = cube([base_width, base_depth, base_height], center = false);

// Mounting holes
mounting_holes = [
  [-mounting_hole_x_offset, mounting_hole_y],
  [mounting_hole_x_offset, mounting_hole_y]
];

for (pos = mounting_holes) {
  translate([pos[0], pos[1], -0.01]) 
    cylinder(h = base_height + 0.02, d = mounting_hole_diameter, $fn = 64);
}

// Motor plate
motor_plate = cube([motor_plate_width, motor_plate_depth, motor_plate_height], center = false);

// Boss hole cutout (extend beyond the plate)
translate([boss_hole_x, -0.01, boss_hole_z - boss_hole_diameter/2]) 
  cylinder(h = motor_plate_height + 0.02, d = boss_hole_diameter, $fn = 64);

// Screw holes for motor mounting
screw_positions = [
  [-screw_pattern_size/2, -screw_pattern_size/2],
  [screw_pattern_size/2, -screw_pattern_size/2],
  [-screw_pattern_size/2, screw_pattern_size/2],
  [screw_pattern_size/2, screw_pattern_size/2]
];

for (pos = screw_positions) {
  translate([pos[0], 0, pos[1] + boss_hole_z]) 
    cylinder(h = motor_plate_height, d = screw_hole_diameter, $fn = 64);
}

// Gussets
// Left gusset
left_gusset = translate([-25, 5, 5]) 
  rotate([0, 0, 90]) 
  polygon(points = [[0, 0], [gusset_leg_length, 0], [0, gusset_leg_length]]);

// Right gusset
right_gusset = translate([25, 5, 5]) 
  rotate([0, 0, -90]) 
  polygon(points = [[0, 0], [gusset_leg_length, 0], [0, gusset_leg_length]]);

// Combine all parts
union() {
  base;
  translate([0, base_depth, 0]) motor_plate;
  left_gusset;
  right_gusset;
}