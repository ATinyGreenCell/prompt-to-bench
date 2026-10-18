// L-shaped mounting bracket for NEMA 17 stepper motor
// Print orientation: base plate on bed (z = 0), motor plate builds upward (+Z)

$fn = 64;

// ---- Base plate ----
base_x0 = -25;      // base plate x start
base_x1 = 25;       // base plate x end
base_y0 = 0;        // base plate y start
base_y1 = 45;       // base plate y end
base_z0 = 0;        // base plate z start
base_z1 = 5;        // base plate z end (thickness)

// ---- Motor plate ----
motor_x0 = -25;     // motor plate x start
motor_x1 = 25;      // motor plate x end
motor_y0 = 0;       // motor plate y start
motor_y1 = 5;       // motor plate y end (thickness)
motor_z0 = 0;       // motor plate z start (bottom of plate)
motor_z1 = 50;      // motor plate z end (top of plate)

// ---- Boss hole ----
boss_d = 23;        // boss hole diameter
boss_x = 0;         // boss hole x centre
boss_z = 28;        // boss hole z centre

// ---- Screw holes ----
screw_d = 3.4;      // M3 screw hole diameter
screw_pitch = 31;   // square pattern side length
screw_count = 4;    // number of screw holes

// ---- Gussets ----
gusset_t = 5;       // gusset thickness (along X)
gusset_leg = 20;    // right triangle leg lengths (along Y and Z)
gusset_x0 = -25;    // left gusset x start
gusset_x1 = -20;    // left gusset x end
gusset_y1 = 5;      // gusset Y leg end
gusset_z1 = 5;      // gusset Z leg end

// ---- Misc ----
eps = 0.5;          // cutter overshoot past faces

difference() {
    union() {
        // Base plate
        translate([base_x0, base_y0, base_z0])
            cube([base_x1 - base_x0, base_y1 - base_y0, base_z1 - base_z0]);

        // Vertical motor plate
        translate([motor_x0, motor_y0, motor_z0])
            cube([motor_x1 - motor_x0, motor_y1 - motor_y0, motor_z1 - motor_z0]);

        // Triangular gussets
        for (sx = [-1, 1]) {
            translate([sx * gusset_x0, 0, 0])
                rotate([90, 0, 0])
                    linear_extrude(height = gusset_t)
                        polygon(points = [
                            [gusset_y1, 0],
                            [gusset_y1, gusset_leg],
                            [0, gusset_leg]
                        ]);
        }
    }

    // Boss hole
    translate([boss_x, 0, boss_z])
        rotate([0, 90, 0])
            cylinder(d = boss_d, h = motor_y1 - motor_y0 + 2 * eps, center = true);

    // Screw holes
    for (i = [0 : screw_count - 1]) {
        for (j = [0 : screw_count - 1]) {
            x = (j - (screw_count - 1) / 2) * screw_pitch;
            y = (i - (screw_count - 1) / 2) * screw_pitch;
            translate([x, y, -eps])
                cylinder(d = screw_d, h = motor_z1 - motor_z0 + 2 * eps);
        }
    }
}