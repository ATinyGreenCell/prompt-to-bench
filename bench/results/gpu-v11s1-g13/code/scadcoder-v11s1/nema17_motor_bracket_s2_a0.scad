// L-shaped mounting bracket for NEMA 17 stepper motor
// Print orientation: base plate on bed (z = 0), motor plate builds upward (+Z)
// Positioned per user coordinates (x -25 to 25, y 0 to 45), not centred

// ---------------- Parameters ----------------
base_x0      = -25;   // base plate x start
base_x1      = 25;    // base plate x end
base_y0      = 0;     // base plate y start
base_y1      = 45;    // base plate y end
base_z0      = 0;     // base plate z start
base_z1      = 5;     // base plate z end

hole_m4_x    = -17;   // M4 through-hole x position (left)
hole_m4_y    = 30;    // M4 through-hole y position
hole_m4_d    = 4.5;   // M4 through-hole diameter

hole_m4_x2   = 17;    // M4 through-hole x position (right)

motor_x0     = -25;   // motor plate x start
motor_x1     = 25;    // motor plate x end
motor_y0     = 0;     // motor plate y start
motor_y1     = 5;     // motor plate y end
motor_z0     = 0;     // motor plate z start (on base top)
motor_z1     = 50;    // motor plate z end

boss_d       = 23;    // motor centring boss hole diameter
boss_x       = 0;     // boss hole x centre
boss_z       = 28;    // boss hole z centre

screw_d      = 3.4;   // M3 screw hole diameter
screw_n      = 4;     // number of screw holes
screw_a      = 31;    // square pattern size (centre to centre)

gusset_t     = 5;     // gusset thickness (along X)
gusset_x0    = -25;   // left gusset x start
gusset_x1    = -20;   // left gusset x end
gusset_y1    = 5;     // gusset Y leg end
gusset_z1    = 5;     // gusset Z leg end

eps          = 0.5;   // cutter overshoot past faces

$fn = 96;             // curve resolution

// ---------------- Model ----------------
difference() {
    union() {
        // Base plate
        translate([base_x0, base_y0, base_z0])
            cube([base_x1 - base_x0, base_y1 - base_y0, base_z1 - base_z0]);

        // Vertical motor plate, standing on back edge of base
        translate([motor_x0, motor_y0, motor_z0])
            cube([motor_x1 - motor_x0, motor_y1 - motor_y0, motor_z1 - motor_z0]);

        // Triangular gussets, flush with left and right edges
        for (sx = [-1, 1]) {
            translate([sx * gusset_x0, 0, 0])
                rotate([90, 0, 0])
                    linear_extrude(height = gusset_t)
                        polygon(points = [
                            [gusset_y1, 0],
                            [gusset_y1, gusset_z1],
                            [0, gusset_z1]
                        ]);
        }
    }

    // Base plate through-holes (M4)
    for (hx = [hole_m4_x, hole_m4_x2]) {
        translate([hx, hole_m4_y, -eps])
            cylinder(d = hole_m4_d, h = base_z1 - base_z0 + 2 * eps);
    }

    // Motor plate boss hole (along Y)
    translate([boss_x, 0, boss_z])
        rotate([0, 90, 0])
            cylinder(d = boss_d, h = motor_y1 - motor_y0 + 2 * eps, center = true);

    // M3 screw holes on square pattern, centred on boss hole
    for (i = [0 : screw_n - 1]) {
        for (j = [0 : screw_n - 1]) {
            x = (j - (screw_n - 1) / 2) * screw_a;
            y = (i - (screw_n - 1) / 2) * screw_a;
            translate([x, y, -eps])
                cylinder(d = screw_d, h = motor_z1 - motor_z0 + 2 * eps);
        }
    }
}