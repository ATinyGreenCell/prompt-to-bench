// L-shaped mounting bracket for a NEMA 17 stepper motor
// Print orientation: base plate flat on the bed, vertical plate upright

// ---------------- Parameters ----------------
base_x       = 25;    // base plate length in X (from -25 to +25)
base_y       = 45;    // base plate length in Y (from 0 to 45)
base_t       = 5;     // base plate thickness in Z (0 to 5)

motor_pl_h   = 50;    // vertical motor plate height in Z (0 to 50)
motor_pl_y   = 5;     // vertical plate thickness in Y (0 to 5)

boss_d       = 23;    // diameter of motor centring boss hole
boss_x       = 0;     // boss hole centre X
boss_z       = 28;    // boss hole centre Z

screw_d      = 3.4;   // M3 screw hole diameter
screw_p      = 31;    // side of square screw pattern
screw_n      = 4;     // number of screw holes

gusset_t     = 5;     // gusset thickness in X
gusset_y     = 20;    // gusset leg along +Y
gusset_z     = 20;    // gusset leg along +Z

eps          = 0.5;   // cutter overshoot past faces

$fn = 96;

// ---------------- Model ----------------
difference() {
    union() {
        // Base plate
        translate([-base_x, 0, 0])
            cube([base_x * 2, base_y, base_t]);

        // Vertical motor plate
        translate([-base_x, base_y - motor_pl_y, 0])
            cube([base_x * 2, motor_pl_y, motor_pl_h]);

        // Gussets: right triangles in YZ, flush with left/right edges
        for (sx = [-1, 1])
            translate([sx * (base_x - gusset_t), 0, 0])
                rotate([90, 0, 0])
                    linear_extrude(height = gusset_t)
                        polygon([[gusset_y, gusset_z],
                                 [gusset_y + eps, gusset_z],
                                 [gusset_y + eps, motor_pl_y]]);
    }

    // Base plate through-holes (M4)
    for (h = [base_t + eps, motor_pl_h + eps])
        translate([-17, 30, -eps])
            cylinder(d = 4.5, h = h);

    // Boss hole along Y
    translate([boss_x, -eps, boss_z])
        rotate([0, 90, 0])
            cylinder(d = boss_d, h = base_y + 2 * eps);

    // Screw holes on square pattern
    for (i = [0 : screw_n - 1])
        translate([(i - (screw_n - 1) / 2) * screw_p,
                   (i - (screw_n - 1) / 2) * screw_p,
                   -eps])
            cylinder(d = screw_d, h = motor_pl_h + 2 * eps);
}