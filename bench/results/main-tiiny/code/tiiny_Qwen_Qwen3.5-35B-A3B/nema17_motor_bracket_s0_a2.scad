// Dimensions for NEMA 17 L-shaped mounting bracket
// Base plate dimensions
base_width = 50;       // X: -25 to 25
base_depth = 45;      // Y: 0 to 45
base_height = 5;       // Z: 0 to 5

// Mounting holes for base (M4)
base_hole_dia = 4.5;
base_hole_x = 17;      // Center X positions: -17 and 17
base_hole_y = 30;      // Center Y position

// Vertical motor plate dimensions
motor_plate_width = 50; // X: -25 to 25
motor_plate_height = 50; // Z: 0 to 50
motor_plate_thickness = 5; // Y: 0 to 5

// Motor boss hole
motor_boss_dia = 23;
motor_boss_x = 0;
motor_boss_z = 28;

// M3 screw holes for motor plate
m3_hole_dia = 3.4;
m3_pattern_size = 31; // Square pattern size
m3_hole_offset = m3_pattern_size / 2;

// Gusset dimensions
gusset_thickness = 5;
gusset_leg_y = 20;
gusset_leg_z = 20;
gusset_corner_y = 5;
gusset_corner_z = 5;

// Main union of all solid parts
main_part = union(
  // Base plate
  translate([0, base_depth / 2, base_height / 2])
    cube([base_width, base_depth, base_height], center = true),
  
  // Vertical motor plate
  translate([0, motor_plate_thickness / 2, motor_plate_height / 2])
    cube([motor_plate_width, motor_plate_thickness, motor_plate_height], center = true),
  
  // Left gusset (X: -25 to -20)
  translate([-22.5, gusset_corner_y + gusset_leg_y / 2, gusset_corner_z + gusset_leg_z / 2])
    linear_extrude(height = gusset_thickness)
      polygon([
        [-5, 0],
        [0, gusset_leg_y],
        [0, 0]
      ]),
  
  // Right gusset (X: 20 to 25)
  translate([22.5, gusset_corner_y + gusset_leg_y / 2, gusset_corner_z + gusset_leg_z / 2])
    linear_extrude(height = gusset_thickness)
      polygon([
        [0, 0],
        [5, gusset_leg_y],
        [5, 0]
      ])
);

// Subtract holes from base plate
difference() {
  main_part;
  
  // Base M4 holes
  for (x_pos = [-base_hole_x, base_hole_x]) {
    translate([x_pos, base_hole_y, base_height / 2])
      cylinder(d = base_hole_dia, h = base_height + 1, center = true);
  }
}

// Subtract holes from motor plate
difference() {
  main_part;
  
  // Motor boss hole
  translate([motor_boss_x, motor_plate_thickness / 2, motor_boss_z])
    cylinder(d = motor_boss_dia, h = motor_plate_thickness + 1, center = true);
  
  // M3 screw holes
  for (x_off = [-m3_hole_offset, m3_hole_offset]) {
    for (z_off = [-m3_hole_offset, m3_hole_offset]) {
      translate([motor_boss_x + x_off, motor_plate_thickness / 2, motor_boss_z + z_off])
        cylinder(d = m3_hole_dia, h = motor_plate_thickness + 1, center = true);
    }
  }
}