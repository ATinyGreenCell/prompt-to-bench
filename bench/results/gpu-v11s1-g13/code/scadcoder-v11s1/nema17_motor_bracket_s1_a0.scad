// L-shaped mounting bracket for NEMA 17 stepper motor (e.g. syringe pump)
// Print orientation: base plate on the bed, motor plate building upward (+Z)

$fn = 64;

// ---------------- Dimensions (mm) ----------------
base_x0      = -25;   // base plate: x from -25 to 25
base_x1      = 25;
base_y0      = 0;     // base plate: y from 0 to 45
base_y1      = 45;
base_z0      = 0;     // base plate: z from 0 to 5
base_z1      = 5;

hole_m4_x1   = -17;   // M4 through-hole in base plate (x)
hole_m4_y1   = 30;    // M4 through-hole in base plate (y)
hole_m4_d    = 4.5;   // M4 hole diameter

hole_m4_x2   = 17;    // M4 through-hole in base plate (x)
hole_m4_y2   = 30;    // M4 through-hole in base plate (y)

motor_x0     = -25;   // motor plate: x from -25 to 25
motor_x1     = 25;
motor_y0     = 0;     // motor plate: y from 0 to 5
motor_y1     = 5;
motor_z0     = 0;     // motor plate: z from 0 to 50
motor_z1     = 50;

boss_hole_d  = 23;    // motor centring boss hole diameter
boss_hole_x  = 0;     // boss hole centre x
boss_hole_z  = 28;    // boss hole centre z

screw_d      = 3.4;   // M3 screw hole diameter
screw_pitch  = 31;    // square pattern side length for screws
screw_count  = 4;     // number of screw holes

gusset_t     = 5;     // gusset thickness (X direction)
gusset_leg   = 20;    // right triangle leg length (along +Y and +Z)
gusset_x0    = -25;   // left gusset start x
gusset_x1    = -20;   // left gusset end x
gusset_x2    = 20;    // right gusset start x
gusset_x3    = 25;    // right gusset end x

eps          = 0.5;   // cutter overshoot past faces

// ---------------- Model ----------------
difference() {
    union() {
        // Base plate
        translate([base_x0, base_y0, base_z0])
            cube([base_x1 - base_x0, base_y1 - base_y0, base_z1 - base_z0]);

        // Vertical motor plate, standing on the back edge of the base
        translate([motor_x0, motor_y0, motor_z0])
            cube([motor_x1 - motor_x0, motor_y1 - motor_y0, motor_z1 - motor_z0]);

        // Triangular gussets, flush with left and right edges
        for (gx = [gusset_x0, gusset_x2]) {
            translate([gx, motor_y1, motor_z1])
                rotate([90, 0, 0])
                    linear_extrude(height = gusset_t)
                        polygon(points = [
                            [0, 0],
                            [gusset_leg, 0],
                            [0, gusset_leg]
                        ]);
        }
    }

    // Base plate through-holes for M4 screws
    for (hx = [hole_m4_x1, hole_m4_x2]) {
        for (hy = [hole_m4_y1, hole_m4_y2]) {
            translate([hx, hy, -eps])
                cylinder(d = hole_m4_d, h = base_z1 + 2 * eps);
        }
    }

    // Motor plate hole for motor centring boss (along Y)
    translate([boss_hole_x, 0, boss_hole_z])
        rotate([0, 90, 0])
            cylinder(d = boss_hole_d, h = motor_y1 + 2 * eps, center = true);

    // M3 screw holes on a square pattern, centred on the boss hole
    for (i = [0 : screw_count - 1]) {
        for (j = [0 : screw_count - 1]) {
            x = -screw_pitch / 2 + (i + 1) * screw_pitch / screw_count;
            z = -screw_pitch / 2 + (j + 1) * screw_pitch / screw_count;
            translate([x, 0, z])
                cylinder(d = screw_d, h = motor_z1 + 2 * eps);
        }
    }
}