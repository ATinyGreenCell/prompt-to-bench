// L-shaped mounting bracket for a NEMA 17 stepper motor (e.g. syringe pump).
// Base plate with two vertical through-holes; vertical motor plate with a
// motor-centring boss hole and a 3 mm screw hole grid; two triangular gussets
// at the edges. NOVEL general part.
//

base_x   = 25;
base_y   = 45;
base_z   = 5;
screw_v1 = [-17, 30];
screw_v2 = [17, 30];
hole_v   = 4.5;

motor_x  = 25;
motor_y  = 5;
motor_z  = 50;
boss_h   = 23;
boss_c   = [0, 22.5, 28];
screw_p  = 31;
screw_h  = 3.4;

gusset_t = 5;
gusset_l = 20;
gusset_h = 20;

$fn = 48;

base_diff = difference() {
    translate([-base_x / 2, 0, 0]) cube([base_x, base_y, base_z]);
    for (v = [screw_v1, screw_v2])
        translate(v) rotate([0, 90, 0]) cylinder(h = base_z + 1, d = hole_v);
}

motor_diff = difference() {
    translate([-motor_x / 2, 0, 0]) cube([motor_x, motor_y, motor_z]);
    translate(boss_c) rotate([-90, 0, 0]) cylinder(h = motor_y + 1, d = boss_h);
    for (x = [-motor_x / 2, motor_x / 2])
        for (y = [-motor_x / 2, motor_x / 2])
            translate([x, y, -1]) cylinder(h = motor_z + 2, d = screw_h);
}

gusset() {
    translate([0, 5, 5]) rotate([0, 90, 0]) linear_extrude(gusset_t) polygon([[0, 0], [gusset_l, 0], [0, gusset_h]]);
}

union() {
    base_diff;
    motor_diff;
    gusset();
    mirror([1, 0, 0]) gusset();
}