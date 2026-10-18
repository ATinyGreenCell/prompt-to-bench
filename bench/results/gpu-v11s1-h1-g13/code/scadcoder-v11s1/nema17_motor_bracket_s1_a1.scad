// L-shaped mounting bracket for NEMA 17 stepper motor (e.g. syringe pump)
// Print orientation: base plate on bed, motor plate builds upward (+Z)

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
motor_y1 = 5;       // plate y end (back edge of base)
motor_h  = 50;      // plate height (z)

// ---- Boss hole ----
boss_d     = 23;    // motor centring boss hole diameter
boss_x     = 0;     // hole centre x
boss_z     = 28;    // hole centre z
boss_h     = 1;     // cutter overshoot past top face

// ---- Screw holes ----
screw_d     = 3.4;  // M3 screw hole diameter
screw_pitch = 31;   // square pattern side length
screw_n     = 4;    // number of holes
screw_z     = 28;   // hole depth from top face

// ---- Gussets ----
gusset_t     = 5;   // gusset thickness (x)
gusset_leg   = 20;  // right triangle leg lengths (Y and Z)
gusset_x0    = -25; // left gusset x start
gusset_x1    = -20; // left gusset x end
gusset_x2    = 20;  // right gusset x start
gusset_x3    = 25;  // right gusset x end

// ---- Misc ----
eps = 0.5;          // cutter overshoot for through-holes

difference() {
    union() {
        // Base plate
        translate([base_x0, base_y0, 0])
            cube([base_x1 - base_x0, base_y1 - base_y0, base_t]);

        // Motor plate
        translate([motor_x0, motor_y0, 0])
            cube([motor_x1 - motor_x0, motor_y1 - motor_y0, motor_h]);

        // Gussets (right triangle in YZ plane, flush with edges)
        for (sx = [-1, 1])
            translate([sx > 0 ? gusset_x2 : gusset_x0, 0, 0])
                rotate([90, 0, 0])
                    linear_extrude(height = gusset_t)
                        polygon([
                            [gusset_leg, base_t - eps],   // bottom right (slightly inside base)
                            [0, base_t - eps],            // bottom left
                            [0, motor_h]                   // top left
                        ]);
    }

    // Base plate through-holes (M4)
    for (hx = [-17, 17])
        translate([hx, base_y0 - eps, -eps])
            cylinder(d = 4.5, h = base_t + 2 * eps);

    // Boss hole for motor centring boss
    translate([boss_x, 0, boss_z])
        rotate([0, 90, 0])
            cylinder(d = boss_d, h = boss_h + eps);

    // M3 screw holes on square pattern, centred on boss hole
    for (i = [0 : screw_n - 1]) {
        x = (i - (screw_n - 1) / 2) * screw_pitch;
        y = (i % 2 - (screw_n - 1) / 2) * screw_pitch;
        translate([x, y, motor_y1 - screw_z])
            cylinder(d = screw_d, h = screw_z + eps);
    }
}