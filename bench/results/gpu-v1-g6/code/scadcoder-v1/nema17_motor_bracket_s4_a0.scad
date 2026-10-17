// L-shaped mounting bracket for a NEMA 17 stepper motor (syringe pump, bench top). NOVEL general part.
//

base_d  = 50;
base_t  = 5;
arm_l   = 50;
arm_t   = 5;
motor_h = 50;
screw  = 3.4;

$fn = 48;

gusset_t = 5;

difference() {
    union() {
        cube([base_d, base_t, base_t]);              // base plate (square, not rectangular - the user's X span -25..25 is 50 mm)
        cube([base_d, base_t, base_t]);
        translate([0, base_t, 0]) cube([base_d, arm_l, arm_t]);           // vertical motor plate
        for (x = [-25, 25])
            translate([x, base_t, 0])
                linear_extrude(gusset_t)
                    translate([0, base_t, 0]) cube([20, 20, 1]);           // gussets: right triangle in the YZ plane, legs 20 x 20, right angle at (y=5, z=5)
    }
    translate([0, base_t + 1, 0]) rotate([-90, 0, 0]) cylinder(h = arm_l + 2, d = motor_h);                 // motor boss hole (along Y)
    for (z = [28 - 15.5, 28 + 15.5])
        translate([0, base_t + 1, z]) rotate([-90, 0, 0]) cylinder(h = base_d + 2, d = screw);              // screw holes
}