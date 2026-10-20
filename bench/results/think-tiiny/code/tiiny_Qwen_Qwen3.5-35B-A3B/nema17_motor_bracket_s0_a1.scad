// Dimensions
base_width = 50; // x from -25 to 25
base_depth = 45; // y from 0 to 45
base_height = 5; // z from 0 to 5

base_hole_diameter = 4.5; // M4 holes
base_hole_radius = base_hole_diameter / 2;
base_hole_x1 = -17;
base_hole_x2 = 17;
base_hole_y = 30;

motor_hole_diameter = 23; // Centring boss
motor_hole_radius = motor_hole_diameter / 2;
motor_hole_x = 0;
motor_hole_z = 28;

screw_hole_diameter = 3.4; // M3 screws
screw_hole_radius = screw_hole_diameter / 2;
screw_pattern_size = 31; // 31 mm square pattern
screw_pattern_half = screw_pattern_size / 2;

gusset_thickness = 5; // 5 mm thick
gusset_leg_length = 20; // 20 mm legs
gusset_corner_y = 5; // Right-angle corner at y = 5
gusset_corner_z = 5; // Right-angle corner at z = 5
gusset_left_x_start = -25;
gusset_left_x_end = -20;
gusset_right_x_start = 20;
gusset_right_x_end = 25;

// Resolution
$fn = 64;

// Base Plate
base_plate = cube([base_width, base_depth, base_height], center = false);

// Vertical Motor Plate
vertical_plate = cube([base_width, 5, 50], center = false);

// Union of Base and Vertical Plate
bracket = union(
    base_plate,
    vertical_plate
);

// Holes in Base Plate (2 M4 holes)
base_holes = for (i = [0, 1])
    translate([i == 0 ? base_hole_x1 : base_hole_x2, base_hole_y, 0])
        cylinder(h = base_height + 1, r = base_hole_radius, center = false);

// Holes in Vertical Motor Plate
// 1. Motor centring boss hole (along Y axis)
motor_hole = translate([motor_hole_x, 0, motor_hole_z])
    cylinder(h = 5 + 1, r = motor_hole_radius, center = false, $fn = 64);

// 2. Four M3 screw holes (along Y axis)
screw_holes = for (i = [0, 1])
    for (j = [0, 1])
        translate([
            i == 0 ? -screw_pattern_half : screw_pattern_half,
            0,
            j == 0 ? motor_hole_z - screw_pattern_half : motor_hole_z + screw_pattern_half
        ])
            cylinder(h = 5 + 1, r = screw_hole_radius, center = false, $fn = 64);

// Gussets - Right triangles in YZ plane
// Left Gusset: x = -25 to -20, right triangle with legs 20mm along Y and Z
left_gusset = translate([base_hole_x1, 0, 0])
    rotate([0, 0, 0])
    linear_extrude(height = 5)
    polygon([[0, 0], [0, 20], [20, 0]]);

// Right Gusset: x = 20 to 25
right_gusset = translate([base_hole_x2, 0, 0])
    rotate([0, 0, 0])
    linear_extrude(height = 5)
    polygon([[0, 0], [0, 20], [20, 0]]);

// Final Assembly
final_part = union(
    bracket,
    base_holes,
    motor_hole,
    screw_holes,
    left_gusset,
    right_gusset
);

// Difference to cut holes
result = difference(
    final_part,
    union(
        base_holes,
        motor_hole,
        screw_holes
    )
);

// Display
render() result;