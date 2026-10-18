// L-shaped mounting bracket for NEMA 17 stepper motor
// Print orientation: base plate on bed (z = 0), motor plate builds upward (+Z)

// ---------- Dimensions (mm) ----------
base_x0      = -25;   // base plate x start
base_x1      = 25;    // base plate x end
base_y0      = 0;     // base plate y start
base_y1      = 45;    // base plate y end
base_z1      = 5;     // base plate thickness (z end)

motor_x0     = -25;   // motor plate x start
motor_x1     = 25;    // motor plate x end
motor_y0     = 0;     // motor plate y start
motor_y1     = 5;     // motor plate y end (thickness)
motor_z1     = 50;    // motor plate top (z end)

boss_d       = 23;    // motor centring boss hole diameter
boss_x       = 0;     // boss hole centre x
boss_z       = 28;    // boss hole centre z

screw_d      = 3.4;   // M3 screw holes diameter
screw_p      = 31;    // screw hole square pattern side length

gusset_t     = 5;     // gusset thickness (X)
gusset_y     = 20;    // gusset leg along +Y
gusset_z     = 20;    // gusset leg along +Z

eps          = 0.5;   // cutter overshoot past faces

$fn = 96;             // curve resolution

// ---------- Model ----------
difference() {
    union() {
        // Base plate
        translate([base_x0, base_y0, 0])
            cube([base_x1 - base_x0, base_y1 - base_y0, base_z1]);

        // Vertical motor plate
        translate([motor_x0, motor_y0, 0])
            cube([motor_x1 - motor_x0, motor_y1 - motor_y0, motor_z1]);

        // Left triangular gusset (x = -25 to -20)
        translate([-25, 0, 0])
            rotate([90, 0, 0])
                linear_extrude(height = gusset_t)
                    polygon(points = [
                        [0, gusset_y],
                        [gusset_z, gusset_y],
                        [0, 0]
                    ]);

        // Right triangular gusset (x = 20 to 25)
        translate([20, 0, 0])
            rotate([90, 0, 0])
                linear_extrude(height = gusset_t)
                    polygon(points = [
                        [0, gusset_y],
                        [gusset_z, gusset_y],
                        [0, 0]
                    ]);
    }

    // Boss hole for motor centring boss
    translate([boss_x, motor_y1, boss_z])
        cylinder(d = boss_d, h = motor_y1 + 2 * eps, center = true);

    // M3 screw holes on 31 mm square pattern, centred on boss hole
    for (a = [0, 90, 180, 270])
        rotate([0, 0, a])
            translate([screw_p / 2, 0, -eps])
                cylinder(d = screw_d, h = motor_z1 + 2 * eps);
}