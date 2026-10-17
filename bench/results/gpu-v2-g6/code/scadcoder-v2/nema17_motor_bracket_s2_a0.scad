// L-shaped mounting bracket for a NEMA 17 stepper motor (e.g. syringe pump).
// Base plate with two vertical through-holes, motor plate with a centring boss hole
// and a screw pattern, plus two triangular gussets at the edges.
//

base_x  = 25;
base_y  = 45;
base_z  = 5;
screw_h = 4.5;

motor_x = 25;
motor_y = 5;
motor_z = 50;
boss_h  = 23;
screw_p = 31;
screw_d = 3.4;

gusset_t = 5;
gusset_l = 20;
gusset_h = 20;

$fn = 48;

base_holes = [p = [-17, 30], [17, 30]];
motor_holes = [p = [0, 0], z = 28];   // boss hole
screw_holes = for (i = [0:3]) [p = [0, 0], z = 28 + i * 7.75];  // 31 mm square, pitch 7.75 mm

difference() {
    union() {
        translate([-base_x / 2, 0, 0]) cube([base_x, base_y, base_z]);
        translate([-motor_x / 2, 0, 0]) cube([motor_x, motor_y, motor_z]);
        for (x = [-base_x / 2, base_x / 2])
            translate([x, 0, 0]) linear_extrude(motor_y)
                polygon([[-gusset_l, gusset_h], [-gusset_l, 0], [gusset_l, 0]]);
    }
    for (p = base_holes) translate([p[0], p[1], -1]) cylinder(h = base_z + 2, d = screw_h);
    for (h = motor_holes) translate([h.p[0], motor_y / 2, h.z]) rotate([-90, 0, 0])
        cylinder(h = motor_y + 2, d = boss_h);
    for (p = screw_holes) translate([p.p[0], motor_y / 2, p.z]) rotate([-90, 0, 0])
        cylinder(h = motor_y + 2, d = screw_d);
}