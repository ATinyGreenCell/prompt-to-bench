// L-shaped mounting bracket for NEMA 17 stepper motor
// Print orientation: base plate flat on the bed, motor plate vertical

// ---------- Parameters ----------
plate_x      = 25;    // base plate half-width (X)
plate_y      = 45;    // base plate length (Y)
plate_t      = 5;     // base plate thickness (Z)

motor_h      = 50;    // motor plate height (Z)
motor_w      = 5;     // motor plate thickness (Y)

boss_d       = 23;    // motor boss hole diameter
boss_x       = 0;     // boss hole centre X
boss_z       = 28;    // boss hole centre Z

screw_d      = 3.4;   // M3 screw hole diameter
screw_pitch  = 31;    // square pattern pitch (X and Y)

gusset_t     = 5;     // gusset thickness (X)
gusset_y     = 20;    // gusset leg along Y
gusset_z     = 20;    // gusset leg along Z

eps          = 0.5;   // cutter overshoot past faces
$fn          = 96;    // curve resolution

// ---------- Model ----------
difference() {
    union() {
        // Base plate
        translate([-plate_x, 0, 0])
            cube([plate_x * 2, plate_y, plate_t]);

        // Motor plate, flush with the back edge of the base
        translate([-plate_x, plate_y - motor_w, 0])
            cube([plate_x * 2, motor_w, motor_h]);
    }

    // Base plate through-holes (M4)
    for (z = [plate_t / 2, plate_t - plate_t / 2 + eps])
        translate([-17, 30, z])
            cylinder(d = 4.5, h = plate_t + eps, $fn = 64);

    // Boss hole and screw holes, all in the same (X, Z) plane
    translate([boss_x, plate_y - motor_w - eps, boss_z])
        rotate([90, 0, 0]) {
            cylinder(d = boss_d, h = motor_w + 2 * eps, $fn = 96);
            for (i = [-1, 1])
                for (j = [-1, 1])
                    translate([i * screw_pitch / 2, j * screw_pitch / 2, 0])
                        cylinder(d = screw_d, h = motor_w + 2 * eps, $fn = 64);
        }

    // Triangular gussets, right-angle corner at the plate junction
    for (sx = [-1, 1])
        translate([sx * (plate_x - gusset_t), gusset_y, gusset_z])
            rotate([90, 0, 0])
                linear_extrude(height = gusset_t)
                    polygon(points = [
                        [0, 0],
                        [gusset_y, 0],
                        [0, gusset_z]
                    ]);
}