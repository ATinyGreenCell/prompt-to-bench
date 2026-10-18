// L-shaped mounting bracket for NEMA 17 stepper motor (e.g. syringe pump)
// Print orientation: base plate on the bed (z = 0), motor plate builds upward.

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
motor_y1 = 5;       // plate y end (height)
motor_h  = 50;      // plate top z

// ---- Boss hole ----
boss_d     = 23;    // motor centring boss hole diameter
boss_x     = 0;     // hole centre x
boss_z     = 28;    // hole centre z

// ---- Screw holes ----
screw_d    = 3.4;   // M3 screw hole diameter
screw_n    = 4;     // number of screw holes
screw_pitch = 31;   // square pattern side length

// ---- Gussets ----
gusset_t     = 5;   // gusset thickness (x)
gusset_leg   = 20;  // right triangle leg lengths (Y and Z)
gusset_x0    = -25; // left edge x
gusset_x1    = -20; // left triangle x end
gusset_x2    = 20;  // right triangle x start
gusset_x3    = 25;  // right edge x

// ---- Misc ----
eps = 0.5;          // cutter overshoot past faces

difference() {
    union() {
        // Base plate
        translate([base_x0, base_y0, 0])
            cube([base_x1 - base_x0, base_y1 - base_y0, base_t]);

        // Motor plate (overlaps base slightly for a clean union)
        translate([motor_x0, motor_y0, 0])
            cube([motor_x1 - motor_x0, motor_y1 - motor_y0, motor_h]);

        // Gussets, flush with left and right edges
        for (sx = [-1, 1])
            translate([sx * gusset_x0, gusset_y0, gusset_z0])
                linear_extrude(height = gusset_t)
                    polygon(points = gusset_pts(sx));
    }

    // Boss hole along Y
    translate([boss_x, 0, boss_z])
        rotate([90, 0, 0])
            cylinder(d = boss_d, h = base_y1 - base_y0 + 2 * eps, center = true);

    // M3 screw holes on a square pattern, centred on the boss hole
    for (i = [0 : screw_n - 1]) {
        x = -screw_pitch / 2 + (i % 2) * screw_pitch / 2;
        y = -screw_pitch / 2 + (i / 2) % 2 * screw_pitch / 2;
        translate([x, y, boss_z])
            cylinder(d = screw_d, h = motor_h + eps);
    }
}