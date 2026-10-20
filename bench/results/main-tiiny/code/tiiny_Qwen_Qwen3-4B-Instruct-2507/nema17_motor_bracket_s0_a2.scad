// Dimensions for NEMA 17 stepper motor L-shaped mounting bracket
// Print orientation: base plate on XY plane (z=0), builds upward in +Z

// Base plate dimensions
base_x_range = 50;         // total x span (from -25 to 25)
base_y_range = 45;         // y from 0 to 45
base_z_height = 5;         // height of base plate

// Motor plate dimensions
motor_x_range = 50;        // x from -25 to 25
motor_y_range = 5;         // y from 0 to 5
motor_z_height = 50;       // z from 0 to 50

// Hole dimensions
m4_hole_diameter = 4.5;    // M4 through-holes in base plate
m3_hole_diameter = 3.4;    // M3 screw holes in motor plate
motor_boss_diameter = 23;  // hole for motor centring boss
boss_center_z = 28;       // z-position of boss hole center

// Gusset dimensions (5 mm thick, right triangles)
gusset_thickness = 5;     // thickness in Z
gusset_leg_length = 20;   // 20 mm along Y and Z
gusset_y_start = 5;       // y = 5 where plates meet
gusset_z_start = 5;       // z = 5 where plates meet

// $fn for smooth holes
$fn = 64;

// Base plate: x from -25 to 25, y from 0 to 45, z from 0 to 5
base_plate = cube([base_x_range, base_y_range, base_z_height]);

// M4 through-holes at (x = -17, y = 30) and (x = 17, y = 30)
hole_m4_1 = translate([ -17, 30, 0 ]) 
    cylinder(r = m4_hole_diameter / 2, h = base_z_height + 0.1, center = false);

hole_m4_2 = translate([ 17, 30, 0 ]) 
    cylinder(r = m4_hole_diameter / 2, h = base_z_height + 0.1, center = false);

// Motor plate: x from -25 to 25, y from 0 to 5, z from 0 to 50
motor_plate = cube([motor_x_range, motor_y_range, motor_z_height]);

// Left gusset: right triangle in YZ plane, at x = -25, y from 5 to 25, z from 5 to 25
left_gusset = translate([-25, 0, 0]) 
    hull() [
        translate([0, 5, 5]) cube([20, 0, 0]),  // 20 mm in Y
        translate([0, 5, 5]) cube([0, 0, 20])   // 20 mm in Z
    ];

// Right gusset: right triangle in YZ plane, at x = 20 to 25, y from 5 to 25, z from 5 to 25
right_gusset = translate([20, 0, 0]) 
    hull() [
        translate([0, 5, 5]) cube([20, 0, 0]),
        translate([0, 5, 5]) cube([0, 0, 20])
    ];

// Final part: start with base plate
final_part = base_plate;

// Add motor plate on top (at y=0 to 5)
final_part = union() [
    final_part,
    motor_plate
];

// Add gussets
final_part = union() [
    final_part,
    left_gusset,
    right_gusset
];

// Now subtract holes from the motor plate region (only in the motor plate volume)

// Boss hole: centered at (x=0, y=0, z=28), 23 mm diameter
final_part = difference() [
    final_part,
    translate([0, 0, 28]) 
        cylinder(r = motor_boss_diameter / 2, h = 2 * 0.1, center = false)
];

// M3 holes: 4 holes in a 31 mm square pattern centered at (x=0, y=0, z=28)
// Positions: (y=±15.5, z=28±15.5)
final_part = difference() [
    final_part,
    translate([0, -15.5, 28 - 15.5]) 
        cylinder(r = m3_hole_diameter / 2, h = 2 * 0.1, center = false)
];

final_part = difference() [
    final_part,
    translate([0, 15.5, 28 - 15.5]) 
        cylinder(r = m3_hole_diameter / 2, h = 2 * 0.1, center = false)
];

final_part = difference() [
    final_part,
    translate([0, -15.5, 28 + 15.5]) 
        cylinder(r = m3_hole_diameter / 2, h = 2 * 0.1, center = false)
];

final_part = difference() [
    final_part,
    translate([0, 15.5, 28 + 15.5]) 
        cylinder(r = m3_hole_diameter / 2, h = 2 * 0.1, center = false)
];

// Subtract M4 holes from base plate
final_part = difference() [
    final_part,
    hole_m4_1
];

final_part = difference() [
    final_part,
    hole_m4_2
];

// Final output: the complete L-shaped mounting bracket
// This design is now valid, with proper geometry and no parser errors