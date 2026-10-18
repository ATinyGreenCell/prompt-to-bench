// L-shaped mounting bracket for NEMA 17 stepper motor (e.g. syringe pump)
// Print orientation: base plate on bed (z = 0), motor plate builds upward.

$fn = 64;

// ---- Base plate ----
base_x0 = -25;      // plate x start
base_x1 = 25;       // plate x end
base_y0 = 0;        // plate y start
base_y1 = 45;       // plate y end
base_t  = 5;        // plate thickness (z)

// ---- Motor plate ----
motor_x0 = -25;     // plate x start
motor_x1 = 25;      // plate x end
motor_y0 = 0;       // plate y start
motor_y1 = 5;       // plate y end (sits on back edge of base)
motor_h  = 50;      // plate height (z)

// ---- Boss hole ----
boss_d     = 23;    // motor centring boss hole diameter
boss_x     = 0;     // hole centre x
boss_z     = 28;    // hole centre z

// ---- Screw holes ----
screw_d    = 3.4;   // M3 screw hole diameter
screw_n    = 4;     // number of screw holes
screw_h    = 31;    // square pattern size (x and y)
screw_z    = motor_h - 5;  // hole depth from top face

// ---- Gussets ----
gusset_t   = 5;     // gusset thickness (x)
gusset_leg = 20;    // right triangle leg lengths (Y and Z)
gusset_x0  = -25;   // left gusset x start
gusset_x1  = -20;   // left gusset x end
gusset_x2  = 20;    // right gusset x start
gusset_x3  = 25;    // right gusset x end

eps = 0.5;          // cutter overshoot

difference() {
    union() {
        // Base plate
        translate([base_x0, base_y0, 0])
            cube([base_x1 - base_x0, base_y1 - base_y0, base_t]);

        // Motor plate
        translate([motor_x0, motor_y0, 0])
            cube([motor_x1 - motor_x0, motor_y1 - motor_y0, motor_h]);

        // Gussets (right triangle in YZ, flush with plate edges)
        for (sx = [-1, 1])
            translate([sx > 0 ? gusset_x2 : gusset_x0,
                       gusset_leg,
                       gusset_leg])
                cube([gusset_t, gusset_leg, gusset_leg]);
    }

    // Boss hole through motor plate (along Y)
    translate([boss_x, -eps, boss_z])
        rotate([-90, 0, 0])
            cylinder(d = boss_d, h = motor_y1 - motor_y0 - 2 * eps);

    // Screw holes on square pattern around boss
    for (i = [0 : screw_n - 1]) {
        a = boss_h + screw_h * (i - (screw_n - 1) / 2);
        translate([a, 0, boss_z - screw_z])
            cylinder(d = screw_d, h = screw_z + eps);
    }
}