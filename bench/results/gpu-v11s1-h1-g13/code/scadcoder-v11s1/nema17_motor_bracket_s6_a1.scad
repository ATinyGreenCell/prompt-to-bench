// L-shaped mounting bracket for NEMA 17 stepper motor (e.g. syringe pump)
// Print orientation: base plate on bed, motor plate building upward (+Z)

$fn = 64;

// ---- Base plate ----
base_x0 = -25;      // plate x start
base_x1 = 25;       // plate x end
base_y0 = 0;        // plate y start
base_y1 = 45;       // plate y end
base_z  = 5;        // plate thickness (z)

// ---- Motor plate ----
motor_x0 = -25;     // plate x start
motor_x1 = 25;      // plate x end
motor_y0 = 0;       // plate y start
motor_y1 = 5;       // plate y end
motor_z  = 50;      // plate height (z)

// ---- Boss hole (motor centring) ----
boss_d     = 23;    // hole diameter
boss_x     = 0;     // hole centre x
boss_z     = 28;    // hole centre z

// ---- Screw holes ----
screw_d    = 3.4;   // hole diameter (M3)
screw_n    = 4;     // number of holes
screw_pitch = 31;   // square pattern side length
screw_x0   = -15.5; // first hole x offset

// ---- Gussets ----
gusset_t      = 5;     // gusset thickness (x)
gusset_y      = 20;    // leg length along +Y
gusset_z      = 20;    // leg length along +Z
gusset_x_start = -25;   // left gusset x start
gusset_x_end   = 25;    // right gusset x end

// ---- Misc ----
eps = 0.5;          // cutter overshoot past faces

difference() {
    union() {
        // Base plate
        translate([base_x0, base_y0, 0])
            cube([base_x1 - base_x0, base_y1 - base_y0, base_z]);

        // Motor plate, standing on back edge of base
        translate([motor_x0, motor_y0, 0])
            cube([motor_x1 - motor_x0, motor_y1 - motor_y0, motor_z]);

        // Gussets, flush with left and right edges
        for (x = [gusset_x_start, gusset_x_end])
            translate([x, motor_y1, 0])
                cube([gusset_t, gusset_y, gusset_z]);
    }

    // Boss hole through motor plate (along Y)
    translate([boss_x, 0, boss_z])
        rotate([90, 0, 0])
            cylinder(d = boss_d, h = motor_y1 - motor_y0 + 2 * eps, center = true);

    // Screw holes on square pattern
    for (i = [0 : screw_n - 1]) {
        x = screw_x0 + (i % 2) * screw_pitch;
        z = screw_x0 + (i < 2) * screw_pitch;
        translate([x, 0, z])
            cylinder(d = screw_d, h = motor_z + 2 * eps);
    }
}