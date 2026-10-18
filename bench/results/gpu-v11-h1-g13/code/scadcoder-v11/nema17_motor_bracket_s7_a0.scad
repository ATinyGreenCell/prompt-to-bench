// L-shaped mounting bracket for a NEMA 17 stepper motor (e.g. syringe pump)
// Print orientation: base plate on the bed (z = 0), vertical plate builds upward.

// ---------------- Parameters ----------------
base_x0      = -25;    // base plate, x start
base_x1      = 25;     // base plate, x end
base_y0      = 0;      // base plate, y start
base_y1      = 45;     // base plate, y end
base_z0      = 0;      // base plate, z start
base_z1      = 5;      // base plate, z end

motor_x0     = -25;    // motor plate, x start
motor_x1     = 25;     // motor plate, x end
motor_y0     = 0;      // motor plate, y start
motor_y1     = 5;      // motor plate, y end
motor_z0     = 0;      // motor plate, z start
motor_z1     = 50;     // motor plate, z end

boss_d       = 23;     // motor centring boss hole diameter
boss_x       = 0;      // boss hole centre, x
boss_z       = 28;     // boss hole centre, z

screw_d      = 3.4;    // M3 screw holes diameter
screw_p      = 31;     // screw pattern size (square)
screw_count  = 4;      // number of screw holes

eps          = 0.5;    // cutter overshoot past faces

$fn = 96;              // curve resolution

// ---------------- Model ----------------
difference() {
    union() {
        // Base plate
        translate([base_x0, base_y0, base_z0])
            cube([base_x1 - base_x0, base_y1 - base_y0, base_z1 - base_z0]);

        // Vertical motor plate
        translate([motor_x0, motor_y0, motor_z0])
            cube([motor_x1 - motor_x0, motor_y1 - motor_y0, motor_z1 - motor_z0]);

        // Gussets: right triangles in YZ, 5 mm thick, flush with left/right edges
        for (sx = [-1, 1])
            translate([sx > 0 ? motor_x1 - 5 : base_x0, 0, 0])
                rotate([90, 0, 0])
                    linear_extrude(height = 5)
                        polygon([
                            [0, 0],
                            [20, 0],
                            [0, 20]
                        ]);
    }

    // Base plate M4 through-holes
    for (x = [-17, 17], y = 30)
        translate([x, y, -eps])
            cylinder(d = 4.5, h = base_z1 + 2 * eps);

    // Motor plate boss hole (along Y)
    translate([boss_x, motor_y0 - eps, boss_z])
        rotate([0, 90, 0])
            cylinder(d = boss_d, h = motor_y1 - motor_y0 + 2 * eps);

    // M3 screw holes on a square pattern centred on the boss hole
    for (i = [0 : screw_count - 1]) {
        x = (i % 2 - 0.5) * screw_p;
        z = (i / 2 - 0.5) * screw_p + boss_z;
        translate([x, motor_y0 - eps, z])
            rotate([0, 90, 0])
                cylinder(d = screw_d, h = motor_y1 - motor_y0 + 2 * eps);
    }
}