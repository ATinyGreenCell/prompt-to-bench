// Dimensions for L-shaped mounting bracket
$fn = 128;

// Base plate dimensions
base_width = 45;
base_height = 5;
hole_x_pos1 = -17;
hole_y_pos1 = 30;
hole_diameter = 4.5;
motor_plate_height = 50;
motor_plate_thickness = base_height;
boss_hole_diameter = 23;
boss_center_z = 28;

// Motor plate screw holes
screw_spacing = 31; // mm side length of square pattern
screw_offset_x = boss_hole_diameter / 2 + (screw_spacing - boss_hole_diameter) / 2;
motor_screw_diameter = 3.4;

// Gusset dimensions
gusset_length = 20;
gusset_height = 20;
gusset_thickness = 5;

// Create base plate with holes
base_plate = difference(
    cube([base_width, base_height, base_height + 1]),
    [
        translate([hole_x_pos1, hole_y_pos1, 0]) cylinder(h=base_height+1, $fn=$fn, diameter=hole_diameter),
        translate([-hole_x_pos1, hole_y_pos1, 0]) cylinder(h=base_height+1, $fn=$fn, diameter=hole_diameter)
    ]
);

// Motor plate with boss and screws
motor_plate = difference(
    cube([base_width + motor_plate_thickness, base_height, motor_plate_height]),
    [
        translate([0, 0, 25]) cylinder(h=25, $fn=$fn, diameter=boss_hole_diameter),
        for (i in [1, -1])
            translate([screw_offset_x * i, screw_spacing/2 + screw_diameter/2, 25])
                cylinder(h=25, $fn=$fn, diameter=screw_diameter)
    ]
);

// Position motor plate on base
motor_plate_positioned = rotate(
    [0, -90, 0],
    translate([-base_width/2 + motor_plate_thickness/2, -base_height/2, 0]) motor_plate
);

// Combine base and motor plates
bracket = union(
    base_plate,
    difference(
        cube([base_width + motor_plate_thickness, base_height + motor_plate_thickness, base_height]),
        translate([-motor_plate_thickness/2, -base_height/2, 0]) motor_plate_positioned
    )
);

// Add gussets
gusset1 = linear_extrude(height=gusset_thickness) polygon([
    [0, 0],
    [gusset_length, 0],
    [gusset_length, gusset_height]
]);
translate([-25 - gusset_thickness/2, 5 + gusset_thickness/2, 0]) gusset1;

gusset2 = linear_extrude(height=gusset_thickness) polygon([
    [0, 0],
    [-gusset_length, 0],
    [-gusset_length, gusset_height]
]);
translate([25 - gusset_thickness/2, 5 + gusset_thickness/2, 0]) gusset2;

// Final bracket with gussets
final_bracket = union(
    bracket,
    difference(
        cube([base_width + motor_plate_thickness + gusset_length*2, base_height + motor_plate_thickness, base_height]),
        [
            translate([-25 - gusset_thickness/2, 0, 0]) hull([[-gusset_length, 0], [0, 0]]),
            translate([25 - gusset_thickness/2, 0, 0]) hull([[gusset_length, 0], [0, 0]])
        ]
    )
);