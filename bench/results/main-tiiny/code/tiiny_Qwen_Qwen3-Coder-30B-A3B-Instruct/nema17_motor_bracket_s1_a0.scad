// NEMA 17 stepper motor mounting bracket
// Print orientation: base plate on bed, builds upward

// Dimensions
base_x = 50;       // Base plate width (from -25 to 25)
base_y = 45;       // Base plate depth (from 0 to 45)
base_z = 5;        // Base plate height
motor_plate_x = 50; // Motor plate width (from -25 to 25)
motor_plate_y = 5; // Motor plate depth (from 0 to 5)
motor_plate_z = 50; // Motor plate height
boss_hole_d = 23; // Boss hole diameter
boss_hole_x = 0;  // Boss hole center x
boss_hole_z = 28; // Boss hole center z
screw_hole_d = 3.4; // M3 screw hole diameter
screw_pattern = 31; // Screw pattern square size
screw_hole_offset = 15.5; // Offset from center for screw holes
gusset_thickness = 5; // Gusset thickness
gusset_leg = 20; // Gusset triangle leg length

// Base plate
base_plate = union() {
    // Main base
    cube([base_x, base_y, base_z], center = true);
    
    // Through-holes (M4)
    for (i = [-17, 17]) {
        translate([i, 30, 0])
        cylinder(h = base_z + 0.02, d = 4.5, center = true, $fn = 64);
    }
};

// Motor plate
motor_plate = union() {
    // Main motor plate
    translate([0, 0, base_z])
    cube([motor_plate_x, motor_plate_y, motor_plate_z], center = true);
    
    // Boss hole
    translate([boss_hole_x, 0, boss_hole_z])
    cylinder(h = motor_plate_y + 0.02, d = boss_hole_d, center = true, $fn = 64);
    
    // M3 screw holes
    for (i = [-1, 1]) {
        for (j = [-1, 1]) {
            translate([i * screw_hole_offset, 0, j * screw_hole_offset + base_z])
            cylinder(h = motor_plate_y + 0.02, d = screw_hole_d, center = true, $fn = 64);
        }
    }
};

// Gussets
gusset_left = union() {
    translate([-25, 5, 5])
    rotate([0, 0, 90])
    polygon(points = [[0, 0], [gusset_leg, 0], [0, gusset_leg]]);
};

gusset_right = union() {
    translate([25, 5, 5])
    rotate([0, 0, -90])
    polygon(points = [[0, 0], [gusset_leg, 0], [0, gusset_leg]]);
};

// Final assembly
assembly = union() {
    base_plate;
    motor_plate;
    gusset_left;
    gusset_right;
};

assembly;