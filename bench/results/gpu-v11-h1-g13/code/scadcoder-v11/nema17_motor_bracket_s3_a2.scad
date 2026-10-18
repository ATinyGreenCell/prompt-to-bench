// L-shaped mounting bracket for NEMA 17 stepper motor
// Print orientation: base plate on bed (z = 0), motor plate builds upward

// ---------- Parameters ----------
base_x      = 25;    // base plate length in X
base_y      = 45;    // base plate length in Y
base_t      = 5;     // base plate thickness (Z)

screw_d     = 4.5;   // through-hole diameter (M4)
screw_x     = 17;    // screw hole offset from centre (X)
screw_y     = 30;    // screw hole offset from centre (Y)

motor_h     = 50;    // motor plate height (Z)
motor_d     = 23;    // motor boss hole diameter
boss_x      = 0;     // boss hole centre (X)
boss_z      = 28;    // boss hole centre (Z)

screw_d2    = 3.4;   // M3 screw holes diameter
screw_pat   = 31;    // square pattern size (X and Y)

gusset_t    = 5;     // gusset thickness (X)
gusset_l    = 20;    // gusset leg length (Y and Z)

eps         = 0.5;   // cutter overshoot

$fn = 96;

// ---------- Model ----------
difference() {
    union() {
        // Base plate
        translate([-base_x, 0, 0])
            cube([2 * base_x, base_y, base_t]);

        // Motor plate
        translate([-base_x + eps, 0, 0])
            cube([motor_x, base_y, motor_h]);
    }

    // Screw holes in base plate
    for (sx = [-1, 1])
        translate([sx * screw_x, screw_y, -eps])
            cylinder(d = screw_d, h = base_t + 2 * eps);

    // Motor boss hole
    translate([boss_x, 0, boss_z])
        cylinder(d = motor_d, h = base_y + eps);

    // M3 screw holes on square pattern
    for (a = [0, 90, 180, 270])
        rotate([0, 0, a])
            translate([0, 0, -eps])
                cylinder(d = screw_d2, h = motor_h + 2 * eps);

    // Gussets
    for (sx = [gusset_x0, gusset_x1])
        translate([sx, 0, 0])
            rotate([90, 0, 0])
                linear_extrude(height = gusset_l)
                    polygon([[0, 0], [gusset_l, 0], [0, gusset_l]]);
}