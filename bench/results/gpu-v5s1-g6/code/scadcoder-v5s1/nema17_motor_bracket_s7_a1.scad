// L-shaped mounting bracket for a NEMA 17 stepper motor (e.g. syringe pump)
// Print orientation: base plate on the bed, motor plate builds upward.

$fn = 64;

// ---- Base plate ----
base_x1 = -25;      // base plate x start
base_x2 = 25;       // base plate x end
base_y1 = 0;        // base plate y start
base_y2 = 45;       // base plate y end
base_z1 = 0;        // base plate z start
base_z2 = 5;        // base plate z end

// ---- Motor plate ----
motor_x1 = -25;     // motor plate x start
motor_x2 = 25;      // motor plate x end
motor_y1 = 0;       // motor plate y start
motor_y2 = 5;       // motor plate y end
motor_z1 = 0;       // motor plate z start
motor_z2 = 50;      // motor plate z end

// ---- Boss hole ----
boss_d = 23;        // boss hole diameter
boss_x = 0;         // boss hole x centre
boss_z = 28;        // boss hole z centre

// ---- Screw holes ----
screw_d = 3.4;      // M3 screw hole diameter
screw_pitch = 31;   // square pattern side length
screw_n = 4;        // number of screw holes

// ---- Gussets ----
gusset_t = 5;       // gusset thickness (X)
gusset_y = 20;      // gusset leg along +Y
gusset_z = 20;      // gusset leg along +Z

// ---- Through holes ----
th_d = 4.5;         // vertical through-hole diameter (M4)
th_x = -17;         // through-hole x position
th_y = 30;          // through-hole y position

// ---- Cutting overshoot ----
eps = 0.5;          // extension past faces for clean cuts

union() {
    // Base plate with through-holes
    difference() {
        translate([base_x1, base_y1, base_z1])
            cube([base_x2 - base_x1, base_y2 - base_y1, base_z2 - base_z1]);
        for (i = [0 : screw_n - 1]) {
            rotate([0, 0, i * 90])
                translate([th_x, th_y, -eps])
                    cylinder(d = th_d, h = base_z2 - base_z1 + 2 * eps);
        }
    }

    // Motor plate with boss hole and screw holes
    difference() {
        translate([motor_x1, motor_y1, motor_z1])
            cube([motor_x2 - motor_x1, motor_y2 - motor_y1, motor_z2 - motor_z1]);
        translate([boss_x, -eps, boss_z])
            cylinder(d = boss_d, h = motor_y2 - motor_y1 + 2 * eps);
        for (i = [0 : screw_n - 1]) {
            rotate([0, 0, i * 90])
                translate([-screw_pitch / 2, -eps, boss_z - screw_pitch / 2])
                    cylinder(d = screw_d, h = motor_y2 - motor_y1 + 2 * eps);
        }
    }

    // Gussets, flush with left and right edges
    for (sx = [-1, 1]) {
        x0 = sx > 0 ? motor_x2 - gusset_t : motor_x1;
        translate([x0, gusset_y, gusset_z])
            linear_extrude(gusset_t)
                polygon([[0, 0], [gusset_y, 0], [0, gusset_z]]);
    }
}