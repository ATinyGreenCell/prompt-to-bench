// L-shaped mounting bracket for a NEMA 17 stepper motor (e.g. syringe pump).
// Base plate with two vertical through-holes; vertical motor plate with a
// motor-centring boss hole and a 3 mm screw pattern; two triangular gussets
// at the edges. NOVEL general part.
//

base_x   = 25;
base_y   = 45;
base_z   = 5;
screw_h  = 4.5;
motor_y  = 5;
motor_z  = 50;
boss_h   = 23;
screw_p  = 31;
gusset_t = 5;
gusset_l = 20;
gusset_w = 20;

$fn = 48;

base_holes = [
    [-17, 30],
    [17, 30]
];

motor_holes = [
    [0, -1, 28],
    [0, 1, 28],
    [-15.5, 0, 15.5],
    [-15.5, 0, 34.5],
    [15.5, 0, 15.5],
    [15.5, 0, 34.5]
];

difference() {
    union() {
        translate([-base_x, 0, 0]) cube([base_x * 2, base_y, base_z]);                 // base plate
        translate([-base_x, 0, 0]) cube([base_x * 2, motor_y, motor_z]);               // motor plate
        for (x = [-base_x, base_x])
            translate([x, 0, 0])
                linear_extrude(motor_y) rotate([0, 90, 0]) triangle([0, 0, 0], [gusset_l, 0, 0], [0, gusset_w, gusset_l]);  // gussets
    }
    for (p = base_holes)
        translate(p) cylinder(h = base_z + 1, d = screw_h);
    for (p = motor_holes)
        translate(p) cylinder(h = motor_y + 1, d = p[2] == 0 ? boss_h : screw_p);
}