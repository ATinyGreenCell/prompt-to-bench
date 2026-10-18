// L-shaped mounting bracket for NEMA 17 stepper motor (e.g. syringe pump)
// Print orientation: base plate on bed, motor plate builds upward (+Z)

$fn = 64;

// ---- Base plate ----
base_x = 25;              // plate spans x = -25 .. 25
base_y = 45;              // plate spans y = 0 .. 45
base_t = 5;               // plate thickness (z = 0 .. 5)

// ---- Motor plate ----
motor_x = 25;             // plate spans x = -25 .. 25
motor_y = 5;              // plate spans y = 0 .. 5
motor_h = 50;             // plate height (z = 0 .. 50)

// ---- Boss hole (motor centring boss) ----
boss_d = 23;              // hole diameter
boss_x = 0;               // hole centre x
boss_z = 28;              // hole centre z

// ---- Screw holes (M3, on square pattern) ----
screw_d = 3.4;            // hole diameter
screw_n = 4;              // number of holes
screw_a = 31;             // square pattern size (centre to centre)
screw_z = 28;             // hole centre z (same as boss)

// ---- Gussets ----
gusset_t = 5;             // gusset thickness (X)
gusset_l = 20;            // leg length along +Y
gusset_h = 20;            // leg length along +Z
gusset_x0 = -25;          // left gusset start (x = -25 .. -20)

// ---- Misc ----
eps = 0.5;                // cutter overshoot past faces

difference() {
    union() {
        // Base plate
        translate([-base_x, 0, 0])
            cube([2 * base_x, base_y, base_t]);

        // Motor plate, standing on the back edge of the base
        translate([-motor_x, 0, 0])
            cube([2 * motor_x, motor_y, motor_h]);
    }

    // Boss hole through motor plate (along Y)
    translate([boss_x, -eps, boss_z])
        rotate([-90, 0, 0])
            cylinder(d = boss_d, h = motor_y + 2 * eps);

    // M3 screw holes on 31 mm square pattern, centred on boss hole
    for (i = [0 : screw_n - 1]) {
        rotate([0, 0, i * 90])
            translate([0, 0, -eps])
                cylinder(d = screw_d, h = motor_h + 2 * eps);
    }

    // Triangular gussets, flush with left and right edges
    // Right triangle in YZ plane: legs along +Y and +Z, right angle at (y=5, z=5)
    for (sx = [-1, 1])
        translate([sx * (25 - gusset_l / 2), 0, 0])
            rotate([90, 0, 0])
                linear_extrude(height = gusset_t)
                    polygon(points = [[0, 5], [gusset_l, 5], [0, gusset_h]]);
}