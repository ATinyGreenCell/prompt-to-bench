// L-shaped mounting bracket for a NEMA 17 stepper motor (e.g. syringe pump).
// Base plate with two vertical through-holes; vertical motor plate with a
// motor-centring boss hole and a 3 mm screw pattern; two triangular gussets
// flush with the edges. NOVEL general part.
//

base_x   = 25;
base_y   = 45;
base_z   = 5;
screw_h1 = 4.5;
screw_x1 = -17;
screw_y1 = 30;
screw_x2 = 17;
screw_y2 = 30;

motor_x  = 25;
motor_y  = 5;
motor_z  = 50;
boss_h   = 23;
boss_x   = 0;
boss_z   = 28;
screw_h2 = 3.4;
screw_p  = 31;

$fn = 48;

gusset_t = 5;
gusset_y = 20;
gusset_z = 20;

difference() {
    union() {
        translate([-base_x / 2, 0, 0]) cube([base_x, base_y, base_z]);      // base plate
        translate([-motor_x / 2, 0, 0]) cube([motor_x, motor_y, motor_z]);  // motor plate
        translate([-base_x / 2, gusset_y, gusset_z]) rotate([0, 90, 0]) cube([base_x, gusset_y, gusset_z]);  // left gusset
        translate([base_x / 2 - 1, gusset_y, gusset_z]) rotate([0, -90, 0]) cube([base_x, gusset_y, gusset_z]);  // right gusset
    }
    for (x = [screw_x1, screw_x2])
        translate([x, screw_y1 - 1, -1]) cylinder(h = base_z + 2, d = screw_h1);                 // vertical through-holes
    translate([0, motor_y / 2 - 1, boss_z]) rotate([-90, 0, 0]) cylinder(h = motor_y + 2, d = boss_h);  // boss hole
    for (a = [0, 90, 180, 270])
        rotate([0, 0, a]) translate([screw_p / 2, motor_y / 2, boss_z]) cylinder(h = motor_y + 2, d = screw_h2);  // screw holes
}