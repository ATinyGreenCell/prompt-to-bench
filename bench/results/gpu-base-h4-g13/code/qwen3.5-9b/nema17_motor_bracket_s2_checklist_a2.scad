// L-shaped mounting bracket for NEMA 17 stepper motor.
// Base plate: 50x45x5, Motor plate: 50x5x50, Gussets on sides.

$fn = 64;

// --- Dimensions ---
base_x = 50;
base_y = 45;
base_z = 5;

motor_x = 50;
motor_y = 5;
motor_z = 50;

m4_hole_d = 4.5;
m3_hole_d = 3.4;

gusset_thickness = 5;
gusset_leg_y = 20;
gusset_leg_z = 20;

boss_hole_d = 23;
boss_hole_z = 28;

// Gusset positions (flush with edges)
gusset_x_left = -25;
gusset_x_right = 20;

// Base mounting holes
base_hole_x1 = -17;
base_hole_y1 = 30;
base_hole_x2 = 17;
base_hole_y2 = 30;

// Motor plate boss hole
boss_hole_x = 0;

// Screw holes pattern
screw_pattern_size = 31;
screw_holes = [
    [-screw_pattern_size / 2, -screw_pattern_size / 2],
    [-screw_pattern_size / 2, screw_pattern_size / 2],
    [screw_pattern_size / 2, -screw_pattern_size / 2],
    [screw_pattern_size / 2, screw_pattern_size / 2]
];

// --- Build Base Plate ---
difference() {
    translate([-base_x / 2, 0, 0]) cube([base_x, base_y, base_z]);
    
    // Base mounting holes
    for (i = [0 : 1]) {
        translate([
            (i == 0) ? base_hole_x1 : base_hole_x2,
            (i == 0) ? base_hole_y1 : base_hole_y2,
            0
        ]) cylinder(h = base_z + 1, d = m4_hole_d);
    }
}

// --- Build Motor Plate ---
difference() {
    translate([-motor_x / 2, 0, base_z]) cube([motor_x, motor_y, motor_z]);
    
    // Boss hole
    translate([boss_hole_x, 0, boss_hole_z]) cylinder(h = motor_z + 1, d = boss_hole_d);
    
    // Screw holes
    for (p = screw_holes) {
        translate([p[0], 0, p[1]]) cylinder(h = motor_z + 1, d = m3_hole_d);
    }
}

// --- Build Left Gusset ---
// Right triangle in YZ plane, extruded along X.
// Vertices: (y=5, z=5), (y=25, z=5), (y=5, z=25).
// Extrude from x = -25 to x = -20.
translate([gusset_x_left, 0, 0]) {
    linear_extrude(height = gusset_thickness, center = false) {
        polygon([
            [5, 5],
            [25, 5],
            [5, 25]
        ]);
    }
}

// --- Build Right Gusset ---
// Right triangle in YZ plane, extruded along X.
// Vertices: (y=5, z=5), (y=25, z=5), (y=5, z=25).
// Extrude from x = 20 to x = 25.
translate([gusset_x_right, 0, 0]) {
    linear_extrude(height = gusset_thickness, center = false) {
        polygon([
            [5, 5],
            [25, 5],
            [5, 25]
        ]);
    }
}