// L-shaped mounting bracket for NEMA 17 stepper motor
// Print orientation: base plate flat on bed, motor plate vertical

$fn = 64;

// ---- Base plate ----
base_x = 25;    // plate extends from -x to +x
base_y = 45;    // plate extends from y = 0 to y = base_y
base_t = 5;     // plate thickness (z = 0 to 5)

// ---- Motor plate ----
motor_h = 50;   // plate height (z = 0 to 50)
motor_w = 5;    // plate thickness (y = 0 to 5)

// ---- Boss hole ----
boss_d  = 23;   // hole diameter
boss_x  = 0;    // hole centre X
boss_z  = 28;   // hole centre Z

// ---- Screw holes ----
screw_d = 3.4;  // hole diameter
screw_n = 4;    // number of holes
screw_s = 31;   // square pattern size (corner to corner)

// ---- Gussets ----
gusset_t = 5;   // gusset thickness (X direction)
gusset_l = 20;  // gusset leg lengths (Y and Z)

// ---- Misc ----
eps = 0.5;      // overshoot for clean cuts

difference() {
    union() {
        // Base plate
        translate([-base_x, 0, 0])
            cube([2 * base_x, base_y, base_t]);

        // Motor plate (overlaps base plate for a solid union)
        translate([-base_x, 0, 0])
            cube([2 * base_x, motor_w, motor_h]);

        // Gussets: right-triangle profile in YZ, extruded along X
        // flush with the outer edges at x = -base_x and x = +base_x
        for (sx = [-1, 1])
            translate([sx * (base_x - gusset_t), 0, 0])
                rotate([90, 0, 0])
                    linear_extrude(height = gusset_t)
                        polygon(points = [
                            [gusset_l, gusset_l],
                            [gusset_l, 0],
                            [0, gusset_l]
                        ]);
    }

    // Boss hole (through along Y)
    translate([boss_x, -eps, boss_z])
        rotate([0, 90, 0])
            cylinder(d = boss_d, h = motor_w + 2 * eps);

    // Screw holes on a square pattern centred on the boss hole
    for (i = [0 : screw_n - 1]) {
        a = 45 + i * 90;
        r = screw_s / 2;
        translate([r * cos(a), r * sin(a), 0])
            cylinder(d = screw_d, h = motor_h + 2 * eps);
    }
}