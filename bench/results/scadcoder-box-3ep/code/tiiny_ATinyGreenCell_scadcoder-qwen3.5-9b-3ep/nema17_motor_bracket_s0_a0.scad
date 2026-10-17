// L-shaped mounting bracket for a NEMA 17 stepper motor (e.g. a syringe pump).
// Base plate: x -25..25, y 0..45, z 0..5 with two vertical through-holes (M4) at
// (x = -17, y = 30) and (x = 17, y = 30). Vertical motor plate: x -25..25, y 0..5,
// z 0..50, standing on the back edge of the base. Through the motor plate (along Y)
// cut a 23 mm hole for the motor's centring boss (centre x = 0, z = 28) and four
// 3.4 mm holes for M3 screws on a 31 mm square pattern centred on the boss hole.
// Two triangular gussets, 5 mm thick, flush with the left and right edges
// (x = -25 to -20 and x = 20 to 25): each is a right triangle in the YZ plane with
// legs 20 mm along +Y and 20 mm along +Z, its right-angle corner at y = 5, z = 5
// (where the plates meet).
//

base_x  = 25;
base_y  = 45;
base_z  = 5;
screw_h = 4.5;
hole_x1 = -17;
hole_y1 = 30;
hole_x2 = 17;
hole_y2 = 30;

motor_x = 25;
motor_y = 5;
motor_z = 50;
boss_d  = 23;
boss_x  = 0;
boss_z  = 28;
screw_d = 3.4;
screw_p = 31;

gusset_t = 5;
gusset_l = 20;
gusset_h = 20;
gusset_y = 5;
gusset_z = 5;

$fn = 48;

difference() {
    union() {
        cube([base_x * 2, base_y, base_z]);                                     // base plate
        cube([motor_x * 2, motor_y, motor_z]);                                 // vertical motor plate
        for (x = [-1, 1])
            translate([x * (base_x - gusset_l), 0, 0])
                cube([gusset_l, gusset_y, gusset_h]);                        // gussets (left and right)
    }
    for (i = [0, 1])                                                           // two vertical through-holes (M4)
        translate([hole_x1, hole_y1, 0])
            cylinder(h = base_z + motor_z, d = screw_h, $fn = 48);
    for (i = [0, 1])                                                           // motor boss hole (along Y)
        translate([boss_x, -1, boss_z])
            rotate([0, 90, 0])
                cylinder(h = motor_y + 0.01, d = boss_d);
    for (dx = [-1, 1]; dz = [-1, 1])                                           // M3 screw holes (31 mm square, centred on boss hole)
        translate([boss_x + dx * screw_p / 2, motor_y / 2, boss_z + dz * screw_p / 2])
            cylinder(h = motor_z + 1, d = screw_d);
}