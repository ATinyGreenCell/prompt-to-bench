// L-shaped mounting bracket for a NEMA 17 stepper motor (e.g. syringe pump)
// Print orientation: base plate on the bed, motor plate building upward.

$fn = 64;

// ---------------- Dimensions (mm) ----------------
base_x      = 25;    // base plate half-width (X)
base_y      = 45;    // base plate length (Y)
base_z      = 5;     // base plate thickness (Z)

motor_h     = 50;    // motor plate height (Z)
motor_y     = 5;     // motor plate thickness (Y)

boss_d      = 23;    // motor centring boss hole diameter
boss_x      = 0;     // boss hole centre X
boss_z      = 28;    // boss hole centre Z

screw_d     = 3.4;   // M3 screw hole diameter
screw_p     = 31;    // square pattern side length
screw_n     = 4;     // number of screw holes

gusset_t    = 5;     // gusset thickness (X)
gusset_y    = 20;    // gusset leg along +Y
gusset_z    = 20;    // gusset leg along +Z

eps         = 0.5;   // cutter overshoot past faces

// ---------------- Model ----------------
difference() {
    union() {
        // Base plate
        translate([-base_x, 0, 0])
            cube([base_x * 2, base_y, base_z]);

        // Motor plate (standing on the back edge of the base)
        translate([-base_x, base_y - motor_y, 0])
            cube([base_x * 2, motor_y, motor_h]);

        // Left gusset: right triangle in YZ, flush with x = -25
        translate([-base_x, 0, 0])
            rotate([90, 0, 0])
                linear_extrude(height = gusset_t)
                    polygon(points = [
                        [gusset_y, gusset_z],
                        [0,        gusset_z],
                        [0,        0]
                    ]);

        // Right gusset: right triangle in YZ, flush with x = +25
        translate([base_x - gusset_t, 0, 0])
            rotate([90, 0, 0])
                linear_extrude(height = gusset_t)
                    polygon(points = [
                        [gusset_y, gusset_z],
                        [0,        gusset_z],
                        [0,        0]
                    ]);
    }

    // Base plate through-holes (M4)
    for (h = [base_z + eps, -eps])
        translate([-17, 30, h])
            cylinder(d = 4.5, h = abs(h) + base_z + 2 * eps);

    // Motor boss hole (along Y) and screw holes (square pattern)
    translate([boss_x, 0, boss_z])
        rotate([0, 90, 0]) {
            difference() {
                cylinder(d = boss_d, h = motor_y + 2 * eps);
                translate([0, -eps, 0])
                    cylinder(d = boss_d + 2 * eps, h = motor_y + 2 * eps);
            }
        }

    for (i = [0 : screw_n - 1])
        for (j = [0 : screw_n - 1])
            translate([(i - (screw_n - 1) / 2) * screw_p,
                       (j - (screw_n - 1) / 2) * screw_p,
                       -eps])
                cylinder(d = screw_d, h = motor_y + 2 * eps);
}