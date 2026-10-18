// L-shaped mounting bracket for NEMA 17 stepper motor (syringe pump)
// Print orientation: base plate flat on bed, motor plate building up in +Z

$fn = 64;

// ---- Base plate ----
base_x0 = -25;      // base plate X start
base_x1 = 25;       // base plate X end
base_y0 = 0;        // base plate Y start
base_y1 = 45;       // base plate Y end
base_t  = 5;        // base plate thickness (Z)

// ---- Motor plate ----
motor_x0 = -25;     // motor plate X start
motor_x1 = 25;      // motor plate X end
motor_y0 = 0;       // motor plate Y start
motor_y1 = 5;       // motor plate Y end
motor_h  = 50;      // motor plate height (Z)

// ---- Boss hole (motor centring boss) ----
boss_d     = 23;    // boss hole diameter
boss_x     = 0;     // boss hole centre X
boss_z     = 28;    // boss hole centre Z
boss_h     = motor_y1 - motor_y0 + 2;  // hole height along Y (overruns faces)

// ---- Screw holes (M3, on square pattern) ----
screw_d    = 3.4;   // screw hole diameter
screw_n    = 4;     // number of screw holes
screw_a    = 31;    // square pattern size (centre to centre)
screw_z    = motor_h - 5;  // screw holes near top face

// ---- Gussets ----
gusset_t   = 5;     // gusset thickness (X)
gusset_leg = 20;    // right triangle leg lengths (Y and Z)
gusset_x0  = motor_x0 - 5;  // left gusset X start
gusset_x1  = motor_x0;      // left gusset X end / right gusset X start
gusset_x2  = motor_x1;      // right gusset X end
fuse       = 0.01;                // small overlap so gussets fuse into plates

// ---- Cutting overshoot ----
eps = 0.5;          // extension past cut faces

difference() {
    union() {
        // Base plate
        translate([base_x0, base_y0, 0])
            cube([base_x1 - base_x0, base_y1 - base_y0, base_t]);

        // Motor plate
        translate([motor_x0, motor_y0, 0])
            cube([motor_x1 - motor_x0, motor_y1 - motor_y0, motor_h]);

        // Gussets: right triangle in YZ, legs along +Y and +Z
        for (sx = [-1, 1])
            translate([sx > 0 ? gusset_x1 : gusset_x0,
                       gusset_leg,
                       gusset_leg])
                cube([gusset_t, gusset_leg, gusset_leg]);
    }

    // Boss hole
    translate([boss_x, -eps, boss_z])
        rotate([-90, 0, 0])
            cylinder(d = boss_d, h = boss_h);

    // Screw holes
    for (i = [0 : screw_n - 1]) {
        x = (i % 2 - 0.5) * 2 * screw_a;
        y = floor(i / 2 - 0.5) * 2 * screw_a;
        translate([x, y, boss_z - screw_z])
            cylinder(d = screw_d, h = screw_z + eps);
    }
}