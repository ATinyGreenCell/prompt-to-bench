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
            translate([x, 0, 0]) cube([base_d, gusset_t, arm_l]);                     // gussets
    }
    translate([0, -1, 0]) rotate([-90, 0, 0]) cylinder(h = arm_l + 2, d = tunnel);   // motor centre tunnel (Y axis)
    for (z = [28, 28 + 31 / sqrt(2) * 2])                                     // 4 screw holes: 2 x 2 grid in the XZ plane
        translate([0, 0, z]) rotate([0, 90, 0]) cylinder(h = base_t + arm_l + 2, d = screw);
}