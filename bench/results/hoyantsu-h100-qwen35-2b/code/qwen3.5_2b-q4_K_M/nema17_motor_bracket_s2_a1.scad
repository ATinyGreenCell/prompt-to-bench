// Design an L-shaped mounting bracket for a NEMA 17 stepper motor

// Dimensions in millimetres (measured with calipers)
base_width = 50;      // x: -25 to 25
base_depth   = 45;     // y: 0 to 45
base_height  = 5;     // z: 0 to 5

motor_plate_width = 50; // x: -25 to 25
motor_plate_depth  = 50; // y: 0 to 50 (standing on back edge)
motor_height     = 45;  // z: 0 to 50 (from base top)

// Hole specifications for motor plate
hole_m3_radius   = 1.7; // 3.4 mm diameter / 2
m3_hole_spacing  = 31;    // 31 mm square pattern
m3_hole_center_x = 0;     // centred on boss hole

// Gusset specifications
gusset_thickness = 5;    // thickness in Z direction (flush with plates)
gusset_leg_y     = 20;   // along +Y
gusset_leg_z     = 20;   // along +Z
gusset_corner_y = 5;    // where plates meet (y=5, z=5)

// Create the L-shaped base plate
base_plate = cube([base_width, base_depth, base_height]);

// Create the vertical motor plate
motor_plate = linear_extrude([0, 0, motor_height]) translate([0, -base_depth/2, 0]); // Center on back edge of base

// Cut through-motor-holes (M4) in base plate
// Position: x=-17, y=30; x=17, y=30
hole_m4_a = translate([-17, 30]) cylinder(r=2.25); // M4 diameter
hole_m4_b = translate([17, 30]) cylinder(r=2.25);

base_plate = difference([hole_m4_a, hole_m4_b]);

// Cut through-motor-holes (M3) in motor plate
// Pattern: 31mm square centered on boss hole at x=0, z=28
m3_hole_pos_x = m3_hole_center_x;
m3_hole_pos_z = m3_hole_corner_y + gusset_leg_y; // Boss is at y=5, Gusset starts at y=5

for (i = 0; i < 4; i++) {
    pos_x = m3_hole_pos_x + i * m3_hole_spacing;
    pos_z = m3_hole_corner_y + gusset_leg_z; // Boss is at z=28, Gusset starts at z=5
    
    hole_m3_a = translate([pos_x, 0, pos_z]) cylinder(r=m3_hole_radius);
    
    motor_plate = difference([hole_m3_a]);
}

// Add triangular gussets on left and right edges
// Left Gusset (x from -25 to -20)
left_gusset = rotate_extrude(90, [gusset_thickness, 0, 0]) translate([-base_width/2 + gusset_leg_y, 0, 0]) polygon([[-17.5, 0, 0], [-17.5, -gusset_leg_y, 0], [gusset_corner_y, -gusset_leg_y, 0]]);
left_gusset = rotate_extrude(-90, [gusset_thickness, 0, 0]) translate([-base_width/2 + gusset_leg_z, 0, 0]) polygon([[-17.5, 0, 0], [-17.5, -gusset_leg_y, 0], [gusset_corner_y, -gusset_leg_y, 0]]);

// Right Gusset (x from 20 to 25)
right_gusset = rotate_extrude(90, [gusset_thickness, 0, 0]) translate([base_width/2 + gusset_leg_y, 0, 0]) polygon([[-17.5, 0, 0], [-17.5, -gusset_leg_y, 0], [gusset_corner_y, -gusset_leg_y, 0]]);
right_gusset = rotate_extrude(-90, [gusset_thickness, 0, 0]) translate([base_width/2 + gusset_leg_z, 0, 0]) polygon([[-17.5, 0, 0], [-17.5, -gusset_leg_y, 0], [gusset_corner_y, -gusset_leg_y, 0]]);

// Final assembly
final_bracket = union([base_plate, motor_plate, left_gusset, right_gusset]);

print("Design complete: L-shaped mounting bracket for NEMA 17 stepper.");