// L-shaped mounting bracket for a NEMA 17 stepper motor (e.g. syringe pump)
// Print orientation: base plate on the bed, motor plate building upward (+Z)

// ---------------- Parameters ----------------
plate_x      = 25;    // base plate half-length in X (mm)
plate_y      = 45;    // base plate length in Y (mm)
plate_t      = 5;     // base plate thickness (mm)

motor_h      = 50;    // motor plate height (mm)
motor_w      = 5;     // motor plate thickness in Y (mm)

boss_d       = 23;    // motor centring boss hole diameter (mm)
boss_x       = 0;     // boss hole centre X (mm)
boss_z       = 28;    // boss hole centre Z (mm)

screw_d      = 3.4;   // M3 screw hole diameter (mm)
screw_pitch  = 31;    // square pattern pitch for screw holes (mm)

gusset_t     = 5;     // gusset thickness along X (mm)
gusset_leg   = 20;    // gusset leg length along +Y and +Z (mm)

eps          = 0.5;   // cutter overshoot past faces (mm)
$fn          = 96;    // curve resolution

// ---------------- Model ----------------
difference() {
    union() {
        // Base plate
        translate([-plate_x, 0, 0])
            cube([plate_x * 2, plate_y, plate_t]);

        // Vertical motor plate, standing on the back edge of the base
        translate([-plate_x, plate_y - motor_w, 0])
            cube([plate_x * 2, motor_w, motor_h]);

        // Triangular gussets, flush with left and right edges
        // Right triangle in YZ plane: legs along +Y and +Z, right angle at (y=5, z=5)
        for (sx = [-1, 1])
            rotate([90, 0, 0])
                translate([sx * (plate_x - gusset_t), 0, 0])
                    cube([gusset_t, gusset_leg, gusset_leg]);
    }

    // Base plate through-holes (M4) at (x = -17, y = 30) and (x = 17, y = 30)
    for (x = [-17, 17])
        translate([x, plate_y / 2, -eps])
            cylinder(d = 4.5, h = plate_t + 2 * eps);

    // Motor plate hole for the centring boss, along Y, centred at (x = 0, z = 28)
    translate([boss_x, -eps, boss_z])
        cylinder(d = boss_d, h = motor_w + 2 * eps);

    // Four M3 screw holes on a 31 mm square pattern, centred on the boss hole
    for (a = [0, 90, 180, 270])
        rotate([0, 0, a])
            translate([screw_pitch / 2, screw_pitch / 2, 0])
                translate([0, 0, -eps])
                    cylinder(d = screw_d, h = motor_w + 2 * eps);
}