// Dimensions for L-shaped mounting bracket
$fn = 128;

// Base plate dimensions
base_width = 45;
base_height = 5;
hole_x_pos1 = -17;
hole_y_pos1 = 30;
hole_diameter = 4.5;
motor_plate_height = 50;
motor_plate_thickness = base_height + 0.2; // Extra thickness for clearance

// Motor plate boss and screw holes
boss_hole_diameter = 23;
boss_center_z = 28;
screw_spacing = 31;
screw_offset_x = (screw_spacing - boss_hole_diameter) / 2 + 0.5; // Centered offset
motor_screw_diameter = 3.4;

// Gusset dimensions
gusset_length = 20;
gusset_height = 20;
gusset_thickness = 5;

// Create base plate with holes
base_plate = difference(
    cube([base_width, base_height + 1, base_height]),
    [
        translate([hole_x_pos1, hole_y_pos1, 0]) cylinder(h=base_height+1, $fn=$fn, diameter=hole_diameter),
        translate([-hole_x_pos1, hole_y_pos1, 0]) cylinder(h=base_height+1, $fn=$fn, diameter=hole_diameter)
    ]
);

// Motor plate with boss and screws
motor_plate = difference(
    cube([base_width + motor_plate_thickness, base_height, motor_plate_height]),
    [
        translate([0, 0, boss_center_z]) cylinder(h=25, $fn=$fn, diameter=boss_hole_diameter),
        for (i in [1, -1])
            translate([screw_offset_x * i, screw_spacing/2 + motor_screw_diameter/2, boss_center_z])
                cylinder(h=25, $fn=$fn, diameter=motor_screw_diameter)
    ]
);

// Position motor plate on base
motor_plate_positioned = rotate(
    [0, 90, 0], // Rotate to stand vertically behind the base
    translate([-base_width/2 + (motor_plate_thickness - 1)/2, -base_height/2, 0]) motor_plate
);

// Combine base and motor plates
bracket = union(
    base_plate,
    difference(
        cube([base_width + motor_plate_thickness, base_height + motor_plate_thickness, base_height]),
        translate([-motor_plate_thickness/2, -base_height/2, 0]) rotate([0, 90, 0], motor_plate_positioned)
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

// Final bracket assembly
final_bracket = union(
    base_plate,
    translate([-base_width/2 + motor_plate_thickness/2, -base_height/2, 0])
        rotate([0, 90, 0], motor_plate_positioned),
    difference(
        hull([
            [0, 0, 0],
            [base_width, 0, 0],
            [base_width, base_height + gusset_thickness, 0],
            [-25 - gusset_length/2, base_height + gusset_thickness, 0],
            [-25 - gusset_length/2, base_height + gusset_thickness, motor_plate_thickness]
        ]),
        [
            translate([-25 - gusset_length/2, 5 + gusset_thickness, 0]) hull([
                [gusset_length, 0],
                [0, gusset_height]
            ])
        ]
    )
);