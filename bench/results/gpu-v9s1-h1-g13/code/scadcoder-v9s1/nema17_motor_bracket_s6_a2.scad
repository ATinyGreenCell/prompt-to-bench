// L-shaped mounting bracket for a NEMA 17 stepper motor
// Print orientation: base plate lies on the bed (z = 0), vertical plate builds upward.

// ---------------- Parameters ----------------
plate_x      = 25;    // base plate: x from -25 to 25 (mm)
plate_y      = 45;    // base plate: y from 0 to 45 (mm)
plate_t      = 5;     // base plate thickness (mm)

motor_x      = 25;    // motor plate: x from -25 to 25 (mm)
motor_y      = 5;     // motor plate: y from 0 to 5 (mm)
motor_h      = 50;    // motor plate height, z from 0 to 50 (mm)

boss_d       = 23;    // motor centring boss hole diameter (mm)
boss_x       = 0;     // boss hole centre x (mm)
boss_z       = 28;    // boss hole centre z (mm)

screw_d      = 3.4;   // M3 screw hole diameter (mm)
screw_pitch  = 31;    // square pattern pitch for screw holes (mm)
screw_count  = 4;     // number of screw holes

gusset_t     = 5;     // gusset thickness along x (mm)
gusset_leg   = 20;    // right-triangle leg length along +y and +Z (mm)

eps          = 0.5;   // cutter overshoot past faces (mm)
$fn          = 96;    // curve resolution

// ---------------- Model ----------------
difference() {
    // ---- Bodies ----
    union() {
        // Base plate
        translate([-plate_x, 0, 0])
            cube([plate_x * 2, plate_y, plate_t]);

        // Vertical motor plate, standing on the back edge of the base
        translate([-motor_x, plate_y - motor_y, 0])
            cube([motor_x * 2, motor_y, motor_h]);
    }

    // ---- Cutouts ----
    // Two vertical through-holes in the base plate
    for (h = [plate_t, plate_t + eps])
        for (sx = [-17, 17])
            for (sy = [30])
                translate([sx, sy, 0])
                    cylinder(d = 4.5, h = h, $fn = 64);

    // Boss hole and screw holes, all through the motor plate along Y
    translate([boss_x, plate_y - motor_y - eps, boss_z])
        rotate([0, 90, 0]) {
            cylinder(d = boss_d, h = motor_y + 2 * eps, $fn = 96);

            // Square pattern centred on the boss hole
            for (i = [-1, 1])
                for (j = [-1, 1])
                    translate([i * screw_pitch / 2, 0, j * screw_pitch / 2])
                        cylinder(d = screw_d, h = motor_y + 2 * eps, $fn = 64);
        }

    // Triangular gussets, flush with the left and right edges
    // Right triangle in YZ: legs along +Y and +Z, right angle at y = 5, z = 5
    for (gx = [-25, 20])
        translate([gx, plate_y - gusset_t, 0])
            rotate([90, 0, 0])
                linear_extrude(height = gusset_t)
                    polygon(points = [
                        [gusset_leg, gusset_leg],
                        [gusset_leg, 0],
                        [0, gusset_leg]
                    ]);
}