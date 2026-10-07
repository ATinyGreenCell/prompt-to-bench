// Dimensions
base_width = 50; // x from -25 to 25
base_height = 45; // y from 0 to 45
base_thickness = 5; // z from 0 to 5

motor_plate_width = 50; // x from -25 to 25
motor_plate_height = 5; // y from 0 to 5
motor_plate_thickness = 50; // z from 0 to 50

hole_diameter_m4 = 4.5;
hole_diameter_m3 = 3.4;

boss_radius = 1.25; // Radius of the boss hole for centring the motor
boss_height = 56; // Height of the boss (including thickness of motor plate)

gusset_thickness = 5;
gusset_leg_y = 20;
gusset_leg_z = 20;

// Base Plate
base_plate = cube([base_width, base_height, base_thickness]);
through_holes_base = translate([-17, 30, 0]) * cylinder(h=base_thickness+1, r=hole_diameter_m4/2) +
                     translate([17, 30, 0]) * cylinder(h=base_thickness+1, r=hole_diameter_m4/2);

// Motor Plate
motor_plate = cube([motor_plate_width, motor_plate_height, motor_plate_thickness]);
boss_hole_motor = translate([0, boss_radius, boss_height-motor_plate_thickness]) *
                  cylinder(h=motor_plate_thickness+1, r=boss_radius);
screw_holes_motor = for (i=[-15:30:15], j=[-15:30:15])
                     if (abs(i) <= 17 && abs(j) <= 17)
                       translate([i, j, motor_plate_thickness+1]) *
                       cylinder(h=1, r=hole_diameter_m3/2);

// Gussets
gusset_left = translate([-25, 5, 0]) * rotate_extrude() *
              polygon(points=[[-20, 5], [-20, 25], [5, 25]]);
gusset_right = translate([20, 5, 0]) * rotate_extrude() *
               polygon(points=[[20, 5], [20, 25], [45, 25]]);

// Final Model
final_model = base_plate - through_holes_base +
              motor_plate - boss_hole_motor - screw_holes_motor +
              gusset_left + gusset_right;

// Render the model
difference() {
  final_model;
}