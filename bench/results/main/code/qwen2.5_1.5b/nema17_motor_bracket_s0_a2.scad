// Define dimensions from user input
$fn = 64; // for round holes

// Base plate dimensions
base_plate_x_min = -25;
base_plate_y_min = 0;
base_plate_z_min = 0;
base_plate_x_max = 25;
base_plate_y_max = 45;
base_plate_z_max = 5;

// Motor plate dimensions
motor_plate_x_min = -25;
motor_plate_y_min = 0;
motor_plate_z_min = 0;
motor_plate_x_max = 25;
motor_plate_y_max = 5;
motor_plate_z_max = 50;

// Motor boss hole
motor_boss_x = -17;
motor_boss_y = 30;
motor_boss_z = 28;

// M3 screw holes pattern
m3_screw_pattern_x_min = -25;
m3_screw_pattern_x_max = 25;
m3_screw_pattern_y_min = 0;
m3_screw_pattern_y_max = 5;
m3_screw_pattern_z_min = 0;
m3_screw_pattern_z_max = 1.7;

// Triangular gusset dimensions
gusset_legs_x_min = -25;
gusset_legs_x_max = -20;
gusset_legs_y_min = 5;
gusset_legs_y_max = 20;
gusset_legs_z_min = 5;
gusset_legs_z_max = 20;

// Create base plate
base_plate = [
    translate([base_plate_x_min, base_plate_y_min, base_plate_z_min])[
        cube([base_plate_x_max - base_plate_x_min + 1, base_plate_y_max - base_plate_y_min + 1, base_plate_z_max - base_plate_z_min + 1])
    ],
    translate([0, 25, 0])[
        rotate_extrude(90) [
            cube([base_plate_x_max - base_plate_x_min + 1, base_plate_y_max - base_plate_y_min + 1, 4.5])
        ]
    ],
    translate([0, 30, 28])[
        rotate_extrude(90) [
            cube([motor_boss_x - motor_boss_x + 1, motor_boss_y - motor_boss_y + 1, 4.5])
        ]
    ],
    translate([0, 30, 28])[
        rotate_extrude(-90) [
            cube([motor_boss_x - motor_boss_x + 1, motor_boss_y - motor_boss_y + 1, 4.5])
        ]
    ],
    translate([0, 30, 28])[
        rotate_extrude(180) [
            cube([motor_boss_x - motor_boss_x + 1, motor_boss_y - motor_boss_y + 1, 4.5])
        ]
    ],
    translate([0, 30, 28])[
        rotate_extrude(-180) [
            cube([motor_boss_x - motor_boss_x + 1, motor_boss_y - motor_boss_y + 1, 4.5])
        ]
    ],
    translate([0, 30, 28])[
        rotate_extrude(90) [
            cube([m3_screw_pattern_x_max - m3_screw_pattern_x_min + 1, m3_screw_pattern_y_max - m3_screw_pattern_y_min + 1, 4.5])
        ]
    ],
    translate([0, 30, 28])[
        rotate_extrude(-90) [
            cube([m3_screw_pattern_x_max - m3_screw_pattern_x_min + 1, m3_screw_pattern_y_max - m3_screw_pattern_y_min + 1, 4.5])
        ]
    ],
    translate([0, 30, 28])[
        rotate_extrude(180) [
            cube([m3_screw_pattern_x_max - m3_screw_pattern_x_min + 1, m3_screw_pattern_y_max - m3_screw_pattern_y_min + 1, 4.5])
        ]
    ],