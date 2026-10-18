// L-shaped mounting bracket for a NEMA 17 stepper motor (e.g., syringe pump)
// Print orientation: base plate lies on the bed (z = 0), motor plate builds upward.

// ---------------- Parameters ----------------
base_x      = 25;    // base plate half-width (X: -25 .. 25)
base_y      = 45;    // base plate length (Y: 0 .. 45)
base_t      = 5;     // base plate thickness (Z: 0 .. 5)

motor_h     = 50;    // motor plate height (Z: 0 .. 50)
motor_w     = 5;     // motor plate thickness (Y: 0 .. 5)

boss_d      = 23;    // motor centring boss hole diameter
boss_x      = 0;     // boss hole centre X
boss_z      = 28;    // boss hole centre Z

screw_d     = 3.4;   // M3 screw hole diameter
screw_p     = 31;    // square pattern side length
screw_n     = 4;     // number of screw holes

gusset_t    = 5;     // gusset thickness (X)
gusset_r    = 20;    // gusset leg along +Y
gusset_z    = 20;    // gusset leg along +Z

eps         = 0.5;   // cutter overshoot past faces

$fn = 96;            // curve resolution

// ---------------- Model ----------------
difference() {
    // Base plate
    translate([-base_x, 0, 0])
        cube([base_x * 2, base_y, base_t]);

    // Motor plate (standing on the back edge of the base)
    translate([-base_x, base_y - motor_w, 0])
        cube([base_x * 2, motor_w, motor_h]);

    // Triangular gussets, flush with the left and right edges
    for (sx = [-1, 1])
        translate([sx * (base_x - gusset_t), base_y - motor_w, 0])
            rotate([90, 0, 0])
                linear_extrude(height = gusset_t)
                    polygon(points = [
                        [motor_w, base_t],
                        [motor_w + gusset_r, base_t],
                        [motor_w, base_t + gusset_z]
                    ]);

    // Base plate through-holes (M4)
    for (h = [base_y / 2 - eps, base_y / 2 + eps])
        translate([-17, h, -eps])
            cylinder(d = 4.5, h = base_t + 2 * eps, $fn = 64);

    // Motor boss hole (cut along Y)
    translate([boss_x, base_y - motor_w - eps, boss_z])
        rotate([0, 90, 0])
            cylinder(d = boss_d, h = motor_w + 2 * eps, $fn = 96);

    // M3 screw holes on a square pattern centred on the boss hole
    for (i = [0 : screw_n - 1]) {
        a = i * 90;
        translate([boss_x + (i < 2 ? -1 : 1) * screw_p / 2,
                   base_y - motor_w - eps,
                   boss_z + (i >= 2 ? -1 : 1) * screw_p / 2])
            rotate([0, 90, a])
                cylinder(d = screw_d, h = motor_w + 2 * eps, $fn = 64);
    }
}