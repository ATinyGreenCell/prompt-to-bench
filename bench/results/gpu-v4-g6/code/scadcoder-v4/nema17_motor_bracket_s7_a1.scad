// L-shaped mounting bracket for NEMA 17 stepper motor (e.g. syringe pump)
// Print orientation: base plate on bed, motor plate builds upward (+Z)

// ---------------- Parameters ----------------
base_x      = 25;    // base plate half-length in X (plate spans -25 to 25)
base_y      = 45;    // base plate length in Y (0 to 45)
base_z      = 5;     // base plate thickness

motor_x     = 25;    // motor plate half-length in X (plate spans -25 to 25)
motor_y     = 5;     // motor plate thickness in Y (0 to 5)
motor_z     = 50;    // motor plate height in Z (0 to 50)

boss_d      = 23;    // motor centring boss hole diameter
boss_x      = 0;     // boss hole centre X
boss_z      = 28;    // boss hole centre Z

screw_d     = 3.4;   // M3 screw hole diameter
screw_n     = 4;     // number of screw holes
screw_p     = 31;    // square pattern side length (centred on boss hole)

gusset_t    = 5;     // gusset thickness in X
gusset_x0   = -25;   // left gusset start X
gusset_x1   = -20;   // left gusset end X
gusset_y    = 20;    // gusset leg along +Y (from y = 5)
gusset_z    = 20;    // gusset leg along +Z (from z = 5)

eps         = 0.5;   // cutter overshoot past faces
$fn         = 96;    // curve resolution

// ---------------- Model ----------------
difference() {
    union() {
        // Base plate
        translate([-base_x, 0, 0])
            cube([2 * base_x, base_y, base_z]);

        // Vertical motor plate
        translate([-motor_x, 0, 0])
            cube([2 * motor_x, motor_y, motor_z]);

        // Gussets (right-angle corner at y = 5, z = 5)
        for (sx = [-1, 1])
            translate([sx * (gusset_x0 + gusset_t / 2), 5, 5])
                linear_extrude(height = gusset_t)
                    polygon([[0, 0], [gusset_y, 0], [0, gusset_z]]);
    }

    // Base plate M4 through-holes
    translate([-17, 30, -eps])
        cylinder(d = 4.5, h = base_z + 2 * eps);
    translate([17, 30, -eps])
        cylinder(d = 4.5, h = base_z + 2 * eps);

    // Motor plate boss hole (along Y) and M3 screw holes
    translate([boss_x, -eps, boss_z])
        cylinder(d = boss_d, h = motor_y + 2 * eps);
    for (i = [0 : screw_n - 1]) {
        a = screw_p * (i - (screw_n - 1) / 2);
        translate([0, a, boss_z])
            cylinder(d = screw_d, h = motor_y + 2 * eps);
    }
}