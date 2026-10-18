// L-shaped mounting bracket for a NEMA 17 stepper motor
// Print orientation: base plate on the bed (z = 0), vertical plate builds upward.

// ---------------- Parameters ----------------
plate_x       = 25;    // base plate half-length in X (mm)
plate_y       = 45;    // base plate length in Y (mm)
plate_t       = 5;     // base plate thickness (mm)

motor_h       = 50;    // vertical motor plate height (mm)
motor_w       = 25;    // vertical motor plate half-width in X (mm)

boss_d        = 23;    // diameter of the motor centring-boss hole (mm)
boss_x        = 0;     // boss hole centre X (mm)
boss_z        = 28;    // boss hole centre Z (mm)

screw_d       = 3.4;   // M3 screw hole diameter (mm)
screw_pitch   = 31;    // square pattern pitch for the four screw holes (mm)

gusset_t      = 5;     // gusset thickness along X (mm)
gusset_y      = 20;    // gusset leg length along +Y (mm)
gusset_z      = 20;    // gusset leg length along +Z (mm)

eps           = 0.5;   // cutter overshoot past faces (mm)
$fn           = 96;    // curve resolution

// ---------------- Model ----------------
difference() {
    union() {
        // Base plate
        translate([-plate_x, 0, 0])
            cube([plate_x * 2, plate_y, plate_t]);

        // Vertical motor plate, standing on the back edge of the base
        translate([-motor_w, 0, 0])
            cube([motor_w * 2, plate_t, motor_h]);
    }

    // Base-plate through-holes (M4)
    for (h = [-1, 1])
        translate([-17 * h, 30, -eps])
            cylinder(d = 4.5, h = plate_t + 2 * eps);

    // Motor-boss hole along Y, centred at x = 0, z = 28
    translate([boss_x, -eps, boss_z])
        rotate([-90, 0, 0])
            cylinder(d = boss_d, h = plate_t + 2 * eps);

    // Four M3 screw holes on a 31 mm square pattern, centred on the boss hole
    for (a = [0, 90, 180, 270])
        rotate([0, 0, a])
            translate([screw_pitch / 2, 0, 0])
                cylinder(d = screw_d, h = motor_h + 2 * eps, center = true);

    // Triangular gussets, flush with the left and right edges
    for (sx = [-1, 1])
        translate([sx * (plate_x - gusset_t), 0, 0])
            rotate([90, 0, 0])
                linear_extrude(height = gusset_t)
                    polygon(points = [
                        [gusset_y, gusset_z],
                        [plate_t, gusset_z],
                        [plate_t, gusset_y]
                    ]);
}