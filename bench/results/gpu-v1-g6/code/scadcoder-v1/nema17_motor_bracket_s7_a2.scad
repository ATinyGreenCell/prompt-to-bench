// L-shaped mounting bracket for a NEMA 17 stepper motor. NOVEL general structural part.
//

base_d  = 50;
base_t  = 5;
arm_l   = 50;
arm_t   = 5;
screw  = 4.5;

$fn = 48;

gusset_t = 5;
gusset_leg = 20;

difference() {
    union() {
        cube([base_d, base_t, base_t]);                 // base plate (square, not rectangular - the user's X range -25..25 is 50 mm)
        cube([base_d, arm_l, arm_t]);                   // vertical motor plate
        for (x = [-25, 25])
            translate([x, 0, 0])
                linear_extrude(arm_l)
                    polygon([[0, gusset_leg], [gusset_leg, gusset_leg], [gusset_leg, 0]]);   // gussets
    }
    translate([-17, base_t, -1]) cylinder(h = base_t + 2, d = screw);
    translate([17, base_t, -1]) cylinder(h = base_t + 2, d = screw);
    translate([0, arm_t, 28 - 11.5]) rotate([0, 90, 0]) cylinder(h = base_d + 2, d = 23);                 // motor boss hole (along Y)
    for (z = [28 - 15.5, 28 + 15.5])
        translate([0, arm_t, z]) rotate([90, 0, 0]) cylinder(h = base_d + 2, d = screw);                  // M3 screw holes
}