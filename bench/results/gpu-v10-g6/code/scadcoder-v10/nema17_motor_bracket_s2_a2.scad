// L-shaped mounting bracket for NEMA 17 stepper motor (syringe pump)
// Print orientation: base plate on bed, vertical plate builds upward

// ---------- Parameters ----------
base_x0      = -25;   // base plate X start
base_x1      = 25;    // base plate X end
base_y0      = 0;     // base plate Y start
base_y1      = 45;    // base plate Y end
base_z0      = 0;     // base plate Z start
base_z1      = 5;     // base plate Z end

hole_x       = -17;   // M4 hole X (left)
hole_y       = 30;    // M4 hole Y
hole_x2      = 17;    // M4 hole X (right)

motor_x0     = -25;   // motor plate X start
motor_x1     = 25;    // motor plate X end
motor_y0     = 0;     // motor plate Y start
motor_y1     = 5;     // motor plate Y end
motor_z0     = 0;     // motor plate Z start
motor_z1     = 50;    // motor plate Z end

boss_d       = 23;    // boss hole diameter
boss_x       = 0;     // boss hole X centre
boss_z       = 28;    // boss hole Z centre

screw_d      = 3.4;   // M3 screw hole diameter
screw_pitch  = 31;    // screw pattern side length

gusset_t     = 5;     // gusset thickness
gusset_leg   = 20;    // gusset leg length (Y and Z)

eps          = 0.5;   // cutter overshoot

$fn = 96;

// ---------- Model ----------
union() {
    // Base plate with M4 holes
    difference() {
        translate([base_x0, base_y0, base_z0])
            cube([base_x1 - base_x0, base_y1 - base_y0, base_z1 - base_z0]);

        for (x = [hole_x, hole_x2])
            translate([x, hole_y, -eps])
                cylinder(d = 4.5, h = base_z1 - base_z0 + 2 * eps);
    }

    // Motor plate with boss hole and M3 screws
    difference() {
        translate([motor_x0, motor_y0, motor_z0])
            cube([motor_x1 - motor_x0, motor_y1 - motor_y0, motor_z1 - motor_z0]);

        translate([boss_x, -eps, boss_z])
            cylinder(d = boss_d, h = motor_y1 - motor_y0 + 2 * eps);

        for (i = [0 : 3]) {
            a = screw_pitch / 2 * (i % 2 == 0 ? 1 : -1);
            b = screw_pitch / 2 * (i / 2 == 0 || i % 2 == 0 ? 1 : -1);
            translate([b, -eps, a])
                cylinder(d = screw_d, h = motor_y1 - motor_y0 + 2 * eps);
        }
    }

    // Gussets (right-angle corner at y = 5, z = 5)
    for (sx = [-1, 1])
        translate([sx > 0 ? 20 : -25, 5, 5])
            linear_extrude(height = gusset_t)
                polygon(points = [
                    [0, 0],
                    [gusset_leg, 0],
                    [0, gusset_leg]
                ]);
}