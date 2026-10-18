// L-shaped mounting bracket for NEMA 17 stepper motor
// Print orientation: base plate flat on the bed, vertical plate upright.

$fn = 64;

// ---- Base plate ----
plate_x = 25;    // plate extends from -25 to +25 in X
plate_y = 45;    // plate extends from 0 to 45 in Y
plate_t = 5;     // plate thickness in Z (0..5)

// ---- Motor plate ----
motor_x = 25;    // motor plate extends from -25 to +25 in X
motor_y = 5;     // motor plate extends from 0 to 5 in Y
motor_h = 50;    // motor plate height in Z (0..50)

// ---- Boss hole ----
boss_d  = 23;    // diameter of motor centring boss hole
boss_x  = 0;     // hole centre X
boss_z  = 28;    // hole centre Z

// ---- Screw holes ----
screw_d  = 3.4;  // M3 screw hole diameter
pitch   = 31;    // square pattern pitch (centre to centre)
screws  = 4;     // number of screw holes

// ---- Gussets ----
gusset_t = 5;    // gusset thickness along X
gusset_l = 20;   // right-triangle leg length (along +Y and +Z)

// ---- Misc ----
eps = 0.5;       // overshoot for clean boolean cuts

difference() {
    union() {
        // Base plate
        translate([-plate_x, 0, 0])
            cube([plate_x * 2, plate_y, plate_t]);

        // Vertical motor plate, standing on the back edge of the base
        translate([-motor_x, motor_y, 0])
            cube([motor_x * 2, motor_y, motor_h]);

        // Triangular gussets, flush with the left and right edges
        for (sx = [-1, 1])
            translate([sx * (motor_x - gusset_t), motor_y, gusset_l])
                rotate([90, 0, 0])
                    linear_extrude(height = gusset_t)
                        polygon(points = [
                            [0, 0],
                            [gusset_l, 0],
                            [0, gusset_l]
                        ]);
    }

    // Two vertical through-holes in the base plate
    for (px = [-17, 17])
        for (py = 30)
            translate([px, py, -eps])
                cylinder(d = 4.5, h = plate_t + 2 * eps);

    // Boss hole and screw holes, all through the motor plate along Y
    translate([boss_x, 0, boss_z])
        rotate([0, 90, 0]) {
            cylinder(d = boss_d, h = motor_y + 2 * eps, center = true);

            for (i = [-1, 1])
                for (j = [-1, 1])
                    translate([i * pitch / 2, 0, j * pitch / 2])
                        cylinder(d = screw_d, h = motor_y + 2 * eps, center = true);
        }
}