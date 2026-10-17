// L-shaped mounting bracket for a NEMA 17 stepper motor (syringe pump, bench top). NOVEL general part.
//

base_d  = 50;
base_t  = 5;
arm_l   = 50;
arm_t   = 5;
motor_h = 50;
screw  = 4.5;

$fn = 48;

gusset_t = 5;
tunnel   = screw + 5;

difference() {
    union() {
        cube([base_d, base_t, base_t]);                                              // base plate (square, for stability)
        cube([base_d, arm_l, arm_t]);                                                 // motor arm
        cube([base_d, arm_l, motor_h]);                                               // standing motor plate
        for (x = [-base_d / 2, base_d / 2])
            translate([x, 0, 0]) rotate([0, 90, 0]) cylinder(h = arm_l + 4, d = tunnel);   // motor mount holes (along Y)
        for (x = [-15.5, 15.5])
            translate([0, x, 0]) rotate([90, 0, 0]) cylinder(h = arm_l + 4, d = tunnel);   // motor mount holes (along X)
        for (s = [-15.5, 15.5])
            translate([0, s, -1]) cube([base_d, screw + 2, base_t + 2]);              // screw holes in the arm
    }
    for (x = [-base_d / 2, base_d / 2])
        translate([x, 0, 0]) rotate([0, 90, 0]) cylinder(h = arm_l + 4, d = screw);   // motor mount holes (along Y)
    for (x = [-15.5, 15.5])
        translate([0, x, 0]) rotate([90, 0, 0]) cylinder(h = arm_l + 4, d = screw);   // motor mount holes (along X)
}

for (dir = [-1, 1]) {
    translate([dir * (base_d / 2 - 10), 0, 0])
        difference() {
            cube([base_t, 20, 20]);                                              // gusset (right triangle in the YZ plane)
            translate([base_t, 0, -1]) cube([base_t, 5, 21]);                    // pocket the gusset into the arm so it bonds
        }
}