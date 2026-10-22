// Dimensions
base_length = 50; // x from -25 to 25
base_height = 45; // y from 0 to 45
base_thickness = 5; // z from 0 to 5
motor_plate_length = 50; // x from -25 to 25
motor_plate_height = 5; // y from 0 to 5
motor_plate_thickness = 50; // z from 0 to 50
motor_boss_diameter = 4.5; // M4 hole
motor_boss_position = [0, 28, 28]; // Centered at x = 0, z = 28
screw_diameter = 3.4; // M3 screw
screw_spacing = 31; // 31 mm square pattern
gusset_thickness = 5; // 5 mm thick
gusset_length = 20; // Legs 20 mm along +Y and +Z
gusset_height = 20;
gusset_position = [[-25, 5, 5], [20, 5, 5]]; // Flush with the left and right edges

// Base plate
base_plate = cube([base_length, base_height, base_thickness]);

// Motor plate
motor_plate = cube([motor_plate_length, motor_plate_height, motor_plate_thickness]);
motor_boss_hole = cylinder(r = motor_boss_diameter / 2, h = motor_plate_thickness + 0.01);
motor_screw_holes = for (i = [0:3]) translate([i * screw_spacing - screw_spacing / 2, 0, 0]) cylinder(r = screw_diameter / 2, h = motor_plate_thickness + 0.01);
motor_plate = difference() {
    motor_plate;
    motor_boss_hole;
    motor_screw_holes;
}

// Gussets
gusset = polyhedron(points = [[-gusset_length, 0, 0], [0, 0, 0], [0, gusset_height, 0], [-gusset_length, gusset_height, 0]],
                    triangles = [[0, 1, 2], [0, 2, 3]]);
gusset1 = translate(gusset_position[0]) gusset;
gusset2 = translate(gusset_position[1]) mirror([1, 0, 0]) gusset;

// Final model
final_model = union() {
    base_plate;
    translate([0, 0, base_thickness]) motor_plate;
    gusset1;
    gusset2;
};

// Render the model
final_model;