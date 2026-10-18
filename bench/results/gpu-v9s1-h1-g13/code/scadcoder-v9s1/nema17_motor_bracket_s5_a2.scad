// L-shaped mounting bracket for NEMA 17 stepper motor
// Print orientation: base plate on bed (z = 0), vertical plate upward (+Z)

// ---------------- Parameters ----------------
base_x0      = -25;   // base plate X start
base_x1      = 25;    // base plate X end
base_y0      = 0;     // base plate Y start
base_y1      = 45;    // base plate Y end
base_z       = 5;     // base plate thickness

motor_h      = 50;    // vertical motor plate height
motor_y0     = 0;     // motor plate Y start (flush with base edge)
motor_y1     = 5;     // motor plate Y end (thickness)

boss_d       = 23;    // motor centring boss hole diameter
boss_x       = 0;     // boss hole X centre
boss_z       = 28;    // boss hole Z centre

screw_d      = 3.4;   // M3 screw hole diameter
screw_n      = 4;     // number of screw holes
screw_p      = 31;    // square pattern pitch (side length)

gusset_t     = 5;     // gusset thickness (along X)
gusset_leg   = 20;    // right-triangle leg length (along Y and Z)
gusset_x0    = -25;   // left gusset X start
gusset_x1    = -20;   // left gusset X end
// right gusset runs from x = 20 to x = 25 (flush with right edge)

eps          = 0.5;   // cutter overshoot past faces

$fn = 96;

// ---------------- Model ----------------
difference() {
    union() {
        // Base plate
        translate([base_x0, base_y0, 0])
            cube([base_x1 - base_x0, base_y1 - base_y0, base_z]);

        // Vertical motor plate
        translate([base_x0, motor_y0, 0])
            cube([base_x1 - base_x0, motor_y1 - motor_y0, motor_h]);

        // Gussets (right-triangle in YZ plane, extruded along X)
        for (sx = [-1, 1]) {
            x0 = sx == -1 ? gusset_x0 : gusset_x1;
            x1 = sx == -1 ? gusset_x1 : gusset_x0;
            translate([x0, 0, 0])
                rotate([90, 0, 0])
                    linear_extrude(height = x1 - x0)
                        polygon(points = [
                            [gusset_leg, gusset_leg],  // right-angle corner at y = 5, z = 5
                            [gusset_leg, 0],
                            [0, gusset_leg]
                        ]);
        }
    }

    // Base plate through-holes (M4)
    for (h = [base_z + eps, -eps]) {
        translate([-17, 30, h])
            cylinder(d = 4.5, h = abs(h) + 0.01);
        translate([17, 30, h])
            cylinder(d = 4.5, h = abs(h) + 0.01);
    }

    // Motor boss hole (along Y) and screw holes on square pattern
    {
        translate([0, 0, 0])
            rotate([90, 0, 0]) {
                difference() {
                    cylinder(d = boss_d, h = motor_h + 2 * eps, center = true);
                    translate([0, -eps, boss_z])
                        cylinder(d = boss_d + 2 * eps, h = motor_h + 2 * eps);
                }
            }
        for (i = [0 : screw_n - 1]) {
            for (j = [0 : screw_n - 1]) {
                translate([(i - (screw_n - 1) / 2) * screw_p,
                           (j - (screw_n - 1) / 2) * screw_p,
                           -eps])
                    cylinder(d = screw_d, h = motor_h + 2 * eps, $fn = 64);
            }
        }
    }
}