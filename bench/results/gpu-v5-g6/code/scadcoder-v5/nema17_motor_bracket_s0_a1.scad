// L-shaped mounting bracket for NEMA 17 stepper motor (e.g. syringe pump)
// Print orientation: base plate on bed, vertical plate builds up in +Z

$fn = 64;

// ---- Base plate ----
base_x1 = -25;      // base plate left edge (X)
base_x2 = 25;       // base plate right edge (X)
base_y  = 45;       // base plate depth (Y)
base_t  = 5;        // base plate thickness (Z)

// ---- Motor plate ----
motor_x1 = -25;     // motor plate left edge (X)
motor_x2 = 25;      // motor plate right edge (X)
motor_y  = 5;       // motor plate depth (Y)
motor_h  = 50;      // motor plate height (Z)

// ---- Boss hole ----
boss_d   = 23;      // motor centring boss hole diameter
boss_x   = 0;       // boss hole centre X
boss_z   = 28;      // boss hole centre Z

// ---- Screw holes ----
screw_d = 3.4;      // M3 screw hole diameter
screw_pitch = 31;   // square pattern side length

// ---- Gussets ----
gusset_t = 5;       // gusset thickness (X)
gusset_leg = 20;    // right triangle legs along +Y and +Z

// ---- Cutting overlap ----
eps = 0.5;          // extension past cut faces

// ---- Derived ----
leg1 = [base_x1, base_y, base_t];                 // base plate left leg
leg2 = [motor_x2 - gusset_t, base_y, motor_h];    // motor plate right leg
leg3 = [motor_x2 - gusset_t, base_y, gusset_t];   // gusset right leg
leg4 = [base_x1 + gusset_t, base_y, gusset_t];    // gusset left leg
leg5 = [base_x1 + gusset_t, base_y, motor_h];     // base plate left leg (full)

difference() {
    union() {
        translate(leg1) cube(leg1);
        translate(leg2) cube(leg2);
        translate(leg3) cube(leg3);
        translate(leg4) cube(leg4);
        translate(leg5) cube(leg5);
    }

    // Base plate through-holes (M4)
    translate([-17, 30, -eps]) cylinder(d = 4.5, h = base_t + 2 * eps);
    translate([17, 30, -eps]) cylinder(d = 4.5, h = base_t + 2 * eps);

    // Motor plate boss hole (along Y)
    translate([boss_x, -eps, boss_z]) cylinder(d = boss_d, h = motor_y + 2 * eps);

    // Motor plate screw holes (M3, square pattern)
    for (i = [0 : 3]) {
        a = i % 2;
        b = i / 2;
        translate([b * screw_pitch - screw_pitch / 2,
                   a * screw_pitch - screw_pitch / 2,
                   -eps])
            cylinder(d = screw_d, h = motor_y + 2 * eps);
    }
}