// L-shaped mounting bracket for NEMA 17 stepper motor (syringe pump)
// Print orientation: base plate on bed, motor plate building upward (+Z)

// ---------- Parameters ----------
base_x0   = -25;  // base plate X start
base_x1   = 25;   // base plate X end
base_y0   = 0;    // base plate Y start
base_y1   = 45;   // base plate Y end
base_z0   = 0;    // base plate Z start
base_z1   = 5;    // base plate Z end

hole_m4_x = -17;  // M4 through-hole X position
hole_m4_y = 30;   // M4 through-hole Y position

motor_x0  = -25;  // motor plate X start
motor_x1  = 25;   // motor plate X end
motor_y0  = 0;    // motor plate Y start
motor_y1  = 5;    // motor plate Y end
motor_z0  = 0;    // motor plate Z start
motor_z1  = 50;   // motor plate Z end

boss_d    = 23;   // motor boss hole diameter
boss_x    = 0;    // boss hole X centre
boss_z    = 28;   // boss hole Z centre

screw_d   = 3.4;  // M3 screw holes diameter
screw_n   = 4;    // number of screw holes
screw_p   = 31;   // square pattern size (centre to centre)

gusset_t  = 5;    // gusset thickness
gusset_x0 = -25;  // gusset left edge
gusset_x1 = -20;  // gusset right edge (left triangle)
gusset_y0 = 5;    // triangle leg along Y
gusset_z0 = 5;    // triangle leg along Z

eps       = 0.5;  // cutter overshoot past faces

$fn = 64;

// ---------- Model ----------
difference() {
    union() {
        // Base plate
        translate([base_x0, base_y0, base_z0])
            cube([base_x1 - base_x0, base_y1 - base_y0, base_z1 - base_z0]);

        // Motor plate
        translate([motor_x0, motor_y0, motor_z0])
            cube([motor_x1 - motor_x0, motor_y1 - motor_y0, motor_z1 - motor_z0]);

        // Gussets (right triangles in YZ plane, flush with left/right edges)
        for (gx = [gusset_x0, gusset_x1 - 0.01])
            translate([gx, gusset_y0, gusset_z0])
                cube([gusset_x1 - gx + 0.01, gusset_y0, gusset_z0]);
    }

    // Base plate M4 holes
    translate([hole_m4_x, hole_m4_y, -eps])
        cylinder(d = 4.5, h = base_z1 - base_z0 + 2 * eps);

    // Motor boss hole (along Y)
    translate([boss_x, -eps, boss_z])
        cylinder(d = boss_d, h = motor_y1 - motor_y0 + 2 * eps);

    // M3 screw holes on square pattern
    for (i = [0 : screw_n - 1]) {
        x = boss_x + (i % 2) * (screw_p / 2);
        y = boss_z + (i / 2) * (screw_p / 2);
        translate([x, y, -eps])
            cylinder(d = screw_d, h = motor_z1 - motor_z0 + 2 * eps);
    }
}